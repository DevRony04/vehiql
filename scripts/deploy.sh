#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -o errexit
set -o pipefail
set -o nounset

# Configuration
DEPLOY_DIR="${1:-.}"
NEW_IMAGE="${2:-}"
HEALTH_CHECK_URL="http://localhost:3000"
MAX_ATTEMPTS=15
ATTEMPT_DELAY_SECONDS=2

echo "============================================="
echo "Starting deployment at $(date)"
echo "Deployment Directory: ${DEPLOY_DIR}"
echo "New Image: ${NEW_IMAGE}"
echo "============================================="

# Ensure target directory exists
cd "${DEPLOY_DIR}"

# 1. Record the previous image tag for rollback
echo "Checking current running container..."
PREVIOUS_IMAGE=""
if docker inspect vehiql-app >/dev/null 2>&1; then
    PREVIOUS_IMAGE=$(docker inspect --format='{{.Config.Image}}' vehiql-app)
    echo "Current active image is: ${PREVIOUS_IMAGE}"
else
    echo "No existing container 'vehiql-app' found. This is a fresh deployment."
fi

# Export new image name for docker-compose.prod.yml
if [ -n "${NEW_IMAGE}" ]; then
    export DOCKER_IMAGE_NAME="${NEW_IMAGE}"
else
    # Fallback to local default if not passed
    export DOCKER_IMAGE_NAME="ghcr.io/devrony04/vehiql-app:latest"
fi

# 2. Pull the new image
echo "Pulling the new image: ${DOCKER_IMAGE_NAME}..."
docker compose -f docker-compose.prod.yml pull app

# Function to perform rollback
rollback() {
    echo "============================================="
    echo "CRITICAL: Deployment verification failed!"
    echo "Initiating rollback strategy..."
    echo "============================================="
    
    if [ -n "${PREVIOUS_IMAGE}" ]; then
        echo "Rolling back to previous stable image: ${PREVIOUS_IMAGE}..."
        export DOCKER_IMAGE_NAME="${PREVIOUS_IMAGE}"
        docker compose -f docker-compose.prod.yml up -d --no-deps app
        echo "Rollback completed. Restored previous container state."
    else
        echo "No previous stable image found to roll back to. Stopping container."
        docker compose -f docker-compose.prod.yml stop app || true
    fi
    
    exit 1
}

# 3. Start the application container
echo "Starting Next.js container (restarting only affected service 'app')..."
docker compose -f docker-compose.prod.yml up -d --no-deps app

# 4. Run Prisma Database Migrations
echo "Running database migrations inside container..."
if ! docker compose -f docker-compose.prod.yml exec -T app npx prisma migrate deploy; then
    echo "ERROR: Prisma database migrations failed!"
    rollback
fi

# 5. Perform Health Check
echo "Performing health checks at ${HEALTH_CHECK_URL}..."
HEALTH_PASSED=false
for ((attempt=1; attempt<=MAX_ATTEMPTS; attempt++)); do
    echo "Attempt ${attempt}/${MAX_ATTEMPTS}: Verifying app response..."
    
    # Check if container is running first
    CONTAINER_STATUS=$(docker inspect --format='{{.State.Status}}' vehiql-app 2>/dev/null || echo "not-found")
    if [ "${CONTAINER_STATUS}" != "running" ]; then
        echo "  Warning: Container is in '${CONTAINER_STATUS}' state."
    else
        # Perform HTTP check (accepting any 2xx or 3xx status code)
        HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "${HEALTH_CHECK_URL}" || echo "000")
        echo "  HTTP Status Code: ${HTTP_STATUS}"
        
        # Next.js may return 200, 302, 307 etc.
        if [[ "${HTTP_STATUS}" =~ ^(200|301|302|307|308|401)$ ]]; then
            echo "  Success: Health check passed!"
            HEALTH_PASSED=true
            break
        fi
    fi
    
    sleep ${ATTEMPT_DELAY_SECONDS}
done

if [ "${HEALTH_PASSED}" = false ]; then
    echo "ERROR: Application health check timed out or failed."
    rollback
fi

# 6. Cleanup unused older Docker images to conserve space
echo "Pruning older, dangling images..."
docker image prune -f

echo "============================================="
echo "Deployment completed SUCCESSFULLY at $(date)!"
echo "============================================="
