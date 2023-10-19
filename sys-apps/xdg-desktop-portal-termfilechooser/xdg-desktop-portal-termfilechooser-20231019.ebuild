# Copyright 1999-2023 Gentoo Authors# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="https://github.com/GermainZ/xdg-desktop-portal-termfilechooser.git"
EGIT_COMMIT="71dc7ab"

inherit git-r3

DESCRIPTION="xdg-desktop-portal backend for choosing files with your favorite file chooser"
HOMEPAGE="https://github.com/GermainZ/xdg-desktop-portal-termfilechooser"

LICENSE="MIT"
SLOT="0"
# KEYWORDS="~amd64"

DEPEND="
dev-util/meson
dev-util/ninja
"
RDEPEND="
sys-apps/xdg-desktop-portal
gui-libs/wlroots
"

src_configure() {
	meson setup build --prefix="/usr" --libexecdir="/usr/libexec"
}

src_compile() {
	ninja -C build
}

src_install() {
	DESTDIR="${D}" ninja -C build install

}
