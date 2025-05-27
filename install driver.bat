@echo off
:: Interception Installer Script with Restart Prompt

:: Check if running with admin rights
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrative privileges...
    goto UACPrompt
)

:: Main installation logic
cd /d "%~dp0"
if exist "install-interception.exe" (
    echo Installing Interception driver...
    install-interception.exe /install
    if %errorLevel% EQU 0 (
        echo.
        echo ✅ Success: Interception driver installed successfully!
        echo.
        echo It is strongly recommended to restart your computer after installing this driver.
        echo.
        choice /C YN /M "Do you want to restart your computer now?"
        if %errorlevel% == 1 (
            echo.
            echo Restarting your computer in 5 seconds...
            timeout /t 5 >nul
            shutdown /r /t 0
        ) else (
            echo.
            echo You can restart later manually if needed.
            echo Press any key to exit...
            pause >nul
        )
    ) else (
        echo ❌ Error: Installation failed with code %errorLevel%
        echo Press any key to exit...
        pause >nul
    )
) else (
    echo ❌ Error: install-interception.exe not found in this directory
    echo Press any key to exit...
    pause >nul
)

exit /b

:UACPrompt
echo This script requires elevation to install drivers.
powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
exit /b