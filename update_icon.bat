@echo off
echo ========================================
echo  FlowIt - App Icon Update Script
echo ========================================
echo.

echo Step 1: Installing dependencies...
call flutter pub get
if errorlevel 1 (
    echo ERROR: Failed to install dependencies
    pause
    exit /b 1
)
echo.

echo Step 2: Generating app icons from logo.png...
call flutter pub run flutter_launcher_icons
if errorlevel 1 (
    echo ERROR: Failed to generate icons
    pause
    exit /b 1
)
echo.

echo ========================================
echo  SUCCESS! App icons updated
echo ========================================
echo.
echo Your FlowIt logo has been set as the app icon.
echo.
echo Next steps:
echo 1. Run: flutter clean
echo 2. Run: flutter run
echo.
echo The new icon will appear on your device!
echo.
pause
