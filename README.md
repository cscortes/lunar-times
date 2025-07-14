# Moon Phases Calculator

A simple command-line Python application that calculates moonrise and moonset times for any given city and state. The application integrates with external APIs to provide accurate astronomical data with proper timezone handling.

## Features

- 🌙 Calculate moonrise and moonset times for any US city and state
- 📍 Automatic coordinate resolution using OpenStreetMap geocoding
- 🕐 Timezone-aware calculations with proper daylight saving time handling
- 🔧 Debug mode for development and testing
- 🚀 Clean command-line interface with clear output formatting

## Quick Start

```bash
# Install dependencies
make install

# Run the application
make run

# Or use debug mode (defaults to El Paso, TX)
make run-debug

# Run tests
make test

# Check code quality
make check
```

## Example Usage

```bash
$ python moon_data.py
Enter the city: Austin
Enter the state: TX
# Moon rise/set times in (Timezone: America/Chicago -6.0) on 2024-01-15:
-  RISE: 10:45 PM
-  SET: 11:30 AM
```

## Documentation

- **[Usage Guide](docs/USAGE.md)** - Detailed usage instructions and examples
- **[Setup Guide](docs/SETUP.md)** - Installation and configuration instructions
- **[Architecture](docs/ARCH.md)** - Technical architecture and design documentation
- **[Changelog](docs/CHANGELOG.md)** - Version history and release notes
- **[Failure Analysis](docs/FAILURE.md)** - Troubleshooting and known issues

## Requirements

- Python 3.8+
- [uv](https://docs.astral.sh/uv/) package manager
- Internet connection for API calls
- Dependencies: requests, geopy, timezonefinder, pytz

## License

This project is licensed under the terms in the [LICENSE](LICENSE) file.
