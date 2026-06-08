# VehiQL CI/CD Pipeline & Deployment Documentation

This document describes the automated Continuous Integration (CI) and Continuous Delivery (CD) pipeline designed for the **VehiQL** production environment using GitHub Actions, Docker, and Docker Compose.

---

## 🚀 Pipeline Architecture Overview

The automation pipeline is split into two distinct workflows targeting different phases of the lifecycle:

```mermaid
graph TD
    A[Code Push / PR] --> B(CI Workflow)
    B --> C[npm ci]
    B --> D[Prisma Schema Validate & Gen]
    B --> E[ESLint Verification]
    B --> F[Next.js Production Standalone Build]
    B --> G[Docker Build dry-run]
    B --> H[npm audit & Trivy Security Scan]
    
    I[Merge to main] --> J(CD Workflow)
    J --> K[Build & Push Docker Image to GHCR]
    K --> L[Trigger Production Deployment Environment]
    L --> M[Manual/Admin Approval Gate]
    M --> N[Transfer Compose & Deployment Scripts via SCP]
    N --> O[Run SSH Script on VPS]
    O --> P[Inject Secrets to .env & Pull Image]
    P --> Q[Restart app container & Run database migrations]
    Q --> R[HTTP Health Check Verification]
    R -->|Success| S[Prune old Docker resources]
    R -->|Failure| T[AUTOMATED ROLLBACK to previous stable tag]
```

---

## 🛠️ GitHub Actions Workflows

### 1. Continuous Integration (`ci.yml`)
* **Trigger:** Runs on any push or pull request targeting the `main` branch.
* **Environment:** Executes on `ubuntu-latest` inside ephemeral runners.
* **Key Tasks:**
  * **Caching:** Caches `~/.npm` and Next.js `.next/cache` folders.
  * **Dependencies:** Clean installation using `npm ci --legacy-peer-deps`.
  * **Prisma:** Validates schema integrity (`npx prisma validate`) and compiles type-safe Client (`npx prisma generate`).
  * **Type & Lint Checking:** Inspects JS syntax/imports via Next.js Core Web Vitals ESLint rules (`npm run lint`).
  * **Build Verification:** Compiles standalone production assets using sandboxed/mock environment variables.
  * **Container Verification:** Tests Dockerfile syntax and build commands (`docker/build-push-action` dry-run).
  * **Vulnerability Scanning:** Runs `npm audit` (failing on high/critical issues) and Aqua Security Trivy filesystem scan.

### 2. Continuous Delivery (`cd.yml`)
* **Trigger:** Runs automatically on successful push/merge to `main`, or via manual trigger (`workflow_dispatch`).
* **Environment:** Pushes images to GitHub Container Registry (GHCR) and connects to the VPS for delivery.
* **Key Tasks:**
  * **Docker Login:** Logs into GHCR securely.
  * **Tagging:** Computes image tags based on the Git commit SHA (`sha-<commit_sha>`) and tags as `latest`.
  * **Image Push:** Builds and uploads the production image to `ghcr.io/devrony04/vehiql-app`.
  * **Approval Gate:** Targets the `production` environment, which requires administrator approval before executing SSH commands.
  * **Deployment Copy:** Uses secure SCP to upload `docker-compose.prod.yml` and `scripts/deploy.sh` to the VPS target directory.
  * **Remote SSH Deployment:** Executes `scripts/deploy.sh` to update environment variables, pull the new container, apply Prisma migrations, run health check loops, and perform an automatic rollback if health checks fail.

---

## 🔑 Required GitHub Secrets

Configure the following secrets in your repository settings under **Settings -> Secrets and variables -> Actions**:

