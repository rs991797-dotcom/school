@echo off
title HYTECH Auto Print - Deployment Script
color 0A
cls

echo ============================================
echo   HYTECH Auto Print - Deployment Script
echo ============================================
echo.
echo Ye script aapko deployment me help karegi.
echo.
echo Steps:
echo 1. Backend files upload karo
echo 2. Frontend files upload karo
echo 3. npm install chalao
echo 4. PM2 setup karo
echo 5. Domain configure karo
echo.
echo ============================================
echo.

:: Check Node.js
echo [1/5] Checking Node.js...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js not found!
    echo Please install Node.js from https://nodejs.org
    pause
    exit /b 1
)
node --version
echo.

:: Check npm
echo [2/5] Checking npm...
npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] npm not found!
    pause
    exit /b 1
)
npm --version
echo.

:: Install PM2
echo [3/5] Installing PM2...
npm install -g pm2
if %errorlevel% neq 0 (
    echo [WARNING] PM2 install failed. Try: npm install -g pm2
)
echo.

:: Create .env file
echo [4/5] Creating .env file...
if not exist "backend\.env" (
    echo NODE_ENV=production > backend\.env
    echo PORT=3000 >> backend\.env
    echo PRINT_AGENT_SECRET=hytech-print-agent-secret-2024 >> backend\.env
    echo APP_URL=https://yourdomain.com >> backend\.env
    echo.
    echo [OK] .env file created
    echo.
    echo IMPORTANT: .env file me APP_URL change karo!
    echo.
) else (
    echo [OK] .env file already exists
)
echo.

:: Install dependencies
echo [5/5] Installing backend dependencies...
cd backend
npm install --production
cd ..
echo.

echo ============================================
echo   Setup Complete!
echo ============================================
echo.
echo Next steps:
echo 1. .env file edit karo (APP_URL set karo)
echo 2. Files upload karo server pe
echo 3. PM2 se start karo: pm2 start src/app.js --name hytech-auto-print
echo 4. Domain configure karo
echo.
echo Deployment guide: DEPLOYMENT.md
echo.
pause
