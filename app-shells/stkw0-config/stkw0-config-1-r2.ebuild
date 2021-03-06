# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="My configuration"

SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	app-admin/eclean-kernel
	app-editors/vim
	app-portage/eix
	app-portage/pfl
	app-portage/genlop
	app-portage/gentoolkit
	app-text/stdman
	app-shells/zsh
	app-shells/zsh-completions
	kde-apps/ffmpegthumbs
	kde-misc/kdeconnect
	kde-misc/kio-gdrive
	kde-misc/plasma-pass
	net-dns/dnscrypt-proxy
	net-misc/chrony
	net-misc/keychain
	sys-apps/exa
	sys-apps/lm-sensors
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
		
		insinto "$i/.gnupg"
		doins "${FILESDIR}/gpg-agent.conf"
	done
}

pkg_config() {
	rc-update add dnscrypt-proxy default
	rc-service dnscrypt-proxy start

	rc-update add chronyd default
	rc-service chronyd start
}
