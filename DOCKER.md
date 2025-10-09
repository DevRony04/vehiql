# Docker Setup for Vehiql

This document explains how to run the Vehiql application using Docker.

## Prerequisites

- Docker and Docker Compose installed on your system
- Environment variables configured (see Environment Variables section)

## Environment Variables

Create a `.env` file in the root directory with the following variables:

```env
# Database
DATABASE_URL="postgresql://postgres:postgres@localhost:5432/vehiql"
DIRECT_URL="postgresql://postgres:postgres@localhost:5432/vehiql"

# Clerk Authentication
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=your_clerk_publishable_key_here
CLERK_SECRET_KEY=your_clerk_secret_key_here
NEXT_PUBLIC_CLERK_SIGN_IN_URL=/sign-in
NEXT_PUBLIC_CLERK_SIGN_UP_URL=/sign-up
NEXT_PUBLIC_CLERK_AFTER_SIGN_IN_URL=/
NEXT_PUBLIC_CLERK_AFTER_SIGN_UP_URL=/

# Supabase
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url_here
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key_here
SUPABASE_SERVICE_ROLE_KEY=your_supabase_service_role_key_here

# Google Generative AI (if used)
GOOGLE_GENERATIVE_AI_API_KEY=your_google_ai_api_key_here

# Arcjet (if used)
ARCJET_KEY=your_arcjet_key_here

# Next.js
NEXTAUTH_SECRET=your_nextauth_secret_here
NEXTAUTH_URL=http://localhost:3000
```

## Production Deployment

### Using Docker Compose (Recommended)

1. **Build and start the application:**
   ```bash
   docker-compose up --build
   ```

2. **Run database migrations:**
   ```bash
   docker-compose exec app npx prisma migrate deploy
   ```

3. **Access the application:**
   - Application: http://localhost:3000
   - PostgreSQL: localhost:5432

### Using Docker directly

1. **Build the image:**
   ```bash
   docker build -t vehiql-app .
   ```

2. **Run the container:**
   ```bash
   docker run -p 3000:3000 --env-file .env vehiql-app
   ```

## Development Setup

For development with hot reloading:

1. **Start development environment:**
   ```bash
   docker-compose -f docker-compose.dev.yml up --build
   ```

2. **Run database migrations:**
   ```bash
   docker-compose -f docker-compose.dev.yml exec app npx prisma migrate dev
   ```

3. **Access the application:**
   - Application: http://localhost:3000 (with hot reloading)
   - PostgreSQL: localhost:5432

## Database Management

### Run Prisma Commands

```bash
# Generate Prisma client
docker-compose exec app npx prisma generate

# Run migrations
docker-compose exec app npx prisma migrate deploy

# Reset database (development only)
docker-compose exec app npx prisma migrate reset

# Open Prisma Studio
docker-compose exec app npx prisma studio
```

### Access PostgreSQL directly

```bash
# Connect to PostgreSQL
docker-compose exec postgres psql -U postgres -d vehiql
```

## Useful Commands

### View logs
```bash
docker-compose logs -f app
docker-compose logs -f postgres
```

### Stop services
```bash
docker-compose down
```

### Stop and remove volumes (WARNING: This will delete all data)
```bash
docker-compose down -v
```

### Rebuild without cache
```bash
docker-compose build --no-cache
```

## Troubleshooting

### Port conflicts
If ports 3000 or 5432 are already in use, modify the `docker-compose.yml` file to use different ports:

```yaml
ports:
  - "3001:3000"  # Use port 3001 instead of 3000
```

### Database connection issues
Ensure the `DATABASE_URL` in your `.env` file matches the PostgreSQL service configuration in `docker-compose.yml`.

### Permission issues
Make sure Docker has the necessary permissions to access your project directory.

## Production Considerations

1. **Security**: Change default PostgreSQL credentials in production
2. **Environment**: Use proper environment variables for production secrets
3. **Volumes**: Consider using named volumes or external storage for production data
4. **Networking**: Configure proper network security for production deployment
5. **SSL**: Set up SSL certificates for HTTPS in production
