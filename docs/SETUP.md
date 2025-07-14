# Setup Guide: Lunar Times

This guide provides comprehensive instructions for setting up the Lunar Times project for development and usage. The project uses modern Python packaging with `uv` for dependency management and `make` for task automation.

## Prerequisites

### System Requirements
- **Operating System**: Linux, macOS, or Windows
- **Python Version**: Python 3.8 or higher
- **Internet Connection**: Required for API calls to external services

### Check Python Version
```bash
python --version
# or
python3 --version
```

If you don't have Python 3.8+, download it from [python.org](https://www.python.org/downloads/).

## Installation Methods

### Method 1: Using uv (Recommended)

uv provides fast, modern Python package management with built-in virtual environments.

#### 1. Install uv
```bash
# On macOS/Linux
curl -LsSf https://astral.sh/uv/install.sh | sh

# On Windows
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"

# Or using pip
pip install uv
```

#### 2. Clone/Download the Project
```bash
git clone <repository-url>
cd moon_phases
```

#### 3. Install Dependencies
```bash
make install
```

This will:
- Create a virtual environment automatically  
- Install all required packages from `pyproject.toml`
- Install development dependencies
- Lock dependencies in `uv.lock`

#### 4. Run Commands
```bash
# Use make targets for common tasks
make run                   # Run the application
make run-debug            # Run in debug mode
make test                 # Run tests

# Or run commands directly in the environment
uv run python moon_data.py

# Or activate the environment
source .venv/bin/activate  # Linux/macOS
.venv\Scripts\activate     # Windows
```

### Method 2: Using pip and venv

If you prefer using standard Python tools (not recommended for this project):

#### 1. Create Virtual Environment
```bash
# Create virtual environment
python -m venv moon_env

# Activate it
# On Linux/macOS:
source moon_env/bin/activate
# On Windows:
moon_env\Scripts\activate
```

#### 2. Install Dependencies
```bash
pip install requests geopy timezonefinder pytz
```

### Method 3: System-wide Installation (Not Recommended)

```bash
pip install requests geopy timezonefinder pytz
```

⚠️ **Warning**: This installs packages globally and may cause conflicts with other projects.

## Dependencies

The application requires the following Python packages:

| Package | Version | Purpose |
|---------|---------|---------|
| `requests` | Latest | HTTP client for API calls |
| `geopy` | Latest | Geocoding services (Nominatim) |
| `timezonefinder` | Latest | Timezone resolution from coordinates |
| `pytz` | Latest | Timezone handling and conversion |

## Running the Application

### Basic Usage

#### Using Make (Recommended):
```bash
# Run with user input
make run

# Run in debug mode (uses El Paso, TX as default)
make run-debug

# Run tests
make test

# Check code quality
make check
```

#### Using uv directly:
```bash
# Run with user input
uv run python moon_data.py

# Run in debug mode (uses El Paso, TX as default)
uv run python moon_data.py -d

# Using the installed script
uv run lunar-times
uv run lunar-times -d
```

#### Using Standard Python:
```bash
# Make sure your virtual environment is activated
python moon_data.py

# Debug mode
python moon_data.py -d
```

### Interactive Mode
When you run the application without the `-d` flag, it will prompt you for input:

```
Enter the city: Austin
Enter the state: TX
```

### Debug Mode
Use the `-d` flag to automatically use El Paso, TX as the location:

```bash
python moon_data.py -d
```

## Example Usage

### Interactive Session
```bash
$ python moon_data.py
Enter the city: New York
Enter the state: NY
# Moon rise/set times in (Timezone: America/New_York -5.0) on 2024-01-15:
-  RISE: 11:45 PM
-  SET: 01:30 PM
```

### Debug Mode Session
```bash
$ python moon_data.py -d
Running in debug mode. Defaulting to city (El Paso, TX)
# Moon rise/set times in (Timezone: America/Chicago -6.0) on 2024-01-15:
-  RISE: 10:58 PM
-  SET: 01:08 PM
```

## Troubleshooting

### Common Issues

#### 1. Python Version Error
```
Error: Python 3.8 or higher required
```
**Solution**: Upgrade Python to version 3.8 or higher.

#### 2. Missing Dependencies
```
ModuleNotFoundError: No module named 'requests'
```
**Solution**: Install dependencies using one of the methods above.

#### 3. Location Not Found
```
ValueError: Could not find coordinates for InvalidCity, XX
```
**Solution**: 
- Check spelling of city and state
- Use full state names or standard abbreviations
- Try nearby larger cities

#### 4. API Connection Issues
```
ConnectionError: Failed to retrieve moon data. Status code: 500
```
**Solution**: 
- Check internet connection
- Verify firewall settings
- Try again later (API may be temporarily unavailable)

#### 5. Timezone Resolution Issues
```
pytz.UnknownTimeZoneError
```
**Solution**: 
- Ensure coordinates are valid
- Try a different nearby location
- Check if timezonefinder is properly installed

### Network Requirements

The application requires access to these external services:

- **Nominatim Geocoding API** (OpenStreetMap)
  - URL: `https://nominatim.openstreetmap.org/`
  - Port: 443 (HTTPS)
  
- **USNO Navy Astronomical API**
  - URL: `https://aa.usno.navy.mil/api/rstt/oneday`
  - Port: 443 (HTTPS)

Ensure your firewall allows outbound HTTPS connections to these domains.

## Development Setup

### For Development Work

#### 1. Install Development Dependencies
```bash
make install
```

#### 2. Run Development Commands
```bash
# Run all quality checks
make check

# Run tests
make test

# Format code
make format

# Lint code
make lint

# Type checking
make typecheck
```

#### 3. Alternative: Direct uv Commands
```bash
# Install dev dependencies
uv sync --dev

# Run tests
uv run python -m pytest

# Format code
uv run black .

# Lint code
uv run flake8 .

# Type checking
uv run mypy moon_data.py
```

## Verification

To verify your installation works correctly:

### 1. Test Debug Mode
```bash
python moon_data.py -d
```
Should output moon data for El Paso, TX without prompting for input.

### 2. Test Interactive Mode
```bash
python moon_data.py
```
Enter a known city/state combination and verify you get moon rise/set times.

### 3. Test Error Handling
```bash
python moon_data.py
# Enter invalid city: "InvalidCity"
# Enter invalid state: "XX"
```
Should display an appropriate error message.

## Uninstalling

### Remove Virtual Environment
```bash
# If using uv
rm -rf .venv

# If using venv
rm -rf moon_env
```

### Remove Global Packages (if installed globally)
```bash
pip uninstall requests geopy timezonefinder pytz
```

## Support

### Getting Help
- Check the error message carefully
- Verify all prerequisites are met
- Ensure internet connectivity
- Try the debug mode to test basic functionality

### Common Locations for Testing
- New York, NY
- Los Angeles, CA
- Chicago, IL
- Houston, TX
- Miami, FL

## Performance Notes

- First run may be slower due to initial API calls
- Subsequent runs for the same location are not cached
- Each run makes fresh API calls for current data
- Typical runtime: 1-3 seconds depending on network speed

## Security Considerations

- No API keys required
- No user data stored locally
- All API calls use HTTPS
- No persistent data storage

---

For technical details about the application architecture, see [ARCH.md](ARCH.md).

For general information about the project, see [README.md](../README.md). 