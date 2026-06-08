# VehiQL Contribution Guidelines (CONTRIBUTING.md)

Thank you for your interest in contributing to **VehiQL**! We welcome contributions from the community to help make this AI-powered car marketplace and intelligence platform even better. 

Please read this document carefully to understand our local setup process, coding standards, branch rules, and pull request procedures.

---

## 1. Getting Started

### Prerequisites
*   Node.js v18.0.0 or higher installed on your system.
*   Docker and Docker Compose installed (recommended for simplified local services).
*   API credentials/keys for Clerk, Supabase, Google Gemini AI (Google AI Studio), and ArcJet.

### Setup Instructions

#### Step 1: Clone the Repository
```bash
git clone https://github.com/DevRony04/vehiql2.git
cd vehiql2
```

#### Step 2: Install Dependencies
This project uses peer dependencies that require the `--legacy-peer-deps` flag:
```bash
npm install --legacy-peer-deps
```

#### Step 3: Configure Environment Variables
Create a `.env` file in the root directory and configure it with your active services:
```env
# Database Connections
DATABASE_URL="postgresql://postgres:[password]@aws-0-ap-south-1.pooler.supabase.com:6543/postgres?pgbouncer=true"
DIRECT_URL="postgresql://postgres:[password]@aws-0-ap-south-1.pooler.supabase.com:5432/postgres"

# Clerk Authentication Keys
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_...
CLERK_SECRET_KEY=sk_test_...
NEXT_PUBLIC_CLERK_SIGN_IN_URL=/sign-in
NEXT_PUBLIC_CLERK_SIGN_UP_URL=/sign-up

# Supabase Storage & Bucket Configuration
NEXT_PUBLIC_SUPABASE_URL=https://xxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGci...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGci...

# Google AI Platform (Gemini API Key)
GEMINI_API_KEY=AIzaSy...

# Arcjet Security Firewall Key
ARCJET_KEY=ajkey_...

# Next Auth / Session Config
NEXTAUTH_SECRET=your-secure-random-secret-hash
NEXTAUTH_URL=http://localhost:3000
```

#### Step 4: Run Prisma Client Generation
Before starting the application, compile the type-safe Prisma client:
```bash
npx prisma generate
```

---

## 2. Local Development Options

### Option A: Local Host Development (Standard)
1.  **Sync database schema:**
    Apply schema migrations to your PostgreSQL instance:
    ```bash
    npx prisma migrate dev
    ```
2.  **Start the Next.js development server:**
    ```bash
    npm run dev
    ```
