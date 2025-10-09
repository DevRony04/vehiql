#!/bin/bash

# Update dependencies script for Vehiql project
# This script helps resolve dependency conflicts

echo "🔄 Updating dependencies..."

# Remove existing node_modules and package-lock.json
echo "🧹 Cleaning existing dependencies..."
rm -rf node_modules package-lock.json

# Install with legacy peer deps to resolve conflicts
echo "📦 Installing dependencies with legacy peer deps..."
npm install --legacy-peer-deps

# Generate Prisma client
echo "🔧 Generating Prisma client..."
npx prisma generate

echo "✅ Dependencies updated successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Test your application: npm run dev"
echo "2. Build your application: npm run build"
echo "3. If issues persist, consider updating react-day-picker to a newer version"
