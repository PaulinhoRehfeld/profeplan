@echo off
echo --- STARTING PRODUCTION DEPLOYMENT ---
echo 1. Installing dependencies...
call npm install
if %errorlevel% neq 0 exit /b %errorlevel%

echo 2. Building for Production...
call npm run build
if %errorlevel% neq 0 exit /b %errorlevel%

echo 3. Verifying Build Artifacts...
if exist "dist\index.html" (
    echo [SUCCESS] Build completed. 'dist' folder ready.
) else (
    echo [ERROR] Build failed. 'dist\index.html' not found.
    exit /b 1
)

echo --- DEPLOYMENT PREPARATION COMPLETE ---
echo You can now publish the 'dist' folder to your hosting provider (Vercel/Netlify).
