# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="https://github.com/nakst/gf.git"
inherit git-r3

DESCRIPTION="A GDB frontend for Linux"
HOMEPAGE="https://github.com/nakst/gf"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_compile() {
	./build.sh || die "Failed to build"
}

src_install() {
		dobin gf2
}
