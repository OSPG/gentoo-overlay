# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="LSP implementation for Lua, by sumneko"
HOMEPAGE="https://github.com/sumneko/lua-language-server"
SRC_URI="
	https://github.com/sumneko/lua-language-server/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/sumneko/lua-language-server/releases/download/${PV}/${P}-submodules.zip -> ${P}-submodules.zip
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/ninja
	dev-lua/luamake
"

src_unpack() {
	unpack ${P}.tar.gz
	einfo "Unpacked main"
	cd ${P}
	unpack ${P}-submodules.zip
	einfo "Unpacked subs"
}

src_compile() {
	einfo "We are currently in $(pwd)"
	luamake || die "failed to build ${P}"
}

src_install() {
	dobin bin/lua-language-server
	newdoc doc/en-us/config.md lua-language-server
}

