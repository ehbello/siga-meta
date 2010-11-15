#!/bin/make -f

.SILENT:

DEBTOOL ?= dpkg-buildpackage -rfakeroot
PKGNAME = $*
DATE = $(shell date +"%b %d %T")

.PHONY: all
all: $(patsubst %/gcs,%.build,$(wildcard */gcs))

%.build: %/svgz %/gcs/changelog
	$(info [$(DATE)] $(PKGNAME): starting build process...)
	(cd $(PKGNAME); $(DEBTOOL))
	touch $(PKGNAME).build

%/gcs/changelog: %/gcs/info %/clean
	$(info [$(DATE)] $(PKGNAME): building debian files...)
	(cd $(PKGNAME); gcs_build -S)

%/svgz:
	$(info [$(DATE)] $(PKGNAME): gzipping SVG files...)
	find $(PKGNAME) -iname "*.svg" \
		-exec gzip '{}' \; \
		-exec mv '{}.gz' '{}z' \;

%/svg:
	$(info [$(DATE)] $(PKGNAME): gunzipping SVGZ files...)
	find $(PKGNAME) -iname "*.svgz" \
		-exec mv '{}' '{}.gz' \; \
		-exec gunzip '{}.gz' \; \
		-exec rename 's/\.svgz$$/\.svg/' {} \;

%/clean:
	$(info [$(DATE)] $(PKGNAME): cleanning useless files...)
	-find $(PKGNAME) -iname "*.gcs" -delete
	-rm -rf $(PKGNAME)/debian

%/realclean: %/svg
	$(info [$(DATE)] $(PKGNAME): removing all output files...)
	-rm -f $(PKGNAME)*.build
	-rm -f $(PKGNAME)*.dsc
	-rm -f $(PKGNAME)*.changes
	-rm -f $(PKGNAME)*.tar.gz
	-rm -f $(PKGNAME)*.deb

.PHONY: clean
clean: $(patsubst %/gcs,%/clean,$(wildcard */gcs))

.PHONY: realclean
realclean: $(patsubst %/gcs,%/realclean,$(wildcard */gcs)) clean

