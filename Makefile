.PHONY: info setup install test test-coverage coverage-report coverage-html lint format clean check run run-debug build status help ci dev-setup quick-check reset check-invisible clean-invisible pre-publish-clean build-package check-package upload-test upload-pypi
.DEFAULT_GOAL := info

# Source file tracking
SRC_FILES := $(shell find src -name "*.py" 2>/dev/null || echo "")
TEST_FILES := $(shell find tests -name "*.py" 2>/dev/null || echo "")

# Dependency tracking
.venv/pyvenv.cfg: pyproject.toml
	@echo "$(YELLOW)Creating/updating virtual environment...$(RESET)"
	@uv sync --extra dev
	@touch .venv/pyvenv.cfg

# Project Configuration
PROJECT_NAME := moon-phases-calculator
PYTHON_VERSION := 3.8

# Colors for output
BLUE := \033[36m
GREEN := \033[32m
YELLOW := \033[33m
RED := \033[31m
RESET := \033[0m

# Default target - show available commands
info:
	@echo "$(BLUE)$(PROJECT_NAME) Development Makefile$(RESET)"
	@echo ""
	@echo "$(GREEN)Available targets:$(RESET)"
	@echo "  $(YELLOW)info$(RESET)        Show this help message (default)"
	@echo "  $(YELLOW)setup$(RESET)       Initial project setup and dependency installation"
	@echo "  $(YELLOW)install$(RESET)     Install/update dependencies"
	@echo "  $(YELLOW)test$(RESET)        Run the test suite"
	@echo "  $(YELLOW)test-coverage$(RESET) Run tests with coverage reporting"
	@echo "  $(YELLOW)coverage-report$(RESET) Generate detailed coverage report"
	@echo "  $(YELLOW)coverage-html$(RESET) Open coverage report in browser"
	@echo "  $(YELLOW)lint$(RESET)        Run code linting (flake8)"
	@echo "  $(YELLOW)format$(RESET)      Format code with black"
	@echo "  $(YELLOW)check$(RESET)       Run all checks (lint + test + type check)"
	@echo "  $(YELLOW)run$(RESET)         Run the application interactively"
	@echo "  $(YELLOW)run-debug$(RESET)   Run the application in debug mode (El Paso, TX)"
	@echo "  $(YELLOW)build$(RESET)       Build the project (runs checks first)"
	@echo "  $(YELLOW)clean$(RESET)       Clean build artifacts and cache"
	@echo "  $(YELLOW)status$(RESET)      Show project status and configuration"
	@echo ""
	@echo "$(GREEN)Advanced targets:$(RESET)"
	@echo "  $(YELLOW)ci$(RESET)          Run continuous integration checks (format + check + build)"
	@echo "  $(YELLOW)quick-check$(RESET) Run quick development checks (lint + test)"
	@echo "  $(YELLOW)check-invisible$(RESET) Check for invisible characters in source files"
	@echo "  $(YELLOW)clean-invisible$(RESET) Remove invisible characters from source files"
	@echo "  $(YELLOW)pre-publish-clean$(RESET) Proactive cleanup for PyPI publishing"
	@echo "  $(YELLOW)reset$(RESET)       Reset environment (clean + fresh install)"
	@echo ""
	@echo "$(GREEN)Usage examples:$(RESET)"
	@echo "  make setup     # First-time project setup"
	@echo "  make test      # Run tests"
	@echo "  make check     # Run all quality checks"
	@echo "  make run       # Run the moon phases calculator"
	@echo "  make ci        # Run CI pipeline (format + check + build)"

# Initial project setup
setup:
	@echo "$(BLUE)Setting up $(PROJECT_NAME)...$(RESET)"
	@echo "$(YELLOW)Installing Python $(PYTHON_VERSION)...$(RESET)"
	@uv python install $(PYTHON_VERSION)
	@echo "$(YELLOW)Installing dependencies...$(RESET)"
	@uv sync --extra dev
	@echo "$(GREEN)✓ Setup complete!$(RESET)"
	@echo ""
	@echo "$(BLUE)Next steps:$(RESET)"
	@echo "  make test      # Run tests to verify setup"
	@echo "  make run       # Run the application"

# Install/update dependencies
install: .venv/pyvenv.cfg
	@echo "$(GREEN)✓ Dependencies updated$(RESET)"

# Development setup (alias for convenience)
dev-setup: install

# Run tests
test: install
	@echo "$(BLUE)Running test suite...$(RESET)"
	@uv run --extra dev python -m pytest tests/ -v
	@echo "$(GREEN)✓ Tests completed$(RESET)"

# Run tests with coverage
test-coverage: install
	@echo "$(BLUE)Running tests with coverage...$(RESET)"
	@uv run --extra dev python -m pytest tests/ --cov=src/moon_phases --cov-report=term-missing
	@echo "$(GREEN)✓ Tests with coverage completed$(RESET)"

# Generate coverage report
coverage-report: install
	@echo "$(BLUE)Generating coverage report...$(RESET)"
	@uv run --extra dev python -m pytest tests/ --cov=src/moon_phases --cov-report=term-missing --cov-report=html
	@echo "$(GREEN)✓ Coverage report generated in htmlcov/$(RESET)"

# Open coverage report in browser
coverage-html: coverage-report
	@echo "$(BLUE)Opening coverage report...$(RESET)"
	@python -m webbrowser htmlcov/index.html || open htmlcov/index.html || xdg-open htmlcov/index.html

# Run linting
lint: install
	@echo "$(BLUE)Running code linting...$(RESET)"
	@if [ -n "$(SRC_FILES)" ]; then uv run --extra dev flake8 $(SRC_FILES); fi
	@if [ -n "$(TEST_FILES)" ]; then uv run --extra dev flake8 $(TEST_FILES); fi
	@echo "$(GREEN)✓ Linting completed$(RESET)"

# Format code
format: install
	@echo "$(BLUE)Formatting code...$(RESET)"
	@if [ -n "$(SRC_FILES)" ]; then uv run --extra dev black $(SRC_FILES); fi
	@if [ -n "$(TEST_FILES)" ]; then uv run --extra dev black $(TEST_FILES); fi
	@echo "$(GREEN)✓ Code formatted$(RESET)"

# Type checking
typecheck: install
	@echo "$(BLUE)Running type checking...$(RESET)"
	@if [ -n "$(SRC_FILES)" ]; then uv run --extra dev mypy $(SRC_FILES); fi
	@echo "$(GREEN)✓ Type checking completed$(RESET)"

# Run all checks
check: lint typecheck test check-invisible
	@echo "$(GREEN)✓ All checks passed!$(RESET)"

# Run the application
run: install
	@echo "$(BLUE)Running $(PROJECT_NAME)...$(RESET)"
	@uv run python -m moon_phases.cli

# Run in debug mode
run-debug: install
	@echo "$(BLUE)Running $(PROJECT_NAME) in debug mode (El Paso, TX)...$(RESET)"
	@uv run python -m moon_phases.cli -d

# Build marker for tracking
.build-marker: $(SRC_FILES) pyproject.toml
	@echo "$(BLUE)Source files changed, running checks...$(RESET)"
	@$(MAKE) check
	@echo "$(BLUE)Building $(PROJECT_NAME)...$(RESET)"
	@uv build
	@touch .build-marker
	@echo "$(GREEN)✓ Build completed$(RESET)"

# Build the project (smart rebuild based on source changes)
build: .build-marker
	@echo "$(GREEN)✓ Build is up to date$(RESET)"

# Clean build artifacts and cache
clean:
	@echo "$(BLUE)Cleaning build artifacts...$(RESET)"
	@rm -rf dist/
	@rm -rf build/
	@rm -rf *.egg-info/
	@rm -rf .pytest_cache/
	@rm -rf __pycache__/
	@rm -rf .mypy_cache/
	@rm -rf htmlcov/
	@rm -f .coverage
	@rm -f .build-marker
	@find . -type f -name "*.pyc" -delete
	@find . -type d -name "__pycache__" -delete
	@find src tests -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
	@find src tests -name "*.pyc" -type f -delete 2>/dev/null || true
	@echo "$(GREEN)✓ Cleanup completed$(RESET)"

# Show project status
status:
	@echo "$(BLUE)$(PROJECT_NAME) Status$(RESET)"
	@echo ""
	@echo "$(YELLOW)Python Environment:$(RESET)"
	@uv run python --version
	@echo ""
	@echo "$(YELLOW)Project Version:$(RESET)"
	@grep "version.*=" pyproject.toml
	@echo ""
	@echo "$(YELLOW)Dependencies Status:$(RESET)"
	@echo "Runtime dependencies:"
	@uv run pip list | grep -E "(requests|geopy|timezonefinder|pytz)" || echo "  Dependencies not installed"
	@echo "Dev dependencies:"
	@uv run --extra dev python -c "import pytest, black, flake8, mypy; print(f'  pytest=={pytest.__version__}, black=={black.__version__}, flake8=={flake8.__version__}, mypy installed')" 2>/dev/null || echo "  Dev dependencies not fully installed"
	@echo ""
	@echo "$(YELLOW)Test Status:$(RESET)"
	@if [ -d "tests" ] && [ -n "$(TEST_FILES)" ]; then \
		echo "  ✓ Test suite available"; \
		uv run --extra dev python -c "import sys; sys.path.insert(0, 'tests'); import test_cli; tests = [m for cls in [test_cli.TestMoonData, test_cli.TestIntegration] for m in dir(cls) if m.startswith('test_')]; print(f'  {len(tests)} unit tests found')" 2>/dev/null || echo "  Test count unavailable"; \
	else \
		echo "  ✗ No test suite found"; \
	fi
	@echo ""
	@echo "$(YELLOW)Configuration:$(RESET)"
	@echo "  Python requirement: $(shell grep 'requires-python' pyproject.toml | cut -d'=' -f2 | tr -d ' \"')"
	@echo "  Target Python: $(PYTHON_VERSION)"

# Continuous Integration pipeline
ci: format check build
	@echo "$(GREEN)✓ CI pipeline completed successfully!$(RESET)"



# Quick development check (faster than full check)
quick-check: lint test check-invisible
	@echo "$(GREEN)✓ Quick check completed!$(RESET)"

# Reset environment (clean + fresh install)
reset: clean
	@echo "$(BLUE)Resetting environment...$(RESET)"
	@rm -rf .venv/
	@make install
	@echo "$(GREEN)✓ Environment reset completed!$(RESET)"

# Invisible Character Management
# See docs: scripts/invisible_chars_commands.md for manual detection methods
check-invisible:
	@echo "$(BLUE)Checking for invisible characters...$(RESET)"
	@echo "$(YELLOW)Reference: scripts/invisible_chars_commands.md for manual methods$(RESET)"
	@python scripts/clean_invisible_chars.py src
	@python scripts/clean_invisible_chars.py docs
	@python scripts/clean_invisible_chars.py tests
	@python scripts/clean_invisible_chars.py pyproject.toml
	@echo "$(GREEN)✓ Invisible character check completed$(RESET)"

# Clean invisible characters proactively (with backup)
clean-invisible:
	@echo "$(BLUE)Cleaning invisible characters...$(RESET)"
	@echo "$(YELLOW)Creating backups before cleaning (see scripts/invisible_chars_commands.md)$(RESET)"
	@python scripts/clean_invisible_chars.py src --clean
	@python scripts/clean_invisible_chars.py docs --clean
	@python scripts/clean_invisible_chars.py tests --clean
	@python scripts/clean_invisible_chars.py pyproject.toml --clean
	@echo "$(GREEN)✓ Invisible character cleanup completed$(RESET)"

# Proactive invisible character cleanup for publishing
pre-publish-clean: clean-invisible
	@echo "$(BLUE)Running proactive cleanup for publishing...$(RESET)"
	@echo "$(YELLOW)Ensuring all source files are clean of invisible characters$(RESET)"
	@python scripts/clean_invisible_chars.py . --clean
	@echo "$(GREEN)✓ Pre-publish cleanup completed$(RESET)"

# PyPI Package Building and Publishing
build-package: .venv/pyvenv.cfg clean pre-publish-clean
	@echo "$(BLUE)Building package for PyPI...$(RESET)"
	@echo "$(YELLOW)Package cleaned of invisible characters$(RESET)"
	@uv build
	@echo "$(GREEN)✓ Package built in dist/$(RESET)"

check-package: build-package
	@echo "$(BLUE)Checking package integrity...$(RESET)"
	@uv run twine check dist/*
	@echo "$(GREEN)✓ Package checks passed$(RESET)"

upload-test: check-package
	@echo "$(BLUE)Uploading to Test PyPI...$(RESET)"
	@echo "$(YELLOW)Make sure you have set TWINE_USERNAME and TWINE_PASSWORD for TestPyPI$(RESET)"
	@uv run twine upload --repository testpypi dist/*
	@echo "$(GREEN)✓ Uploaded to Test PyPI$(RESET)"

upload-pypi: check-package
	@echo "$(RED)WARNING: This will upload to the REAL PyPI!$(RESET)"
	@echo "$(YELLOW)Make sure you have set TWINE_USERNAME and TWINE_PASSWORD for PyPI$(RESET)"
	@read -p "Are you sure you want to upload to PyPI? (y/N): " confirm && [ "$$confirm" = "y" ]
	@uv run twine upload dist/*
	@echo "$(GREEN)✓ Uploaded to PyPI$(RESET)"

# Help alias
help: info