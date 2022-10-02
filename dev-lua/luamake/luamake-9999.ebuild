# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Build system for LUA programs"
HOMEPAGE="https://github.com/actboy168/luamake"
SRC_URI="https://github.com/actboy168/luamake/archive/refs/tags/${PV}.tar.gz -> ${P}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/ninja
"

src_compile() {
	compile/install.sh || die "luamake failed to build ${P}-${PV}"
}

src_install() {
	dobin luamake
}

