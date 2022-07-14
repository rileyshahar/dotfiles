"""Configuration for `nox`, which runs tests in a virtualized environment."""

import nox
from nox import Session
from nox_poetry import session as nox_session

# default nox sessions (overridden with -s)
nox.options.sessions = ("lint", "test")

PYTHON_VERSIONS = "3.10"
SRC_LOCATIONS = ["src", "tests"]

TEST_DEPS = ("pytest", "pytest-cov", "pytest-lazy-fixture", "pytest-mock")
LINTERS = (
    "flake8",
    "flake8-black",
    "flake8-bugbear",
    "pydocstyle",
    "mypy",
    "pylint",
)


@nox_session(python=PYTHON_VERSIONS)
def test(session: Session) -> None:
    """Run pytest in the specified python environment."""
    args = session.posargs or ["--cov"]
    session.install(".")
    session.install(*TEST_DEPS)
    session.run("pytest", *args)


@nox.session(python="3.10")
def coverage(session: Session) -> None:
    """Upload coverage data."""
    session.install(".")
    session.install("coverage[toml]", "codecov")
    session.install(*TEST_DEPS)
    session.run("coverage", "xml", "--fail-under=0")
    session.run("codecov", *session.posargs)


@nox_session(python=PYTHON_VERSIONS)
def test_slow(session: Session) -> None:
    """Run the slow python tests."""
    args = session.posargs or ["-m slow"]
    session.install(".")
    session.install(*TEST_DEPS)
    session.run("pytest", *args)


@nox_session(python=PYTHON_VERSIONS)
def lint(session: Session) -> None:
    """Run static linters in the specified python environment."""
    args = session.posargs or SRC_LOCATIONS
    session.install(".")
    session.install(*TEST_DEPS)  # installed so they type check
    session.install(*LINTERS)
    session.run("flake8", *args)
    session.run("pydocstyle", *args)
    session.run("pylint", *args)
    session.run("mypy", *args)


@nox_session(python="3.10")
def fmt(session: Session) -> None:
    """Format the codebase with black."""
    args = session.posargs or SRC_LOCATIONS
    session.install("black", "isort")
    session.run("black", *args)
    session.run("isort", *args)
