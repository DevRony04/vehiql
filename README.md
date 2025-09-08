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

## 🛠️ Tech Stack

| Layer         | Technology |
|---------------|------------|
| Frontend      | Next.js 14, Shadcn UI, Tailwind CSS |
| Backend       | Supabase, Prisma |
| AI Services   | Gemini API, ArcJet |
| Auth          | Clerk |
| Styling       | Tailwind CSS |

---

## 🚀 Getting Started

### 1️⃣ Clone the Repository
``bash
git clone https://github.com/your-username/ai-car-marketplace.git
cd ai-car-marketplace

## 2️⃣ Install Dependencies
npm install

## 3️⃣ Set Up Environment Variables

Create a .env file in the root directory and add the following:

DATABASE_URL=
DIRECT_URL=

NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=
CLERK_SECRET_KEY=
NEXT_PUBLIC_CLERK_SIGN_IN_URL=/sign-in
NEXT_PUBLIC_CLERK_SIGN_UP_URL=/sign-up
NEXT_PUBLIC_CLERK_AFTER_SIGN_IN_URL=/onboarding
NEXT_PUBLIC_CLERK_AFTER_SIGN_UP_URL=/onboarding

GEMINI_API_KEY=
ARCJET_KEY=

## 4️⃣ Run the Development Server
npm run dev

## 📸 ScreenShots

<img width="1837" height="886" alt="Screenshot 2025-09-05 120348" src="https://github.com/user-attachments/assets/eb3fff35-8853-45d0-8669-2cfd66bf80ff" />

## 📂 Folder Structure
ai-car-marketplace/
│── prisma/        # Database schema
│── src/
│   ├── app/       # Next.js app routes
│   ├── components/# UI components
│   ├── lib/       # Utility functions
│── .env           # Environment variables
│── package.json  

## 📜 License

This project is licensed under the MIT License.

## 🙌 Acknowledgments

- **Inspired by building a modern Car Marketplace with AI integration**.

- **Thanks to the open-source community and frameworks that made this possible**.

