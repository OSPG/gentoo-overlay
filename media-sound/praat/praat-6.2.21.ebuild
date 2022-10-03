# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Praat is a speech analysis tool used for doing phonetics by computer."
HOMEPAGE="https://praat.org/"
SRC_URI="https://github.com/praat/praat/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL3.0+"
SLOT="0"
KEYWORDS="~amd64"

IUSE="alsa +pulse jack"

DEPEND="
	x11-libs/gtk+:3
	alsa? ( media-libs/alsa-lib )
	pulse? ( media-sound/pulseaudio )
	jack? ( virtual/jack )
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	default
	if use pulse; then
		cp makefiles/makefile.defs.linux.pulse ./makefile.defs
	elif use jack; then
		cp makefiles/makefile.defs.linux.jack ./makefile.defs
	elif use alsa; then
		cp makefiles/makefile.defs.linux.alsa ./makefile.defs
	else
		ewarn "No audio provided. Building silent praat"
		cp makefiles/makefile.defs.linux.silent ./makefile.defs
	fi
}

