# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHROMIUM_LANGS="af am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk ur vi zh-CN zh-TW"

inherit chromium-2 pax-utils unpacker

DESCRIPTION="The upstream Electron binary package"
HOMEPAGE="https://www.electronjs.org/"
SRC_URI="
	amd64? ( https://github.com/electron/electron/releases/download/v${PV}/electron-v${PV}-linux-x64.zip )
	arm? ( https://github.com/electron/electron/releases/download/v${PV}/electron-v${PV}-linux-armv7l.zip )
	arm64? ( https://github.com/electron/electron/releases/download/v${PV}/electron-v${PV}-linux-arm64.zip )
	https://www.electronjs.org/headers/v${PV}/node-v${PV}-headers.tar.gz -> electron-node-v${PV}-headers.tar.gz
"
S="${WORKDIR}"

CHROMIUM_VERSION="138" # Check the releases page; gets correct chromium-ffmpeg version.

# Electron is BSD, Node is already covered by chromium's licence; use the string from the appropriate chromium ebuild.
# RAR is not conditional, however.
LICENSE="BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 Base64 Boost-1.0 CC-BY-3.0 CC-BY-4.0 Clear-BSD"
LICENSE+=" FFT2D FTL IJG ISC LGPL-2 LGPL-2.1 libpng libpng2 MIT MPL-1.1 MPL-2.0 Ms-PL openssl PSF-2"
LICENSE+=" SGI-B-2.0 SSLeay SunSoft Unicode-3.0 Unicode-DFS-2015 Unlicense unRAR UoI-NCSA X11-Lucent"
SLOT="${PV%%\.*}"
# Someone can handle arm, I don't have anything to test it on.
KEYWORDS="~amd64 ~arm64"

IUSE="+ffmpeg-chromium +proprietary-codecs"

RESTRICT="strip"

BDEPEND="app-arch/unzip"

RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	app-misc/ca-certificates
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	>=dev-libs/nss-3.26
	media-fonts/liberation-fonts
	media-libs/alsa-lib
	media-libs/mesa[gbm(+)]
	net-misc/curl
	net-print/cups
	sys-apps/dbus
	sys-libs/glibc
	sys-libs/libcap
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	|| (
		x11-libs/gtk+:3[X]
		gui-libs/gtk:4[X]
	)
	x11-libs/libdrm
	>=x11-libs/libX11-1.5.0
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/libxshmfence
	x11-libs/pango
	x11-misc/xdg-utils
	proprietary-codecs? (
		!ffmpeg-chromium? ( >=media-video/ffmpeg-6.1-r1:0/58.60.60[chromium] )
		ffmpeg-chromium? ( media-video/ffmpeg-chromium:${CHROMIUM_VERSION} )
	)
"

QA_PREBUILT="*"

pkg_pretend() {
	# Protect against people using autounmask overzealously
	use amd64 || use arm64 || use arm || die "${PN} only works on amd64"
}

pkg_setup() {
	chromium_suid_sandbox_check_kernel_config
}

src_unpack() {
	:
}

src_install() {
	local electron_home="opt/electron/${PV%%.*}"

	dodir "${electron_home}"
	mkdir -p "${ED}/${electron_home}/" || die
	cd "${ED}/${electron_home}" || die
	unpacker

	cp "${FILESDIR}/node" .
	chmod +x node || die

	# Install the node headers
	mv node_headers/include . || die
	rm -r node_headers || die
	chmod -R 755 "${ED}/${electron_home}/include" || die

	pushd "locales" > /dev/null || die
	chromium_remove_language_paks
	popd > /dev/null || die

	# Replace the bundled ffmpeg with one that can decode more formats.
	if use proprietary-codecs; then
		rm libffmpeg.so || die
		dosym ../../../usr/$(get_libdir)/chromium/libffmpeg.so$(usex ffmpeg-chromium .${CHROMIUM_VERSION} "") \
			  /${electron_home}/libffmpeg.so
	fi

	pax-mark m "${electron_home}/electron"

	exeinto "/usr/bin"
	sed -e "s|@ELECTRON@|electron/${PV%%.*}|g" \
		"${FILESDIR}/electron-launcher.sh" > "${T}/electron-launcher.sh" || die
	newexe "${T}/electron-launcher.sh" "electron-bin-${PV%%.*}"

}
