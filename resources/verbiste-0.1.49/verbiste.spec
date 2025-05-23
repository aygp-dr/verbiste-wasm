Name:           verbiste
Version:        0.1.49
Release:        1%{?dist}
Summary:        French conjugation system
Summary(fr):    Système de conjugaison française

Group:          Applications/Text
License:        GPLv2+
URL:            http://sarrazip.com/dev/verbiste.html
Source0:        http://sarrazip.com/dev/%{name}-%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildRequires:  libxml2-devel >= 2.4.0
BuildRequires:  gettext
BuildRequires:  perl
BuildRequires:  perl-XML-Parser

%description
This package contains a database of French conjugation templates
and a list of more than 6000 regular and irregular French verbs
with their corresponding template.  One can obtain the complete
conjugation for a verb from its infinitive form, and obtain the mode,
tense and person from a conjugated verb.  The library comes with two
command-line tools named french-conjugator and french-deconjugator
(see their manual pages).

%description -l fr
Ce paquet contient une base de données de modèles de conjugaison
du français et une liste de plus de 6000 verbes réguliers et
irréguliers avec leur modèle correspondant.  On peut obtenir
la conjugaison complète pour un verbe à partir de sa forme
infinitive, ou encore obtenir le mode, le temps et la personne à
partir d'un verbe conjugué.  La librairie vient avec deux outils à
ligne de commande nommés french-conjugator et french-deconjugator
(voir leurs pages de manuel).


%package devel
Summary:        C++ development files for the Verbiste library
Summary(fr):    En-têtes C++ pour la librairie Verbiste
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       libxml2-devel >= 2.4.0

%description devel
C++ header files to develop with the Verbiste library.

%description -l fr devel
En-têtes C++ pour développer avec la librairie Verbiste.


%package gnome
Summary:        GNOME application based on Verbiste
Summary(fr):    Application Verbiste pour GNOME
Group:          Applications/Text
Requires:       %{name} = %{version}-%{release}

BuildRequires:  libgnomeui-devel  >= 2.0.0
BuildRequires:  gettext
BuildRequires:  desktop-file-utils

%description gnome
GNOME application based on Verbiste.
The user types a verb, possibly conjugated, and this graphical
application finds the verb or verbs in question and displays their
full conjugation, with the original input highlighted in red,
to indicate the mode, tense and person of the entered verb.

%description -l fr gnome
Application Verbiste pour GNOME.
L'utilisateur entre un verbe, possiblement conjugué, et cette
application graphique trouve le ou les verbes en question et affiche
leur conjugaison complète, avec l'entrée originale marquée en
rouge, pour indiquer le mode, le temps et la personne du verbe
entré.

%prep
%setup -q


%build
%configure --with-gnome-app --without-gtk-app --disable-maintainer-mode --without-examples
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT INSTALL="%{__install} -p"
%find_lang %{name}
desktop-file-validate $RPM_BUILD_ROOT/%{_datadir}/applications/%{name}.desktop

# This file gets created on x86_64 for no apparent reason.
# It's owned by glibc-common.
rm -f "$RPM_BUILD_ROOT%{_datadir}/locale/locale.alias"


%clean
rm -rf $RPM_BUILD_ROOT


%post
/sbin/ldconfig

%post gnome
# Tell TeX to rebuild its database of installed files:
if test -x %{texhash}; then %{texhash}; fi

%postun
/sbin/ldconfig

%postun gnome
# Tell TeX to rebuild its database of installed files:
if test -x %{texhash}; then %{texhash}; fi


%files
%defattr(-,root,root,-)
%{_libdir}/lib*.so.*
%{_mandir}/man*/*.*
%{_mandir}/*/man*/*.*
%{_bindir}/french-*
%{_datadir}/%{name}-*
%doc %{_defaultdocdir}/*


%files devel
%defattr(-,root,root,-)
%{_includedir}/*
%{_libdir}/lib*.so
%{_libdir}/lib*.la
%{_libdir}/pkgconfig/*


%files -f %{name}.lang gnome
%defattr(-,root,root,-)
%{_bindir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.svg
%{_datadir}/icons/hicolor/*/apps/%{name}.png
%{_datadir}/texmf/tex/latex/*


%changelog
