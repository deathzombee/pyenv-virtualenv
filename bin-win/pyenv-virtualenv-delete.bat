@echo off
setlocal enabledelayedexpansion

:: pyenv-virtualenv-delete for Windows
:: Delete a Python virtualenv

:: Get PYENV_ROOT
if not defined PYENV (
    set PYENV=%USERPROFILE%\.pyenv\pyenv-win
)
if not defined PYENV_HOME (
    set PYENV_HOME=%PYENV%
)
if not defined PYENV_ROOT (
    set PYENV_ROOT=%PYENV_HOME%
)

:: Parse arguments
set VENV_NAME=%~1
set FORCE=

if "%~1"=="-f" (
    set FORCE=1
    set VENV_NAME=%~2
)
if "%~1"=="--force" (
    set FORCE=1
    set VENV_NAME=%~2
)

if not defined VENV_NAME (
    echo Usage: pyenv-virtualenv-delete [-f^|--force] VIRTUALENV_NAME
    exit /b 1
)

:: Find the virtualenv
set VENV_PATH=
set VERSION_DIR=

:: Check direct path
if exist "%PYENV_ROOT%\versions\%VENV_NAME%\Scripts\activate.bat" (
    set VENV_PATH=%PYENV_ROOT%\versions\%VENV_NAME%
)

:: Check in envs subdirectories
if not defined VENV_PATH (
    for /d %%v in ("%PYENV_ROOT%\versions\*") do (
        if exist "%%v\envs\%VENV_NAME%\Scripts\activate.bat" (
            set VENV_PATH=%%v\envs\%VENV_NAME%
            set VERSION_DIR=%%~nxv
        )
    )
)

if not defined VENV_PATH (
    echo Error: virtualenv '%VENV_NAME%' not found
    exit /b 1
)

:: Confirm deletion
if not defined FORCE (
    echo About to delete virtualenv: %VENV_NAME%
    set /p CONFIRM="Are you sure? (y/N) "
    if /i not "!CONFIRM!"=="y" (
        echo Deletion cancelled
        exit /b 0
    )
)

:: Delete the virtualenv
echo Deleting virtualenv: %VENV_NAME%...
rmdir /s /q "%VENV_PATH%"

:: Remove symlink if it exists
if exist "%PYENV_ROOT%\versions\%VENV_NAME%" (
    rmdir "%PYENV_ROOT%\versions\%VENV_NAME%" 2>nul
    del "%PYENV_ROOT%\versions\%VENV_NAME%" 2>nul
)

echo Successfully deleted virtualenv: %VENV_NAME%

endlocal