| Secret Name | Purpose | Example / Format |
| :--- | :--- | :--- |
| `DATABASE_URL` | Supabase Postgres URL (with pgbouncer pooling if applicable) | `postgresql://user:pass@host:6543/db?pgbouncer=true` |
| `DIRECT_URL` | Direct connection to Supabase Postgres (used for migrations) | `postgresql://user:pass@host:5432/db` |
| `NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY` | Clerk Authentication publishable API key | `pk_test_...` or `pk_live_...` |
| `CLERK_SECRET_KEY` | Clerk secret API key | `sk_test_...` or `sk_live_...` |
| `NEXT_PUBLIC_CLERK_SIGN_IN_URL` | URL path redirecting to Clerk sign-in | `/sign-in` |
| `NEXT_PUBLIC_CLERK_SIGN_UP_URL` | URL path redirecting to Clerk sign-up | `/sign-up` |
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase API Endpoint URL | `https://xxxx.supabase.co` |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase Anonymous Web Client API key | `eyJhbGci...` |
| `SUPABASE_SERVICE_ROLE_KEY` | Supabase Admin bypass Service Key | `eyJhbGci...` |
| `GEMINI_API_KEY` | Google AI Platform Access Key for Gemini API | `AIzaSy...` |
| `ARCJET_KEY` | Security key for ArcJet WAF and Bot protection | `ajkey_...` |
| `NEXTAUTH_SECRET` | Secret key for hashing tokens / auth state | `your-secure-random-secret` |
| `VPS_HOST` | Remote server IP address or domain | `192.168.1.100` or `production.vehiql.com` |
| `VPS_USER` | SSH Username on the VPS | `ubuntu`, `debian`, or `root` |
| `VPS_SSH_KEY` | SSH Private Key to authenticate connection | `-----BEGIN OPENSSH PRIVATE KEY-----...` |

---

## 🔒 Security & Branch Protection Recommendations

To maintain a secure, enterprise-grade deployment strategy, configure the following settings in your GitHub Repository:

### 1. Branch Protection Rules (`main`)
Navigate to **Settings -> Branches -> Add branch protection rule**:
* **Branch name pattern:** `main`
* **Require a pull request before merging:** Enabled
  * **Require approvals:** Enabled (Require at least `1` approval)
* **Require status checks to pass before merging:** Enabled
  * **Required checks:** Search and check `Lint & Validate Prisma Schema`, `Next.js Production Build Verification`, and `Dependency & Code Security Scan`.
* **Require branches to be up to date before merging:** Enabled
* **Restrict who can push to matching branches:** Enabled (Limit direct pushing only to DevOps/Release accounts)

### 2. GitHub Production Environment Setup
Navigate to **Settings -> Environments -> New environment**:
* **Name:** `production`
* **Required reviewers:** Enabled (Specify release engineers/project managers who must sign off on deployments)
* **Deployment branches:** `Selected branches` (Set only `main`)

---

## 🐳 VPS Infrastructure Requirements

Your destination VPS server must have the following configuration:
1. **Docker Engine & Docker Compose installed:**
   * Install Docker (v20.10+) and Docker Compose (v2.0+).
2. **Docker non-root execution:**
   * Ensure the SSH user (e.g. `ubuntu`) is in the `docker` group:
     ```bash
     sudo usermod -aG docker $USER
     # Reload shell group memberships
     newgrp docker
     ```
3. **Open Ports:**
   * Ensure port `3000` is open or configured behind a reverse proxy (e.g., Nginx, Caddy, or Traefik) handling SSL termination.

---

## 🔄 Release & Rollback Strategy

The CD pipeline relies on `scripts/deploy.sh` executing on the VPS. It implements the following safety workflow:

1. **Active Backup:** The script inspects the running container and records its active image tag.
2. **Container Update:** It updates the local `.env` and restarts only the `app` container using `docker compose -f docker-compose.prod.yml up -d --no-deps app`.
3. **Database Migration:** Executes `npx prisma migrate deploy` inside the updated container environment.
4. **Health Check Loop:** Performs an HTTP request loop targeting `http://localhost:3000/`.
5. **Auto-Rollback Trigger:** If the container fails to respond with a valid HTTP code (e.g. `200` or redirects) within 30 seconds, or database migrations fail, the script:
   * Restores the previously saved stable image tag in the environment.
   * Runs the previous container version.
   * Exits with code `1` so that the GitHub Action fails and alerts the team.

---

## 🛠️ Troubleshooting & Manual Commands

If you need to perform actions manually on the VPS, use these standard commands:

### Force manual rollback to last stable image
```bash
cd ~/vehiql-deploy
export DOCKER_IMAGE_NAME=ghcr.io/devrony04/vehiql-app:sha-<previous_working_sha>
docker compose -f docker-compose.prod.yml up -d --no-deps app
```

### View container logs
```bash
docker compose -f docker-compose.prod.yml logs -f app
```

### Run database migrations manually
```bash
docker compose -f docker-compose.prod.yml exec -T app npx prisma migrate deploy
```
