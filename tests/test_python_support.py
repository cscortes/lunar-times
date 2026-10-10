"""Tests for the supported Python range and related dependency pins."""

import re
import sys
import tomllib
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PYPROJECT = ROOT / "pyproject.toml"
LOCK = ROOT / "uv.lock"
WORKFLOWS = ROOT / ".github" / "workflows"
LOCAL_MATRIX = ROOT / "scripts" / "test_all_python.sh"

SUPPORTED = ("3.11", "3.12", "3.13", "3.14")
UNSUPPORTED = ("3.8", "3.9", "3.10", "3.15")


def load_pyproject() -> dict:
    """Load pyproject.toml.

    Returns:
        dict: The parsed project file.
    """
    with PYPROJECT.open("rb") as handle:
        return tomllib.load(handle)


class TestPythonSupport(unittest.TestCase):
    """Checks that packaging and CI stay inside Python 3.11 through 3.14."""

    def test_requires_python_range(self):
        """The package accepts 3.11–3.14 and rejects 3.15."""
        data = load_pyproject()
        self.assertEqual(data["project"]["requires-python"], ">=3.11,<3.15")
        self.assertEqual(data["tool"]["mypy"]["python_version"], "3.11")

    def test_classifiers_match_supported_versions(self):
        """Classifiers list 3.11–3.14 and omit dropped versions."""
        classifiers = load_pyproject()["project"]["classifiers"]
        prefix = "Programming Language :: Python :: "
        for version in SUPPORTED:
            self.assertIn(prefix + version, classifiers)
        for version in UNSUPPORTED:
            self.assertNotIn(prefix + version, classifiers)

    def test_runtime_dependency_pins(self):
        """Geopy, timezonefinder, and numpy match the support range."""
        dependencies = load_pyproject()["project"]["dependencies"]
        self.assertIn("geopy==2.5.0", dependencies)
        self.assertIn("timezonefinder==8.3.0", dependencies)
        self.assertIn(
            "numpy>=1.24.0; python_version<'3.12'",
            dependencies,
        )
        self.assertIn(
            "numpy>=2.5.2; python_version>='3.12'",
            dependencies,
        )

    def test_lockfile_requires_python(self):
        """The lockfile records the same interpreter range."""
        text = LOCK.read_text(encoding="utf-8")
        self.assertIn('requires-python = ">=3.11, <3.15"', text)

    def test_ci_uses_supported_versions_only(self):
        """Workflow Python versions stay inside 3.11–3.14."""
        for workflow in WORKFLOWS.glob("*.yml"):
            text = workflow.read_text(encoding="utf-8")
            pinned = re.findall(
                r"python-version:\s*'(\d+\.\d+)'",
                text,
            )
            for version in pinned:
                self.assertIn(version, SUPPORTED)
            listed = re.findall(
                r"python-version:\s*\[([^\]]+)\]",
                text,
            )
            for group in listed:
                versions = re.findall(r"'(\d+\.\d+)'", group)
                self.assertEqual(tuple(versions), SUPPORTED)

    def test_local_matrix_matches_ci(self):
        """The local multi-version script tests the same minor versions."""
        text = LOCAL_MATRIX.read_text(encoding="utf-8")
        listed = re.search(r"PYTHON_VERSIONS=\(([^)]+)\)", text)
        self.assertIsNotNone(listed)
        patches = re.findall(r"\d+\.\d+\.\d+", listed.group(1))
        minors = tuple(version.rsplit(".", 1)[0] for version in patches)
        self.assertEqual(minors, SUPPORTED)

    def test_running_interpreter_is_supported(self):
        """The interpreter running the suite is inside the declared range."""
        self.assertGreaterEqual(sys.version_info[:2], (3, 11))
        self.assertLess(sys.version_info[:2], (3, 15))
