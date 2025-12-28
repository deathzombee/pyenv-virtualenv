<#
.SYNOPSIS
    Install pyenv-virtualenv for Windows (pyenv-win integration)

.DESCRIPTION
    This script installs pyenv-virtualenv for Windows by:
    1. Ensuring pyenv-win is installed
    2. Adding pyenv-virtualenv scripts to PATH
    3. Creating necessary directories

.PARAMETER InstallPath
    Optional installation path. Defaults to $env:USERPROFILE\.pyenv\pyenv-win\plugins\pyenv-virtualenv

.EXAMPLE
    .\install-pyenv-virtualenv.ps1
    
.EXAMPLE
    .\install-pyenv-virtualenv.ps1 -InstallPath "C:\custom\path\pyenv-virtualenv"
#>

param(
    [string]$InstallPath = "$env:USERPROFILE\.pyenv\pyenv-win\plugins\pyenv-virtualenv"
)

$ErrorActionPreference = "Stop"

Write-Host "pyenv-virtualenv Windows Installation" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Check if pyenv-win is installed
Write-Host "Checking for pyenv-win installation..." -ForegroundColor Yellow
$pyenvCommand = Get-Command pyenv -ErrorAction SilentlyContinue

if (-not $pyenvCommand) {
    Write-Host ""
    Write-Host "ERROR: pyenv-win is not installed or not in PATH" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install pyenv-win first:" -ForegroundColor Yellow
    Write-Host "  Invoke-WebRequest -UseBasicParsing -Uri 'https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1' -OutFile './install-pyenv-win.ps1'; &'./install-pyenv-win.ps1'" -ForegroundColor White
    Write-Host ""
    Write-Host "Or visit: https://github.com/pyenv-win/pyenv-win" -ForegroundColor Yellow
    exit 1
}

Write-Host "✓ pyenv-win found at: $($pyenvCommand.Source)" -ForegroundColor Green

# Get the script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Check if we're running from a cloned repo
if (-not (Test-Path "$ScriptDir\bin-win")) {
    Write-Host ""
    Write-Host "ERROR: bin-win directory not found" -ForegroundColor Red
    Write-Host "Make sure you've cloned the repository properly" -ForegroundColor Yellow
    exit 1
}

# Create installation directory
Write-Host ""
Write-Host "Creating installation directory: $InstallPath" -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path $InstallPath | Out-Null

# Copy files
Write-Host "Copying files..." -ForegroundColor Yellow
Copy-Item -Path "$ScriptDir\bin-win\*" -Destination $InstallPath -Recurse -Force
Write-Host "✓ Files copied" -ForegroundColor Green

# Add to PATH
$BinWinPath = $InstallPath
Write-Host ""
Write-Host "Adding to PATH..." -ForegroundColor Yellow

# Get current user PATH
$currentPath = [System.Environment]::GetEnvironmentVariable('PATH', 'User')

# Check if already in PATH
if ($currentPath -like "*$BinWinPath*") {
    Write-Host "✓ Already in PATH" -ForegroundColor Green
} else {
    # Add to PATH
    $newPath = "$BinWinPath;$currentPath"
    [System.Environment]::SetEnvironmentVariable('PATH', $newPath, 'User')
    
    # Update current session PATH
    $env:PATH = "$BinWinPath;$env:PATH"
    
    Write-Host "✓ Added to PATH" -ForegroundColor Green
    Write-Host ""
    Write-Host "NOTE: You may need to restart your terminal for PATH changes to take effect" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Installation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Available commands:" -ForegroundColor Cyan
Write-Host "  pyenv-virtualenv [VERSION] NAME  - Create a virtualenv" -ForegroundColor White
Write-Host "  pyenv activate NAME              - Activate a virtualenv" -ForegroundColor White
Write-Host "  pyenv deactivate                 - Deactivate current virtualenv" -ForegroundColor White
Write-Host "  pyenv-virtualenvs                - List all virtualenvs" -ForegroundColor White
Write-Host "  pyenv-virtualenv-delete NAME     - Delete a virtualenv" -ForegroundColor White
Write-Host ""
Write-Host "Example usage:" -ForegroundColor Cyan
Write-Host "  pyenv install 3.11.0" -ForegroundColor White
Write-Host "  pyenv-virtualenv 3.11.0 myenv" -ForegroundColor White
Write-Host "  pyenv activate myenv" -ForegroundColor White
Write-Host ""
Write-Host "For more information, see: $InstallPath\README.md" -ForegroundColor Yellow
