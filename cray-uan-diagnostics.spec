#
# spec file for Parameters package 
#
# Copyright 2021 Hewlett Packard Enterprise Development LP

%define namespace cray
%define uan_dir /opt/cray/uan

%define package_name uan-diagnostics
%define intranamespace_name %{package_name}
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
Tests included for UAN nodes.

%prep
%setup -n %{source_name}

%build

%install
mkdir -p $RPM_BUILD_ROOT/%{uan_dir}/
cp -R tests $RPM_BUILD_ROOT/%{uan_dir}

%clean
rm -rf %{uan_dir}/tests

%files uan
%defattr (-,root,root,755)
%{uan_dir}/tests
