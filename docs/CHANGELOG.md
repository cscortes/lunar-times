# Changelog

All notable changes to the Moon Phases Calculator project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Comprehensive documentation suite (docs/ARCH.md, docs/SETUP.md, docs/USAGE.md, .cursorrules)
- Structured project documentation with architectural diagrams
- Installation and setup instructions for multiple environments
- Detailed usage guide with examples and troubleshooting (docs/USAGE.md)
- Cursor AI integration rules for consistent development assistance
- Failure analysis and troubleshooting documentation (docs/FAILURE.md)
- Version history and release tracking (docs/CHANGELOG.md)
- Modern project configuration with pyproject.toml
- Command-line script entry point (`moon-phases`)
- Development tools configuration (black, flake8, mypy)

### Changed
- **BREAKING**: Migrated from Pipenv to uv package manager
- Enhanced project structure with formal documentation
- Improved development workflow with clear guidelines
- Reorganized documentation into docs/ directory
- Updated README.md with comprehensive project overview and documentation links
- Updated all internal references to reflect new documentation structure
- Updated all installation and usage instructions to use uv commands
- Enhanced dependency management with modern Python packaging standards

### Removed
- Pipfile and Pipfile.lock (replaced by pyproject.toml and uv.lock)

## [1.0.0] - 2024-01-15

### Added
- Initial release of Moon Phases Calculator
- Command-line interface for moon rise/set time calculations
- City and state input with automatic geocoding via Nominatim API
- Timezone-aware calculations using timezonefinder and pytz
- Integration with USNO Navy Astronomical API for accurate moon data
- Debug mode (`-d` flag) for development and testing
- Support for El Paso, TX as default location in debug mode
- Proper error handling for invalid locations and API failures
- 12-hour time format display with AM/PM
- Timezone information display with UTC offset

### Dependencies
- requests: HTTP client for API calls
- geopy: Geocoding services (Nominatim)
- timezonefinder: Timezone resolution from coordinates
- pytz: Timezone handling and conversion
- Python 3.8+ standard library (datetime, sys)

### External Services
- Nominatim Geocoding API (OpenStreetMap)
- USNO Navy Astronomical Applications API
- TimezoneFinder offline timezone resolution

## [0.1.0] - 2024-01-10

### Added
- Basic project structure
- Pipfile for dependency management
- Core functionality for moon data retrieval
- Basic command-line interface
- Initial API integration with USNO Navy

---

## Version Format

This project uses [Semantic Versioning](https://semver.org/):
- **MAJOR**: Incompatible API changes
- **MINOR**: New functionality in a backwards compatible manner
- **PATCH**: Backwards compatible bug fixes

## Change Categories

- **Added**: New features
- **Changed**: Changes in existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Removed features
- **Fixed**: Bug fixes
- **Security**: Vulnerability fixes

## Contributing to Changelog

When making changes to the project:

1. Add entries to the `[Unreleased]` section
2. Use the appropriate category (Added, Changed, Fixed, etc.)
3. Write clear, concise descriptions
4. Include relevant issue/PR references when applicable
5. Move entries to a new version section when releasing

## Example Entry Format

```markdown
### Added
- New feature description [#123]
- Another feature with context and rationale

### Fixed
- Bug fix description with impact explanation [#456]
- Performance improvement in specific area

### Changed
- Breaking change description with migration guide [#789]
```

## Release Process

1. Move items from `[Unreleased]` to new version section
2. Update version number in relevant files
3. Add release date
4. Tag the release in git
5. Update documentation as needed 