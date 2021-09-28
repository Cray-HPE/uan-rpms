#
# spec file for Parameters package 
#
# Copyright 2020-2021 Hewlett Packard Enterprise Development LP
# This file and all modifications and additions to the pristine
# package are under the same license as the package itself.
#

%define system_name shasta
%define doc_name Shasta
%define namespace cray

%define package_name uan-boot-parameters
%define intranamespace_name %{package_name}-%{system_name}
# omit system_name so source doesn't need to be repackaged for each system
%define source_name %{namespace}-%{intranamespace_name}-uan-%{version}

Group: System/Boot
License: GPL
Name: %{namespace}-%{intranamespace_name}
Provides: parameters
Version: %(cat .rpm_version_uan-boot-params)
Release: %(echo ${BUILD_METADATA})
Source: %{source_name}.tar.bz2
Summary: The default parameters (cmdline boot options) for %{doc_name} uan nodes
URL: %url
BuildRoot: %{_tmppath}/%{name}-%{version}-build

%package uan
Group: System/Boot
Summary: Boot parameters for %{_arch} %{doc_name} uan nodes
Conflicts: %{namespace}-%{intranamespace_name}

%description
This package is the container for the default parameters file on
%{_arch} %{doc_name} systems.  This file controls the options passed to the Linux
kernel.  Parameters are provided for uan nodes.

%description uan
Boot parameters for %{_arch} %{doc_name} uan nodes.

%prep
%setup -n %{source_name}

%build

%install
%{__install} -D boot-params/parameters-%{_arch}_%{system_name}_c $RPM_BUILD_ROOT/boot/parameters-%{system_name}_c
ln -s /boot/parameters-%{system_name}_c $RPM_BUILD_ROOT/boot/kernel-parameters

%clean
rm -f /boot/parameters-%{system_name}_c

%files uan
%defattr (-,root,root,755)
%dir /boot
/boot/parameters-%{system_name}_c
/boot/kernel-parameters
