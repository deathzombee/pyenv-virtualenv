@echo off
setlocal enabledelayedexpansion

:: pyenv-virtualenvs for Windows
:: List all Python virtualenvs

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

echo Available virtualenvs:
echo.

:: Get current virtualenv if active
set CURRENT_VENV=
if defined VIRTUAL_ENV (
    for %%i in ("%VIRTUAL_ENV%") do set CURRENT_VENV=%%~nxi
)

:: List all versions and their virtualenvs
for /d %%v in ("%PYENV_ROOT%\versions\*") do (
    set VERSION_DIR=%%~nxv
    if exist "%%v\envs" (
        for /d %%e in ("%%v\envs\*") do (
            set VENV_NAME=%%~nxe
            set PREFIX=  
            if "!VENV_NAME!"=="!CURRENT_VENV!" set PREFIX=* 
            echo !PREFIX!!VERSION_DIR!/envs/!VENV_NAME! (created from %PYENV_ROOT%\versions\!VERSION_DIR!)
        )
    )
)

:: List symlinked virtualenvs in versions root
for /d %%v in ("%PYENV_ROOT%\versions\*") do (
    if exist "%%v\Scripts\activate.bat" (
        set VENV_NAME=%%~nxv
        :: Check if this is a symlink (virtualenv shortcut)
        set IS_LINK=
        for /d %%p in ("%PYENV_ROOT%\versions\*\envs\!VENV_NAME!") do (
            set IS_LINK=1
        )
        if defined IS_LINK (
            set PREFIX=  
            if "!VENV_NAME!"=="!CURRENT_VENV!" set PREFIX=* 
            echo !PREFIX!!VENV_NAME! (symlink to virtualenv)
        )
    )
)

endlocal
