@echo off

:: pyenv-activate for Windows
:: Activate a Python virtualenv

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
set QUIET=

if "%~1"=="--quiet" (
    set QUIET=1
    set VENV_NAME=%~2
)

if "%VENV_NAME%"=="" (
    echo Usage: pyenv activate VIRTUALENV_NAME
    exit /b 1
)

:: Check if virtualenv exists
set VENV_PATH=%PYENV_ROOT%\versions\%VENV_NAME%

if not exist "%VENV_PATH%\Scripts\activate.bat" (
    if not defined QUIET echo Error: virtualenv '%VENV_NAME%' not found
    exit /b 1
)

:: Activate the virtualenv
call "%VENV_PATH%\Scripts\activate.bat"

if not defined QUIET echo Activated virtualenv: %VENV_NAME%
