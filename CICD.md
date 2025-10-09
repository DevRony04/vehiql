# CI/CD Pipeline Documentation

This document describes the Continuous Integration and Continuous Deployment (CI/CD) setup for the Vehiql project.

## Overview

The CI/CD pipeline consists of multiple GitHub Actions workflows that handle:
- Code quality checks (linting, testing)
- Docker image building and security scanning
- Database migration testing
- Automated deployments to staging and production
- Security vulnerability scanning

## Workflows

### 1. Main CI/CD Pipeline (`cicd.yaml`)

**Triggers:**
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop` branches

**Jobs:**
1. **Lint and Test** - Code quality checks and testing
2. **Docker Build** - Build and push Docker images
3. **Security Scan** - Vulnerability scanning with Trivy
4. **Database Test** - Test database migrations
5. **Deploy Staging** - Deploy to staging environment (develop branch)
6. **Deploy Production** - Deploy to production environment (main branch)
7. **Notify Failure** - Send notifications on pipeline failure

### 2. Docker Build (`docker-build.yml`)

**Triggers:**
- Push to `main` or `develop` branches
- Push tags starting with `v*`
- Pull requests to `main`

**Features:**
- Multi-platform builds (linux/amd64, linux/arm64)
- Container registry publishing to GitHub Container Registry
- Build attestation for supply chain security
- Build caching for faster builds

### 3. Security Scan (`security.yml`)

**Triggers:**
- Weekly schedule (Mondays at 2 AM)
- Push to `main` branch
- Pull requests to `main`

**Features:**
- npm audit for dependency vulnerabilities
- Snyk security scanning (requires SNYK_TOKEN)
- Trivy container vulnerability scanning
- CodeQL analysis for code security issues

### 4. Deploy (`deploy.yml`)

**Triggers:**
- Push to `main` branch
- Manual workflow dispatch with environment selection

**Features:**
- Staging and production deployments
- Database migration execution
- Health checks after deployment
- Automatic rollback on failure

## Environment Variables

### Required Secrets

Add these secrets to your GitHub repository settings:

```
GITHUB_TOKEN (automatically provided)
SNYK_TOKEN (optional, for Snyk security scanning)
```

### Environment Configuration

Configure the following environments in GitHub:
- `staging` - For staging deployments
- `production` - For production deployments

## Database Migrations

The pipeline automatically handles database migrations:

1. **Testing**: Migrations are tested against a test database
2. **Staging**: Migrations run automatically on staging deployment
3. **Production**: Migrations run automatically on production deployment

### Manual Migration Commands

```bash
# Generate Prisma client
npx prisma generate

# Run migrations
npx prisma migrate deploy

# Reset database (development only)
npx prisma migrate reset

# Create new migration
npx prisma migrate dev --name migration_name
```

## Docker Images

### Image Tags

The pipeline creates Docker images with the following tags:
- `latest` - Latest from main branch
- `develop` - Latest from develop branch
- `v1.0.0` - Semantic version tags
- `main-abc1234` - Branch and commit SHA
- `pr-123` - Pull request number

### Registry

Images are published to GitHub Container Registry:
```
ghcr.io/your-username/vehiql:latest
```

## Deployment Strategies

### Staging Deployment
- Triggered on push to `develop` branch
- Uses staging environment variables
- Includes health checks
- Database migrations run automatically

### Production Deployment
- Triggered on push to `main` branch
- Uses production environment variables
- Includes health checks
- Database migrations run automatically
- Rollback capability on failure

### Manual Deployment
You can trigger manual deployments using the workflow dispatch feature:
1. Go to Actions tab in GitHub
2. Select "Deploy" workflow
3. Click "Run workflow"
4. Choose environment (staging/production)

## Security Features

### Vulnerability Scanning
- **npm audit** - Checks for known vulnerabilities in dependencies
- **Snyk** - Advanced security scanning (requires SNYK_TOKEN)
- **Trivy** - Container image vulnerability scanning
- **CodeQL** - Static code analysis for security issues

### Supply Chain Security
- Build attestation for Docker images
- Dependency caching with security checks
- Container registry scanning

## Monitoring and Notifications

### Health Checks
- Application health endpoints are checked after deployment
- Database connectivity is verified
- Service availability is confirmed

### Failure Handling
- Automatic rollback on deployment failure
- Notification system for pipeline failures
- Detailed logging for troubleshooting

## Customization

### Adding New Environments

1. Create new environment in GitHub repository settings
2. Add deployment job in `deploy.yml`
3. Configure environment-specific variables

### Custom Deployment Commands

Update the deployment steps in `deploy.yml` with your specific infrastructure:

```yaml
# For Kubernetes
kubectl set image deployment/vehiql-app app=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}

# For Docker Swarm
docker service update --image ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }} vehiql-app

# For Docker Compose
docker-compose -f docker-compose.prod.yml up -d
```

### Adding Tests

Create test files in your project and update the test step in `cicd.yaml`:

```yaml
- name: Run tests
  run: npm test
```

## Troubleshooting

### Common Issues

1. **Build Failures**
   - Check Dockerfile syntax
   - Verify all dependencies are included
   - Check for missing environment variables

2. **Deployment Failures**
   - Verify target environment configuration
   - Check deployment permissions
   - Review health check endpoints

3. **Database Migration Failures**
   - Ensure database is accessible
   - Check migration files for syntax errors
   - Verify Prisma client generation

### Debug Commands

```bash
# Check workflow logs
gh run list
gh run view <run-id>

# Test Docker build locally
docker build -t vehiql-test .

# Test database connection
npx prisma migrate status
```

## Best Practices

1. **Branch Protection**: Enable branch protection rules for main branch
2. **Environment Variables**: Use GitHub secrets for sensitive data
3. **Review Process**: Require pull request reviews before merging
4. **Testing**: Maintain comprehensive test coverage
5. **Security**: Regular security scanning and dependency updates
6. **Monitoring**: Set up application monitoring and alerting

## Support

For issues with the CI/CD pipeline:
1. Check the Actions tab in GitHub for detailed logs
2. Review the workflow files for configuration issues
3. Verify environment variables and secrets are properly set
4. Test deployments in staging before production
