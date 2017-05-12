Name:		pkgpoc
Version:	0.0.1
Release:	1
Summary:	pkgpoc python script project packaging RPM
Group:		Applications/Tools
License:	GPL3+
Source0:	http://github.com/eduardocerqueira/pkgpoc/%{name}-%{version}.tar.gz

BuildArch:		noarch
BuildRequires:  python-setuptools
BuildRequires:  python-nose
Requires:       python

%global debug_package %{nil}

%description
pkgpoc is a CLI python test project packaging as RPM

%prep
%setup -q -n %{name}

%build
%{__python} setup.py build

%install
%{__python} setup.py install -O1 --skip-build --root %{buildroot}
mkdir -p %{buildroot}/%{_mandir}/man1
cp pkgpoc.1 %{buildroot}/%{_mandir}/man1/pkgpoc.1

%files
%defattr(755,root,root,755)
%{python_sitelib}/pkgpoc*
%attr (755,root,root)/usr/bin/pkgpoc
%doc README.md
%doc AUTHORS
%{_mandir}/man1/pkgpoc.1.gz

%changelog
* Thu May 11 2017 Eduardo Cerqueira <ecerquei@redhat.com> 0.0.1-1
- new package built with tito

* Sun Oct 30 2016 Eduardo Cerqueira <eduardomcerqueira@gmail.com> - 0.0.1
- initial build
