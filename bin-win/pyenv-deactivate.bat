@echo off

:: pyenv-deactivate for Windows
:: Deactivate the current Python virtualenv

:: Check if virtualenv is active
if not defined VIRTUAL_ENV (
    echo No virtualenv is currently active
    exit /b 0
)

:: Check if deactivate command is available (should be in Scripts)
where deactivate >nul 2>&1
if errorlevel 1 (
    echo Warning: deactivate command not found
    echo Please restart your terminal or manually run 'deactivate'
    exit /b 1
)

:: Deactivate
call deactivate 2>nul

echo Deactivated virtualenv
