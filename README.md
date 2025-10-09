# 🚗 AI Car Marketplace

An **AI-powered car marketplace platform** built with **Next.js 15**, **Supabase**, **Prisma**, **Tailwind CSS**, **ArcJet**, **Clerk Authentication**, **Gemini API**, and **Shadcn UI**.

This project allows users to browse, list, and explore cars with intelligent AI recommendations, modern authentication, and a clean, responsive interface.

---

## ✨ Features

- 🔑 **User Authentication** with Clerk (sign-in, sign-up, onboarding flows)
- 🚘 **Car Listings** with real-time database powered by Supabase + Prisma
- 🤖 **AI Recommendations** powered by Gemini API and ArcJet
- 🎨 **Modern UI** built with Tailwind CSS + Shadcn components
- 📱 **Responsive Design** that works on all devices
- ⚡ **Full-Stack Implementation** with scalable architecture

---

## 🛠️ Tech Stack :->

| Layer            | Technology                          |
|------------------|-------------------------------------|
| Frontend (UI)    | Next.js 15, Shadcn UI, Tailwind CSS |
| Backend (API)    | Next.js API Routes, Server Actions  |
| Database & ORM   | Supabase (Postgres), Prisma         |
| Authentication   | Clerk                               |
| AI Integration   | Gemini API, ArcJet                  |
| Styling          | Tailwind CSS                        |

---

## 🚀 Getting Started

### Option 1: Docker Setup (Recommended)

### 1️⃣ Clone the Repository :->
```bash
git clone https://github.com/DevRony04/vehiql.git
cd vehiql2
```

### 2️⃣ Set Up Environment Variables :->

Create a `.env` file in the root directory and add the following:

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

# Google Generative AI
GOOGLE_GENERATIVE_AI_API_KEY=your_google_ai_api_key_here

# Arcjet
ARCJET_KEY=your_arcjet_key_here
```

### 3️⃣ Run with Docker :->
```bash
# Production setup
docker-compose up --build

# Development setup with hot reloading
docker-compose -f docker-compose.dev.yml up --build
```

### 4️⃣ Run Database Migrations :->
```bash
docker-compose exec app npx prisma migrate deploy
```

### Option 2: Local Development

### 1️⃣ Install Dependencies :->
```bash
npm install --legacy-peer-deps
```

### 2️⃣ Set Up Environment Variables :->
Same as above

### 3️⃣ Run the Development Server :->
```bash
npm run dev
```

## 📸 Screenshots :->

<img width="1837" height="886" alt="Screenshot 2025-09-05 120348" src="https://github.com/user-attachments/assets/eb3fff35-8853-45d0-8669-2cfd66bf80ff" />

## 📂 Folder Structure :->
- ├── app/ # Next.js application routes & pages
- ├── components/ # Reusable UI components
- ├── hooks/ # Custom React hooks
- ├── lib/ # Utility functions & configurations
- ├── prisma/ # Prisma schema and database config
- ├── public/ # Static assets (images, icons, etc.)
│
- ├── .gitignore # Git ignore rules
- ├── README.md # Project documentation
- ├── components.json # Shadcn UI components registry
- ├── eslint.config.mjs # ESLint configuration
- ├── jsconfig.json # JS/TS path aliases
- ├── middleware.js # Next.js middleware (auth, routing, etc.)
- ├── next.config.mjs # Next.js configuration
- ├── package.json # Project dependencies and scripts
- ├── package-lock.json # Dependency lockfile
- ├── postcss.config.mjs # PostCSS configuration
- ├── tailwind.config.mjs # Tailwind CSS configuration

## 🐳 Docker Setup

This project includes comprehensive Docker support for both development and production environments.

### Available Docker Files:
- `Dockerfile` - Production-optimized multi-stage build
- `Dockerfile.dev` - Development build with hot reloading
- `docker-compose.yml` - Production setup with PostgreSQL
- `docker-compose.dev.yml` - Development setup with volume mounting
- `.dockerignore` - Optimized build context

### Quick Start with Docker:
```bash
# Production
docker-compose up --build

# Development
docker-compose -f docker-compose.dev.yml up --build
```

For detailed Docker documentation, see [DOCKER.md](./DOCKER.md)

## 🚀 Deployment :->
vercel :- https://ai-car-marketplace-dev.vercel.app

## 📜 License :->

This project is licensed under the MIT License.

## 🙌 Acknowledgments :->

- **Inspired by building a modern Car Marketplace with AI integration**.

- **Thanks to the open-source community and frameworks that made this possible**.

