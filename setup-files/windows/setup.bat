:: By Vilgax
@echo off 
title Star Engine Setup - HMM Installer
color 0d

:: 1. Sets the script directory as current
cd /d "%~dp0"

:: 2. Moves 2 directories up to reach the Project Root (from setup-files/windows)
cd ..\..

echo ===============================================
echo          STAR ENGINE AUTO SETUP
echo ===============================================
echo.
echo This script will create a local .haxelib folder,
echo install hmm.json, and download the exact dependencies
echo listed in the hmm.json file.
echo.
echo Current Directory: %CD%
echo.
echo Prerequisites:
echo 1. Haxe 4.2.5 or higher
echo 2. Git
echo.
echo Press any key to start...
pause >nul
cls

:: ----------------------------------------------------------------
:: 3. Security Check (Now checks the Root folder)
:: ----------------------------------------------------------------
if not exist "hmm.json" (
    color 0c
    echo [ERROR] hmm.json not found in:
    echo %CD%
    echo.
    echo Please ensure the folder structure is correct:
    echo Root/
    echo  |-- hmm.json
    echo  |-- setup-files/
    echo       |-- windows/
    echo            |-- setup.bat
    pause
    exit
)

:: ----------------------------------------------------------------
:: 4. Creating Local Repo (.haxelib) in Root
:: ----------------------------------------------------------------
title Star Engine Setup - Setting up Local Repo
echo [1/4] Setting up local repository (.haxelib)...

if not exist ".haxelib" (
    haxelib newrepo
    echo .haxelib folder created successfully.
) else (
    echo .haxelib folder already exists. Continuing...
)

:: ----------------------------------------------------------------
:: 5. Installing HMM
:: ----------------------------------------------------------------
title Star Engine Setup - Installing HMM
echo [2/4] Installing HMM tool...

haxelib install hmm --quiet

:: ----------------------------------------------------------------
:: 6. Downloading Dependencies (HMM Install)
:: ----------------------------------------------------------------
title Star Engine Setup - Downloading Libs
echo [3/4] Reading hmm.json and downloading libraries...
echo This may take a while depending on your internet speed.
echo Please wait and do not close the window.
echo.

haxelib run hmm install

:: ----------------------------------------------------------------
:: 7. Finalizing
:: ----------------------------------------------------------------
title Star Engine Setup - Finalizing
echo [4/4] Configuring Lime and Flixel...

:: Ensures lime setup runs in the local environment
haxelib run lime setup flixel
haxelib run lime setup

cls
color 0b
echo ===============================================
echo          INSTALLATION COMPLETE!
echo ===============================================
echo.
echo All dependencies have been installed in /.haxelib/
echo.
echo To compile the game, use:
echo lime test windows
echo.
echo If you encounter MSVC errors, please install
echo the Visual Studio C++ components.
echo.
pause
