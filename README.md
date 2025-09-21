# 🚗 AI Car Marketplace

An **AI-powered car marketplace platform** built with **Next.js 14**, **Supabase**, **Prisma**, **Tailwind CSS**, **ArcJet**, **Clerk Authentication**, **Gemini API**, and **Shadcn UI**.

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
| Frontend (UI)    | Next.js 14, Shadcn UI, Tailwind CSS |
| Backend (API)    | Next.js API Routes, Server Actions  |
| Database & ORM   | Supabase (Postgres), Prisma         |
| Authentication   | Clerk                               |
| AI Integration   | Gemini API, ArcJet                  |
| Styling          | Tailwind CSS                        |

---

## 🚀 Getting Started

### 1️⃣ Clone the Repository :->
``bash
git clone https://github.com/DevRony04/vehiql.git
cd ai-car-marketplace

## 2️⃣ Install Dependencies :->
npm install

## 3️⃣ Set Up Environment Variables :->

Create a .env file in the root directory and add the following:

- DATABASE_URL=
- DIRECT_URL=

- NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=
- CLERK_SECRET_KEY=
- NEXT_PUBLIC_CLERK_SIGN_IN_URL=/sign-in
- NEXT_PUBLIC_CLERK_SIGN_UP_URL=/sign-up
- NEXT_PUBLIC_CLERK_AFTER_SIGN_IN_URL=/onboarding
- NEXT_PUBLIC_CLERK_AFTER_SIGN_UP_URL=/onboarding

- GEMINI_API_KEY=
- ARCJET_KEY=

## 4️⃣ Run the Development Server :->
npm run dev

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

  ## 🚀 Deployment :->
vercel :- https://ai-car-marketplace-dev.vercel.app

## 📜 License :->

This project is licensed under the MIT License.

## 🙌 Acknowledgments :->

- **Inspired by building a modern Car Marketplace with AI integration**.

- **Thanks to the open-source community and frameworks that made this possible**.

