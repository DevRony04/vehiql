# 🚗 VehiQL — AI-Powered Car Marketplace Platform

[![Continuous Integration](https://github.com/DevRony04/vehiql2/actions/workflows/ci.yml/badge.svg)](https://github.com/DevRony04/vehiql2/actions/workflows/ci.yml)
[![Continuous Delivery](https://github.com/DevRony04/vehiql2/actions/workflows/cd.yml/badge.svg)](https://github.com/DevRony04/vehiql2/actions/workflows/cd.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Node.js Version](https://img.shields.io/badge/node-%3E%3D%2018.0.0-green.svg)](package.json)
[![Next.js Version](https://img.shields.io/badge/next.js-v15.3.8-black.svg)](package.json)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/DevRony04/vehiql/pulls)

VehiQL is a production-grade, high-performance **AI-powered car marketplace** built on top of **Next.js 15 (App Router)**, **Supabase**, **Prisma**, and **Tailwind CSS v4**. The platform features intelligent automated car detail extraction via **Google Gemini AI**, enterprise-grade security and bot defense via **ArcJet WAF**, and modern session management via **Clerk Authentication**.

---

## 🌟 Key Features

*   🔑 **Enterprise Authentication & RBAC:** Complete tenant onboardings and secure admin panel routes managed by Clerk.
*   🤖 **AI Car Details Extractor:** Automated spec-sheet generation (make, model, year, transmission, fuel type, color) from car photos using `gemini-2.5-flash`.
*   🛡️ **Advanced Web Application Firewall (WAF):** Integrated rate-limiting, SQL/command injection shield protection, and search engine bot-detection using ArcJet.
*   💾 **Hybrid DB Architecture:** PostgreSQL hosted on Supabase and managed using Prisma ORM with connection pooling via PgBouncer.
*   ⚡ **Standalone Server Bundle:** Next.js build-optimized stand-alone server tracing (`output: 'standalone'`), minimizing Docker production images to less than 150MB.
*   🔄 **CI/CD with Automated Rollbacks:** Automated testing, Prisma validation, dependency auditing, Trivy security filesystem checks, and zero-downtime remote deployment with automatic health check rollbacks.

---

## 🏗️ System Architecture & Tech Stack

```mermaid
flowchart TD
    Client[Browser / Client UI] -->|HTTPS Requests| ArcJet{ArcJet Shield & WAF}
    ArcJet -->|Allowed| Clerk[Clerk Auth & Session Gate]
    Clerk -->|Authorized Request| NextJS[Next.js App Server]
    
    subgraph NextJS Backend [Next.js Standalone Runner]
        App[App Router Server Components] -->|Server Actions| Lib[Data Access Layer]
        Lib -->|ORM Client| Prisma[Prisma ORM Client]
        App -->|Analyze Image| Gemini[Google Gemini 2.5 API]
    end
    
    Prisma -->|PgBouncer Pool / Port 6543| Supabase[Supabase PostgreSQL DB]
    Lib -->|Image Uploads| Storage[Supabase Storage Buckets]
```

| Layer | Technologies Used |
| :--- | :--- |
| **Frontend & Routing** | Next.js 15.3.8 (App Router), React 19, Tailwind CSS v4, Radix UI, Shadcn UI |
| **Backend Framework** | Next.js Server Actions, Next.js Middleware |
| **Database & ORM** | PostgreSQL (hosted on Supabase), Prisma ORM Client |
| **Security & Firewall** | ArcJet (Shield protection, Bot Detection, Token Bucket Rate Limiting) |
| **Artificial Intelligence** | `@google/generative-ai` (`gemini-2.5-flash`) |
| **Authentication** | Clerk (`@clerk/nextjs` Server SDK) |

---

## 🚦 Getting Started

### Prerequisites
*   Node.js v18+ installed locally (or Docker Engine + Docker Compose).
*   A Clerk account (API keys).
*   A Supabase account (Postgres URL & Storage Buckets).
*   A Google AI Studio account (Gemini API key).

### 1. Set Up Environment Variables
Create a `.env` file in the root directory:
```env
# Database Connections
DATABASE_URL="postgresql://postgres:[password]@aws-0-ap-south-1.pooler.supabase.com:6543/postgres?pgbouncer=true"
DIRECT_URL="postgresql://postgres:[password]@aws-0-ap-south-1.pooler.supabase.com:5432/postgres"

# Clerk Authentication API Keys
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_...
CLERK_SECRET_KEY=sk_test_...
NEXT_PUBLIC_CLERK_SIGN_IN_URL=/sign-in
NEXT_PUBLIC_CLERK_SIGN_UP_URL=/sign-up

# Supabase Storage Configuration
NEXT_PUBLIC_SUPABASE_URL=https://xxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGci...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGci...

# Google AI Platform (Gemini API)
GEMINI_API_KEY=AIzaSy...

# Arcjet Security Firewall Key
ARCJET_KEY=ajkey_...

# Next Auth Config
NEXTAUTH_SECRET=your-random-session-hash
NEXTAUTH_URL=http://localhost:3000
```

### 2. Option A: Local Development Setup
1. Install dependencies:
   ```bash
   npm install --legacy-peer-deps
   ```
2. Run Prisma client generation:
   ```bash
   npx prisma generate
   ```
3. Run migrations locally (if applicable):
   ```bash
   npx prisma migrate dev
   ```
4. Run the development server:
   ```bash
   npm run dev
   ```
5. Open [http://localhost:3000](http://localhost:3000) to view the application.

### 3. Option B: Running with Docker (Recommended)
Docker setup automatically provisions environment variables and builds matching multi-stage Node environments.

*   **Production Compose:**
    ```bash
    docker-compose up --build
    ```
*   **Development Compose (with Hot Reloading):**
    ```bash
    docker-compose -f docker-compose.dev.yml up --build
    ```
*   **Run migrations inside the running container:**
    ```bash
    docker-compose exec app npx prisma migrate deploy
    ```

---

## 📂 Directory Layout

```
├── .github/workflows/         # CI/CD pipeline automation (ci.yml, cd.yml)
├── actions/                   # Next.js Server Actions (Home, Cars, Admin, Settings)
├── app/                       # Next.js App Router (routes, layouts, page views)
│   ├── (admin)/               # Secured admin dashboard routes
│   ├── (auth)/                # Sign-in/Sign-up pages (Clerk integrated)
│   └── (main)/                # Public marketplace paths (cars, test-drive, saved-cars)
├── components/                # Reusable UI components (buttons, headers, form controls)
├── hooks/                     # Custom React hooks
├── lib/                       # Third-party configurations & utilities
│   ├── generated/             # Generated Prisma client classes (lib/generated/prisma)
│   ├── arcjet.js              # Arcjet firewall configuration
│   ├── prisma.js              # Prisma Client single instance resolver
│   └── supabase.js            # Supabase Storage client
├── prisma/                    # Schema models and migration history
├── public/                    # Static image, icon, and logo assets
├── scripts/                   # Production CD shell scripts (deploy.sh)
├── Dockerfile                 # Standalone production container recipe
├── Dockerfile.dev             # Local hot-reloading development container recipe
├── docker-compose.yml         # Production multi-container compose configuration
├── docker-compose.prod.yml    # Registry image pulling compose configuration
└── eslint.config.mjs          # Linting settings
```

---

## 🔒 Security Operations & Bot Defense

The platform integrates ArcJet at the Next.js Middleware layer. This blocks malicious requests before they consume application resources:
*   **Shield Protection:** Inspects incoming headers, queries, and bodies, immediately blocking common attacks (SQL Injection, XSS, Path Traversal).
*   **Bot Detection:** Identifies web spiders, scrapers, and bot agents. Only search engine indices (Google, Bing) are whitelisted.
*   **Rate Limiting:** Protects the Server Action APIs against brute-force spam requests (e.g. rate-limiting car creation forms to 10 submissions/hour per IP).

---

## 🔄 CI/CD & Automated Delivery

This repository contains fully automated pipelines configured in `.github/workflows/`:
1.  **Continuous Integration (`ci.yml`):**
    *   Dependency caching and lint checks (`npm run lint`).
    *   Prisma schema integrity checks (`npx prisma validate`).
    *   Production Next.js standalone build verification.
    *   Trivy FS security vulnerabilities scan (exits on `CRITICAL` issues).
2.  **Continuous Delivery (`cd.yml`):**
    *   Builds and pushes a Docker image to GitHub Container Registry (GHCR).
    *   Deploys to production VPS using SSH, restarts only affected services (`docker compose up -d app`).
    *   Runs database migrations and verifies service health.
    *   **Auto-Rollback:** Automatically reverts to the previous stable container version if the post-deployment HTTP health check fails.

For more details on setting up pipeline secrets and branch protection, refer to the [CI/CD Documentation Guide](./CI_CD_DOCUMENTATION.md).

---

## 🤝 Contribution & License

This project is open-source under the terms of the [MIT License](./LICENSE). Contributions are welcome; please submit a Pull Request or open an issue on the repository.
