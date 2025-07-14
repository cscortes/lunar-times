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

## [1.4.0] - 2025-01-14

### Added
- Comprehensive testing documentation (docs/TEST.md)
- Code coverage reporting with pytest-cov
- New make targets for coverage: `test-coverage`, `coverage-report`, `coverage-html`
- Coverage configuration in pyproject.toml with 90% minimum threshold
- HTML coverage reports in htmlcov/ directory
- Enhanced testing workflow with coverage analysis

### Changed
- Updated development dependencies to include pytest-cov==4.0.0
- Enhanced Makefile with coverage targets and improved clean command
- Updated documentation references to include testing guide
- Improved quality gates to include coverage requirements

### Fixed
- Added missing coverage files to clean target for complete cleanup

## [1.3.2] - 2025-01-14

### Removed
- `test.json` file (no longer used - test data is embedded in test suite)
- References to test.json in documentation and comments

### Changed
- Updated test file comment to reflect embedded test data instead of external file
- Updated development guidelines to reference embedded test data

## [1.3.1] - 2025-01-14

### Changed
- Enhanced build target with intelligent source file dependency tracking
- Build only rebuilds when source files or pyproject.toml are newer than last build
- Improved build efficiency with `.build-marker` file for timestamp tracking

### Removed
- `watch` target from Makefile (no longer needed with smart build dependencies)
- File watching functionality using entr (simplified development workflow)

## [1.3.0] - 2025-01-14

### Added
- Intelligent dependency tracking in Makefile using virtual environment timestamps
- New advanced make targets: `ci`, `quick-check`, `watch`, `reset`
- Automatic dependency resolution for all development targets
- `dev-setup` target as alias for convenience

### Changed
- Enhanced Makefile with proper target dependencies to ensure tools are available before use
- `build` target now depends on `check` to ensure quality before building
- All development targets (test, lint, format, typecheck) now automatically install dependencies
- `ci` target runs complete pipeline: format → check → build
- Improved Makefile organization with phony targets and color-coded help

### Fixed  
- Removed unused imports from test_moon_data.py
- Fixed f-string without placeholders in moon_data.py

## [1.2.1] - 2025-01-14

### Changed
- Updated all documentation to reference make targets instead of raw uv commands
- Improved consistency across README.md, docs/SETUP.md, docs/USAGE.md, and docs/ARCH.md
- Prioritized make targets while keeping uv commands as alternatives where appropriate
- Enhanced examples and usage instructions to use standardized workflow commands

## [1.2.0] - 2025-01-14

### Added
- Comprehensive Makefile for development workflow management
- Standardized development commands: setup, test, lint, format, check, run, build, clean, status
- Developer-focused status reporting with dependency and configuration details
- Color-coded output for improved readability
- Centralized reference for all development tasks

### Changed
- Enhanced development experience with consistent command interface

## [1.1.0] - 2025-01-14

### Added
- Comprehensive test suite with 22 unit tests covering all functions
- Mock-based testing to avoid external API dependencies during testing
- Integration test with real API validation
- Complete test coverage for error conditions and edge cases

### Changed
- Enhanced development workflow with automated testing capabilities

## [1.0.2] - 2025-01-14

### Fixed
- Python version compatibility: Updated requirement from 3.13+ to 3.8+ for broader compatibility
- Pinned all runtime dependencies for reproducibility: requests==2.32.4, geopy==2.4.1, timezonefinder==6.5.4, pytz==2024.2
- Pinned all dev dependencies for reproducibility: pytest==8.3.5, black==24.8.0, flake8==5.0.4, mypy==1.14.1
- Updated development tools configuration (mypy, black) to target Python 3.8

### Changed
- Added reproducibility as a core architectural principle in documentation
- Updated all documentation to reflect new Python 3.8+ requirement

## [1.0.1] - 2025-07-14

### Changed
- Updated Python version requirement from 3.13+ to 3.8+ for broader compatibility
- Updated author information in project configuration
- Updated all documentation to reflect new Python 3.8+ requirement
- Updated development tools configuration (mypy, black) to target Python 3.8

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