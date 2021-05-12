#
# spec file for Parameters package 
#
# Copyright 2021 Hewlett Packard Enterprise Development LP

%define system_name shasta
%define doc_name Shasta
%define namespace cray

%define package_name uan-diagnostics
%define intranamespace_name %{package_name}-%{system_name}
# omit system_name so source doesn't need to be repackaged for each system
%define source_name %{namespace}-%{package_name}-%{version}

Group: System/Boot
License: GPL
Name: %{namespace}-%{intranamespace_name}
Provides: parameters
Version: %(cat .rpm_version_uan-diagnostics)
Release: %(echo ${BUILD_METADATA})
Source: %{source_name}.tar.bz2
Summary: Diagnostics tests for User Access Node
URL: %url
BuildRoot: %{_tmppath}/%{name}-%{version}-build

Requires: %{namespace}-uan-goss

%package uan
Group: System/Boot
Summary: Diagnostics tests for User Access Node
Conflicts: %{namespace}-%{intranamespace_name}

%description uan
This package adds diagnostics testing for UANs to run sanity 
checks and validate basic functionality.

%description
Tests included for %{doc_name} UAN nodes.

%prep
%setup -n %{source_name}

%build

%install
%{__install} -D tests $RPM_BUILD_ROOT/opt/cray/uan/tests

%clean
rm -rf /opt/cray/uan/tests

%files uan
%defattr (-,root,root,755)
%dir /opt/cray/uan/tests/goss
%dir /opt/cray/uan/tests/goss/tests
%dir /opt/cray/uan/tests/goss/scripts
%dir /opt/cray/uan/tests/goss/scripts/gpu
/opt/cray/uan/tests/validate-gpu.sh
/opt/cray/uan/tests/goss/tests/goss-gpu.yaml
/opt/cray/uan/tests/goss/tests/goss-gpu-vars.yaml
/opt/cray/uan/tests/goss/scripts/gpu/cuda-profile
/opt/cray/uan/tests/goss/scripts/gpu/Makefile
/opt/cray/uan/tests/goss/scripts/gpu/hello.cu
/opt/cray/uan/tests/goss/scripts/gpu/hello_dbg.cu
/opt/cray/uan/tests/goss/scripts/gpu/cuda_hello.sh
