@echo off
setlocal enabledelayedexpansion

:: pyenv-virtualenv for Windows
:: Create a Python virtualenv using pyenv-win

set PYENV_VIRTUALENV_VERSION=1.2.6

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

:: Check if pyenv is available
where pyenv >nul 2>&1
if errorlevel 1 (
    echo Error: pyenv-win is not installed or not in PATH
    echo Please install pyenv-win first: https://github.com/pyenv-win/pyenv-win
    exit /b 1
)

:: Parse arguments
set VERSION=
set VENV_NAME=
set FORCE=

:parse_args
if "%~1"=="" goto :end_parse
if "%~1"=="-f" (
    set FORCE=1
    shift
    goto :parse_args
)
if "%~1"=="--force" (
    set FORCE=1
    shift
    goto :parse_args
)
if "%~1"=="--version" (
    echo pyenv-virtualenv %PYENV_VIRTUALENV_VERSION%
    exit /b 0
)
if "%~1"=="--help" (
    echo Usage: pyenv-virtualenv [-f^|--force] [VERSION] VIRTUALENV_NAME
    echo.
    echo Create a Python virtualenv
    echo.
    echo   -f, --force    Install even if the version appears to be installed already
    echo   --version      Show version
    echo   --help         Show this help
    exit /b 0
)

if not defined VERSION (
    set VERSION=%~1
    shift
    goto :parse_args
)
if not defined VENV_NAME (
    set VENV_NAME=%~1
    shift
    goto :parse_args
)
shift
goto :parse_args

:end_parse

:: If only one argument, use current Python version
if not defined VENV_NAME (
    set VENV_NAME=%VERSION%
    for /f "tokens=*" %%i in ('pyenv version-name') do set VERSION=%%i
)

:: Validate arguments
if not defined VENV_NAME (
    echo Error: virtualenv name is required
    echo Usage: pyenv-virtualenv [-f] [VERSION] VIRTUALENV_NAME
    exit /b 1
)

:: Check if version exists
pyenv versions --bare | findstr /x "%VERSION%" >nul
if errorlevel 1 (
    echo Error: Python version %VERSION% is not installed
    echo Run 'pyenv install %VERSION%' first
    exit /b 1
)

:: Set paths
set PYTHON_PATH=%PYENV_ROOT%\versions\%VERSION%
set VENV_PATH=%PYENV_ROOT%\versions\%VERSION%\envs\%VENV_NAME%
set VENV_LINK=%PYENV_ROOT%\versions\%VENV_NAME%

:: Check if virtualenv already exists
if exist "%VENV_PATH%" (
    if not defined FORCE (
        echo virtualenv '%VENV_NAME%' already exists in %VERSION%
        set /p CONFIRM="Continue anyway? (y/N) "
        if /i not "!CONFIRM!"=="y" exit /b 1
    )
    rmdir /s /q "%VENV_PATH%"
)

:: Create envs directory if it doesn't exist
if not exist "%PYENV_ROOT%\versions\%VERSION%\envs" (
    mkdir "%PYENV_ROOT%\versions\%VERSION%\envs"
)

:: Create virtualenv using python -m venv
echo Creating virtualenv %VENV_NAME% from %VERSION%...
"%PYTHON_PATH%\python.exe" -m venv "%VENV_PATH%"

if errorlevel 1 (
    echo Error: Failed to create virtualenv
    exit /b 1
)

:: Create symlink for easy access
if exist "%VENV_LINK%" (
    if exist "%VENV_LINK%\python.exe" (
        rmdir "%VENV_LINK%"
    ) else (
        del "%VENV_LINK%"
    )
)
mklink /D "%VENV_LINK%" "%VENV_PATH%" >nul

echo Successfully created virtualenv: %VENV_NAME%
echo.
echo To activate: pyenv activate %VENV_NAME%
echo To deactivate: pyenv deactivate

exit /b 0
