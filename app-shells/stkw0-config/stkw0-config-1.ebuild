# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="My configuration"

SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	app-editors/vim
	app-shells/zsh
	app-shells/zsh-completions
	kde-misc/kdeconnect
	kde-misc/kio-gdrivei
	net-misc/keychain
	sys-apps/exa
	x11-terms/alacritty
"
RDEPEND="${DEPEND}"

S="${FILESDIR}"

src_install() {
	insinto /etc/zsh
	doins "${FILESDIR}/zsh/"*

	for i in /home/*; do
		insinto "$i/.config/alacritty"
		doins "${FILESDIR}/alacritty.yml"
	done
}
