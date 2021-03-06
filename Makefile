default: help

NAME=pkgpoc
MAN=pkgpoc.1
VERSION=0.0.1
RPMDIST=$(shell rpm --eval '%dist')
RELEASE=1
PWD=$(shell bash -c "pwd -P")
RPMTOP=$(PWD)/rpmbuild
SPEC=$(NAME).spec
TARBALL=$(NAME)-$(VERSION).tar.gz
SRPM=$(NAME)-$(VERSION)-$(RELEASE).src.rpm

help:
	@echo
	@echo "Usage: make <target> where <target> is one of"
	@echo
	@echo "clean     clean temp files from local workspace"
	@echo "doc       generate sphinx documentation and man pages"
	@echo "test      run unit tests locally"
	@echo "tarball   generate tarball of project"
	@echo "rpm       build source codes and generate rpm file"
	@echo "srpm      generate SRPM file"
	@echo "all       clean test doc rpm"
	@echo "flake8    check Python style based on flake8"
	@echo

all: clean test doc rpm

prep:
	#rpmdev-setuptree into project folder
	@mkdir -p rpmbuild/{BUILD,BUIDLROOT,RPMS,SOURCES,SPECS,SRPMS}

clean:
	$(RM) $(NAME)*.tar.gz
	$(RM) -r rpmbuild
	@find -name '*.py[co]' -delete
	make clean -C docs/
	rm -rf docs/build build dist pkgpoc.egg-info

doc:
	make -C docs/ html
	make -C docs/ man
	cp docs/build/man/pkgpoc.1 pkgpoc.1  

spec: $(SPEC).in prep doc
	sed \
		-e 's/@RPM_VERSION@/$(VERSION)/g' \
		-e 's/@RPM_RELEASE@/$(RELEASE)/g' \
		< $(SPEC).in \
		> $(RPMTOP)/SPECS/$(SPEC)

tarball: spec
	git ls-files | tar --transform='s|^|$(NAME)/|' \
	--files-from /proc/self/fd/0 \
	-czf $(RPMTOP)/SOURCES/$(TARBALL) $(RPMTOP)/SPECS/$(SPEC)

srpm: tarball
	rpmbuild --define="_topdir $(RPMTOP)" --define "_specdir $(RPMTOP)/SPECS" \
	-ts $(RPMTOP)/SOURCES/$(TARBALL)

rpm: srpm
	rpmbuild --define="_topdir $(RPMTOP)" --rebuild $(RPMTOP)/SRPMS/$(SRPM)

# Unit tests
TEST_SOURCE=tests
TEST_OUTPUT=$(RPMTOP)/TESTS
TEST_UNIT_FILE=unit-tests.xml

test: prep
	nosetests --verbosity=3 -x --with-xunit --xunit-file=$(TEST_OUTPUT)/$(TEST_UNIT_FILE)	
	@echo

# Check code convention based on flake8
CHECK_DIRS=.
FLAKE8_CONFIG_DIR=tox.ini

flake8:
	flake8 $(CHECK_DIRS) --config=$(FLAKE8_CONFIG_DIR)

