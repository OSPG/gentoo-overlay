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

# NOTE:
#  * QA Notice: Package triggers severe warnings which indicate that it
# *            may exhibit random runtime failures.
# * ../praat-6.4.05/external/gsl/gsl_specfunc__coulomb.c:994:17:
#		warning: variable 'G_lam_G' is uninitialized when used here [-Wuninitialized]
# * ../praat-6.4.05/external/gsl/gsl_specfunc__coulomb.c:996:17:
#		warning: variable 'Gp_lam_G' is uninitialized when used here [-Wuninitialized]
#  * ../praat-6.4.05/external/glpk/glpssx01.c:790:25:
#		warning: left operand of comma operator has no effect [-Wunused-value]
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
	EOF

	# NOTE:
	# create_espeak_ng_FileInMemorySet__ru.o gives symbol errors, but binding this to espeak seems to work.
	# ideally, we'd use system app-accessibility/espeak-ng anyway, but.
	sed -i "s/\(create_espeak_ng_FileInMemorySet\).cpp/& \1__ru.cpp/" "${S}/external/espeak/meson.build" || die
	default
}

src_install() {
	meson_src_install

	pushd main
	doicon -s scalable praat-480.svg
	domenu praat.desktop
	popd

	pushd "${BUILD_DIR}/main"
	dobin praat
	popd
}
