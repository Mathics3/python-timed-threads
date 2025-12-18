# A GNU Makefile to run various tasks - compatibility for us old-timers.

# Note: This makefile include remake-style target comments.
# These comments before the targets start with #:
# remake --tasks to shows the targets and the comments

GIT2CL ?= ./admin-tools/git2cl
PYTHON ?= python3
PIP ?= $(PYTHON) -m pip
RM  ?= rm
PIP_INSTALL_OPTS ?=

.PHONY: all build \
   ChangeLog-without-corrections \
   check clean \
   develop \
   dist \
   pytest \
   rmChangeLog \
   test

#: Default target - same as "develop"
all: develop

#: Set up to run from the source tree
develop:
	$(PIP) install -e .$(PIP_INSTALL_OPTS)

dist:
	$(PYTHON) -m build --sdist && $(PYTHON) -m build --wheel

#: Install development version of timed_threads
install:
	$(PYTHON) -m pip install -e .

#: Run unit tests and Mathics doctest
check: pytest

#: Same as check
test: check

#: Remove derived files
clean:
	@find . -name *.pyc -type f -delete;

#: Run py.test tests. Use environment variable "o" for pytest options
pytest:
	$(PYTHON) -m pytest test $o

#: Remove ChangeLog
rmChangeLog:
	$(RM) ChangeLog || true

#: Create ChangeLog from version control without corrections
ChangeLog-without-corrections:
	git log --pretty --numstat --summary | $(GIT2CL) >ChangeLog

#: Create a ChangeLog from git via git log and git2cl
ChangeLog: rmChangeLog ChangeLog-without-corrections
	patch ChangeLog < ChangeLog-spell-corrected.diff
