EAPI=8

inherit meson desktop

DESCRIPTION="Praat: doing phonetics by computer"
HOMEPAGE="http://www.praat.org/"
SRC_URI="https://github.com/praat/praat/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

IUSE="+pulseaudio +alsa static-libs +X"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
SLOT="0"

# NOTE: i stole some of these deps from zugaina
RDEPEND="
	x11-libs/gtk+:3
	x11-libs/libX11
	sci-libs/gsl
	media-libs/libvorbis
	media-sound/lame
	media-libs/flac
	media-libs/opusfile
	app-accessibility/espeak-ng
	sci-mathematics/glpk
	virtual/pkgconfig
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )
"
DEPEND="
	pulseaudio? ( media-sound/pulseaudio )
	static-libs? ( media-libs/alsa-lib )
	X? ( x11-libs/gtk+:3 )
	!X? ( x11-libs/pango )
"

S="${WORKDIR}/praat-${PV}"

src_prepare() {
	local mk_default
	if use X; then
		if use static-libs; then
			if use pulseaudio; then
				mk_default=pulse_static
			else
				mk_default=alsa
			fi
		else
			if use pulseaudio; then
				mk_default=pulse
			else
				mk_default=silent
			fi
		fi
	else
		mk_default=nogui
	fi

	cp "${S}/makefiles/makefile.defs.linux.${mk_default}" "${S}/makefile.defs" || die
	cat <<-EOF >> makefile.defs
		CFLAGS += ${CFLAGS}
		LDFLAGS += ${LDFLAGS}
		CXXFLAGS += ${CXXFLAGS}
		SRC_FILES += kar/wctype_portable.cpp
	EOF

	sed -i "/sources = /s/longchar.cpp/& wctype_portable.cpp/" kar/meson.build || die

	default
}

src_install() {
	meson_src_install

	pushd main || exit
	doicon -s scalable praat-480.svg
	domenu praat.desktop
	popd || exit

	pushd "${BUILD_DIR}/main" || exit
	dobin praat
	popd || exit
}
