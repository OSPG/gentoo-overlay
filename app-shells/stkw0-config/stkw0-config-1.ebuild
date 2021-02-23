# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="My configuration"

SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	net-misc/keychain
"
RDEPEND="${DEPEND}"

S="${FILESDIR}"

src_install() {
	insinto /etc/zsh
	doins "${FILESDIR}/zsh/"*
}
