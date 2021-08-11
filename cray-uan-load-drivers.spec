#
# spec file for Parameters package 
#
# Copyright 2021 Hewlett Packard Enterprise Development LP

%define system_name shasta
%define doc_name Shasta
%define namespace cray

%define package_name uan-load-drivers
%define intranamespace_name %{package_name}-%{system_name}
# omit system_name so source doesn't need to be repackaged for each system
%define source_name %{namespace}-%{intranamespace_name}-uan-%{version}

Group: System/Boot
License: GPL
Name: %{namespace}-%{intranamespace_name}
Provides: parameters
Version: %(cat .rpm_version_uan-load-drivers)
Release: %(echo ${BUILD_METADATA})
Source: %{source_name}.tar.bz2
Summary: The default required drivers for %{doc_name} uan nodes
URL: %url
BuildRoot: %{_tmppath}/%{name}-%{version}-build

%package uan
Group: System/Boot
Summary: Required drivers for %{doc_name} uan nodes
Conflicts: %{namespace}-%{intranamespace_name}

%description
This package is the container for drivers needed for to support
HPE hardware used as uan nodes for the Cray Shasta system.

%description uan
Drivers needed for %{doc_name} uan nodes.

%prep
%setup -n %{source_name}

%build

%install
%{__install} -D load-drivers/qlogic.conf $RPM_BUILD_ROOT/etc/modules-load.d/qlogic.conf
%{__install} -D load-drivers/disk.conf $RPM_BUILD_ROOT/etc/modules-load.d/disk.conf

%clean
rm -f /etc/modules-load.d/qlogic.conf
rm -f /etc/modules-load.d/disk.conf

%files uan
%defattr (-,root,root,755)
/etc/modules-load.d/qlogic.conf
/etc/modules-load.d/disk.conf