3.  Open [http://localhost:3000](http://localhost:3000) in your browser.

### Option B: Docker Development (With Hot Reloading)
A dev-ready Docker Compose file is available to launch the database and the app server inside isolated containers:
1.  **Build and run the development services:**
    ```bash
    docker-compose -f docker-compose.dev.yml up --build
    ```
2.  **Execute database migrations inside the active app container:**
    ```bash
    docker-compose -f docker-compose.dev.yml exec app npx prisma migrate dev
    ```
3.  Access the live hot-reloaded workspace at [http://localhost:3000](http://localhost:3000).

---

## 3. Branch Naming Conventions

All development branches should be created with clear prefixes indicating their purpose. Use the following naming patterns:
*   `feature/` - For new features and enhancements (e.g., `feature/saved-car-notifications`)
*   `fix/` - For resolving bugs or broken logic (e.g., `fix/clerk-redirect-loop`)
*   `hotfix/` - For critical production-level patches (e.g., `hotfix/arcjet-bypass-patch`)
*   `docs/` - For writing or updating documentation (e.g., `docs/update-contributing-guide`)
*   `chore/` - For routine upgrades, formatting, or repository metadata (e.g., `chore/bump-lucide-icons`)

---

## 4. Commit Message Guidelines

We enforce the Conventional Commits specification. Commit messages must be structured as follows:

```
<type>(<optional scope>): <description>

[optional body]

[optional footer(s)]
```

### Common Types:
*   `feat`: A new feature is added (e.g., `feat: introduce AI spec sheet parsing on drag-and-drop`)
*   `fix`: A bug is resolved (e.g., `fix: fallback to mock metadata when Gemini connection fails`)
*   `docs`: Documentation changes only (e.g., `docs: add contributing branch naming guidelines`)
*   `style`: Code style changes (formatting, spacing, semicolons; no functional updates)
*   `refactor`: Structural code changes (neither fixes a bug nor adds a feature)
*   `test`: Adding or correcting tests (e.g., `test: add unit test for home search component`)
*   `chore`: Maintenance tasks, package upgrades, configuration changes (e.g., `chore: update tailwind postcss plugin`)
*   `ci`: Modifications targeting pipeline workflows (e.g., `ci: ignore warnings on high severity vulnerabilities in Trivy`)

---

## 5. Pull Request Process

We maintain a strict quality assurance process. To submit code updates:

1.  **Validate Locally:** Run build checks locally before pushing your branch to remote:
    ```bash
    npx prisma validate
    npx prisma generate
    npm run lint
    npm run build
    ```
2.  **Create a Pull Request:** Open a PR targeting the `main` branch. Provide a detailed description of the changes made, the files affected, and how you validated the update.
3.  **CI Checks:** The Continuous Integration workflow will run automatically:
    *   It compiles the dependencies and runs `npm run lint`.
    *   It validates the Prisma schema and client generation.
    *   It verifies the Next.js production standalone build.
    *   It checks Docker image build viability (dry-run).
    *   It runs security scans (npm audit and Aqua Security Trivy filesystem checks).
4.  **Code Review:** Every PR should undergo code review. We recommend getting at least one peer approval from a repository maintainer before merging the code.
5.  **CD Pipeline Status:** Continuous Delivery (VPS deployments, Docker image publishing to GHCR, and auto-rollback monitoring) is under **active development and testing**. Merges to `main` will trigger build processes, but deployments are monitored closely by release managers during this phase.

---

## 6. Coding Standards

### Next.js 15 & React Best Practices
*   **App Router Structure:** Keep routing logical. Page files must be `page.jsx` or `page.js`. Group sub-routes cleanly using Route Groups (e.g. `(admin)` or `(main)` layout segments).
*   **Server components:** Use React Server Components (RSC) by default for data fetching and layout structure. Mark interactive leaves explicitly with `"use client"`.
*   **Server Actions:** Implement transactional mutations as Server Actions (`use server`) inside the `actions/` directory.

### Styling & Tailwind CSS v4
*   Use Tailwind CSS v4 styling rules. Keep spacing, color utilities, and typography aligned with the existing design system tokens defined in [app/globals.css](file:///c:/Deepyaman%20Mondal/vehiql2/app/globals.css).
*   Do not add custom CSS styles inside components if Tailwind utilities can accomplish the layout.

### Prisma & Database Guidelines
*   **Prisma Client Singleton:** Always use the centralized database client imported from `@/lib/prisma`. Do not instantiate `new PrismaClient()` directly in your server components or actions; this leads to pool connection exhaustion during development reloads.
*   **Connection Configurations:** Remember that the connection string `DATABASE_URL` connects through the PgBouncer pooler (port 6543) and utilizes `?pgbouncer=true`. The schema migrations require `DIRECT_URL` (direct postgres port 5432).

### Security Practices
*   **Authentication Gates:** Verify that server actions validating data contain Clerk authorization gates (e.g., verifying `const { userId } = await auth();`).
*   **ArcJet WAF Validation:** All critical endpoints and middleware files must pass through the ArcJet security layer. Do not disable or bypass ArcJet rate limits and bot shields.
*   **Zero Credentials:** Never check in API keys, tokens, or environment-specific values. Keep all configurations inside `.env` (which is gitignored) and register them under GitHub Actions Secrets.

---

## 7. CI/CD Requirements

Every pull request and merge must successfully complete the Continuous Integration checks configured in `.github/workflows/ci.yml`. These include:
1.  **Prisma Validation:** `npx prisma validate` executes using mock connection endpoints.
2.  **Next.js Production Build:** The production compiler must complete without compilation errors.
3.  **Docker Build Validation:** A dry-run docker build checks syntax correctness and build steps of the multi-stage `Dockerfile`.
4.  **Security Scanning:** 
    *   `npm audit` logs dependencies with critical issues.
    *   Aqua Security Trivy filesystem scanner executes. **The pipeline will fail if any `CRITICAL` vulnerability is detected.**

---

## 8. Security Policy

If you discover a security vulnerability in the VehiQL platform, **please do not open a public GitHub Issue**. Instead, report it privately to the repository administrators to ensure a coordinated vulnerability disclosure and fix.

Always respect user data privacy and protect authentication flows. Ensure that all data access conforms to Clerk identity rules.
