# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ESBUILD_VERSION=37

inherit desktop edo electron wrapper xdg

DESCRIPTION="A modern self-hosted music player"
HOMEPAGE="https://github.com/jeffvli/feishin"
SRC_URI="https://github.com/jeffvli/feishin/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://gentoo.kropotkin.rocks/distfiles/${P}-vendor.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="media-video/mpv"
BDEPEND="dev-util/pnpm-bin"

src_unpack() {
	default
	mv "${WORKDIR}/${P}-vendor/node_modules" "${S}" || die
}

src_prepare() {
	electron_src_prepare
	generate_electron-builder_bailout_config
}

src_compile() {
	edo pnpm build
	find -type f -name "*.map" -delete || die
	edo ./node_modules/.bin/electron-builder --config "${ELECTRON_BUILDER_CONFIG}" \
		-c.electronDist="${ELECTRON_DIR}" \
		-c.electronVersion="${ELECTRON_VERSION}"
}

src_install() {
	insinto "/usr/$(get_libdir)/${PN}"
	doins dist/linux-unpacked/resources/app.asar

	make_wrapper feishin "${ELECTRON} /usr/$(get_libdir)/${PN}/app.asar"

	local size
	for size in 16 24 32 48 64 72 96 128 256 512 1024; do
		newicon -s "${size}" "assets/icons/${size}x${size}.png" org.jeffvli.feishin.png
	done

	sed \
		-e "s|\${FEISHIN_DESKTOP_EXECUTABLE}|${EPREFIX}/usr/bin/${PN}|g" \
		-e 's| ${FEISHIN_DESKTOP_ARGS}||' \
		feishin.desktop.tmpl > org.jeffvli.feishin.desktop || die
	domenu org.jeffvli.feishin.desktop

	insinto /usr/share/metainfo
	doins org.jeffvli.feishin.metainfo.xml

	einstalldocs
}
