# Copyright 2021 Hewlett Packard Enterprise Development LP
#
# This spec file generates an RPM that installs goss
#

%define install_dir /usr/bin

Name: cray-uan-goss
BuildArch: noarch
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}
License: HPE Proprietary
Summary: Installs the goss package release
Version: %(cat .rpm_version_uan-goss)
Release: %(echo ${BUILD_METADATA})
Source: %{name}-%{version}.tar.bz2
Vendor: Hewlett Packard Enterprise Development LP

BuildRequires: curl

%description

%prep
%setup -q

%build

%install
install -m 0755 -d %{buildroot}%{install_dir}/
curl -L https://github.com/aelsabbahy/goss/releases/download/v%{version}/goss-linux-amd64 -o goss-%{version}
chmod a+x goss-%{version}
cp goss-%{version} %{buildroot}%{install_dir}/goss

%clean

%files
%license LICENSE
%{install_dir}/goss

%changelog
