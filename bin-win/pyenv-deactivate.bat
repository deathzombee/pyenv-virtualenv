@echo off
setlocal

:: pyenv-deactivate for Windows
:: Deactivate the current Python virtualenv

:: Check if virtualenv is active
if not defined VIRTUAL_ENV (
    echo No virtualenv is currently active
    exit /b 0
)

:: Deactivate
call deactivate 2>nul

echo Deactivated virtualenv

endlocal
