# Copyright 2019-2021 Hewlett Packard Enterprise Development LP
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# (MIT License)

# RPM
BUILD_METADATA ?= $(shell git rev-parse --short HEAD)
SOURCE_NAME ?= ${RPM_NAME}-${SPEC_VERSION}
BUILD_DIR ?= $(PWD)/dist/rpmbuild
SOURCE_PATH := ${BUILD_DIR}/SOURCES/${SOURCE_NAME}.tar.bz2

RPM_NAME_SYSTEMD_PRESETS ?= cray-uan-systemd-presets
SPEC_FILE_SYSTEMD_PRESETS ?= ${RPM_NAME_SYSTEMD_PRESETS}.spec
SPEC_VERSION_SYSTEMD_PRESETS ?= $(shell cat .rpm_version_uan-systemd-presets)
SOURCE_NAME_SYSTEMD_PRESETS ?= ${RPM_NAME_SYSTEMD_PRESETS}-${SPEC_VERSION_SYSTEMD_PRESETS}
SOURCE_PATH_SYSTEMD_PRESETS := ${BUILD_DIR}/SOURCES/${SOURCE_NAME_SYSTEMD_PRESETS}.tar.bz2

RPM_NAME_BOOT_PARAM ?= cray-uan-boot-parameters-shasta-uan
SPEC_FILE_BOOT_PARAM ?= cray-uan-boot-params.spec
SPEC_VERSION_BOOT_PARAM ?= $(shell cat .rpm_version_uan-boot-params)
SOURCE_NAME_BOOT_PARAM ?= ${RPM_NAME_BOOT_PARAM}-${SPEC_VERSION_BOOT_PARAM}
SOURCE_PATH_BOOT_PARAM := ${BUILD_DIR}/SOURCES/${SOURCE_NAME_BOOT_PARAM}.tar.bz2

RPM_NAME_DRIVERS ?= cray-uan-load-drivers-shasta-uan
SPEC_FILE_DRIVERS ?= cray-uan-load-drivers.spec
SPEC_VERSION_DRIVERS ?= $(shell cat .rpm_version_uan-load-drivers)
SOURCE_NAME_DRIVERS ?= ${RPM_NAME_DRIVERS}-${SPEC_VERSION_DRIVERS}
SOURCE_PATH_DRIVERS := ${BUILD_DIR}/SOURCES/${SOURCE_NAME_DRIVERS}.tar.bz2

define rpm_prepare
	mkdir -p $(1)/SPECS $(1)/SOURCES
	cp $(2) $(1)/SPECS/
endef

define rpm_package_source
	tar --transform 'flags=r;s,^,/$(1)/,' --exclude .git --exclude dist -cvjf $(2) $(3)
endef

define rpm_build_source
	BUILD_METADATA=${BUILD_METADATA} rpmbuild -ts $(1) --define "_topdir $(2)"
endef

define rpm_build
	BUILD_METADATA=${BUILD_METADATA} rpmbuild -ba $(1) --define "_topdir $(2)"
endef

all: rpm_systemd_presets rpm_boot_param rpm_drivers

rpm_systemd_presets:
	$(call rpm_prepare,${BUILD_DIR},${SPEC_FILE_SYSTEMD_PRESETS})
	$(call rpm_package_source,${SOURCE_NAME_SYSTEMD_PRESETS},${SOURCE_PATH_SYSTEMD_PRESETS},${SPEC_FILE_SYSTEMD_PRESETS} systemd-presets)
	$(call rpm_build_source,${SOURCE_PATH_SYSTEMD_PRESETS},${BUILD_DIR})
	$(call rpm_build,${SPEC_FILE_SYSTEMD_PRESETS},${BUILD_DIR})

rpm_boot_param:
	$(call rpm_prepare,${BUILD_DIR},${SPEC_FILE_BOOT_PARAM})
	$(call rpm_package_source,${SOURCE_NAME_BOOT_PARAM},${SOURCE_PATH_BOOT_PARAM},${SPEC_FILE_BOOT_PARAM} boot-params)
	$(call rpm_build_source,${SOURCE_PATH_BOOT_PARAM},${BUILD_DIR})
	$(call rpm_build,${SPEC_FILE_BOOT_PARAM},${BUILD_DIR})

rpm_drivers:
	$(call rpm_prepare,${BUILD_DIR},${SPEC_FILE_DRIVERS})
	$(call rpm_package_source,${SOURCE_NAME_DRIVERS},${SOURCE_PATH_DRIVERS},${SPEC_FILE_DRIVERS} load-drivers)
	$(call rpm_build_source,${SOURCE_PATH_DRIVERS},${BUILD_DIR})
	$(call rpm_build,${SPEC_FILE_DRIVERS},${BUILD_DIR})

clean:
	rm -rf $(BUILD_DIR)
