# pyenv-virtualenv Windows Scripts

This directory contains Windows batch scripts that add virtualenv functionality to pyenv-win.

## Installation

1. Ensure pyenv-win is installed and in your PATH
2. Add this directory to your PATH:
   ```powershell
   $env:PATH = "C:\path\to\pyenv-virtualenv\bin-win;$env:PATH"
   ```
   
   Or permanently:
   ```powershell
   [System.Environment]::SetEnvironmentVariable('PATH', "C:\path\to\pyenv-virtualenv\bin-win;$env:PATH", 'User')
   ```

## Available Commands

### pyenv-virtualenv.bat
Create a new virtualenv:
```batch
pyenv-virtualenv [VERSION] VIRTUALENV_NAME
pyenv-virtualenv [-f|--force] [VERSION] VIRTUALENV_NAME
```

Examples:
```batch
REM Create virtualenv from current Python version
pyenv-virtualenv myenv

REM Create virtualenv from specific Python version
pyenv-virtualenv 3.11.0 myenv311

REM Force recreate if exists
pyenv-virtualenv -f 3.11.0 myenv311
```

### pyenv-activate.bat
Activate a virtualenv:
```batch
pyenv activate VIRTUALENV_NAME
```

Example:
```batch
pyenv activate myenv
```

### pyenv-deactivate.bat
Deactivate the current virtualenv:
```batch
pyenv deactivate
```

### pyenv-virtualenvs.bat
List all virtualenvs:
```batch
pyenv-virtualenvs
```

### pyenv-virtualenv-delete.bat
Delete a virtualenv:
```batch
pyenv-virtualenv-delete [-f|--force] VIRTUALENV_NAME
```

Example:
```batch
REM Delete with confirmation
pyenv-virtualenv-delete myenv

REM Force delete without confirmation
pyenv-virtualenv-delete -f myenv
```

## How It Works

These scripts extend pyenv-win by:
1. Using Python's built-in `venv` module to create virtual environments
2. Storing virtualenvs in `%PYENV_ROOT%\versions\{python-version}\envs\{venv-name}`
3. Creating symlinks in `%PYENV_ROOT%\versions\{venv-name}` for easy access
4. Using the standard Windows virtual environment activation scripts

## Requirements

- Windows 10 or later
- pyenv-win installed and configured
- Python 3.3+ (for venv module support)

## Notes

- These scripts use Python's built-in `venv` module, not the `virtualenv` package
- The scripts are compatible with pyenv-win's version management
- Virtualenvs are created per Python version, similar to pyenv-virtualenv on Unix systems
