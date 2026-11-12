# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION=""
HOMEPAGE="https://git.kropotkin.rocks/david/yamp2"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.kropotkin.rocks/david/${PN}"
else
	SRC_URI=""
	KEYWORDS="~amd64"
fi

LICENSE="Unlicense"
SLOT="0"

DEPEND="
	>=dev-libs/qtkeychain-0.17:=
	dev-libs/re2:=
	>=dev-libs/spdlog-1.12:=
	dev-libs/wayland
	>=dev-qt/qtbase-6.10:6[concurrent,dbus,gui,network,opengl,sql,sqlite,ssl,widgets]
	>=dev-qt/qtmultimedia-6.10:6[ffmpeg]
	>=dev-qt/qtsvg-6.10:6
	>=dev-qt/qtwebengine-6.10:6[widgets]
	kde-frameworks/kidletime:6
	>=media-libs/taglib-2.0:=
	>=media-video/mpv-0.35[libmpv]
	net-libs/libpsl
"
RDEPEND="${DEPEND}
	media-video/ffmpeg
	net-misc/yt-dlp[deno]
"
BDEPEND="
	dev-util/wayland-scanner
	virtual/pkgconfig
"
