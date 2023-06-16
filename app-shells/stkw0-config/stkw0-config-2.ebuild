# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="My configuration"

SLOT="0"
KEYWORDS="~amd64"

IUSE="+stkw0-desktop stkw0-work"
RESTRICT="test"

DEPEND="
	app-admin/eclean-kernel
	app-doc/stdman
	app-editors/vim
	app-i18n/translate-shell
	app-portage/eix
	app-portage/pfl
	app-portage/genlop
	app-portage/gentoolkit
	app-shells/zsh
	app-shells/zsh-completions
	kde-apps/ffmpegthumbs
	kde-misc/kdeconnect
	kde-misc/kio-gdrive
	kde-misc/plasma-pass
	media-fonts/kochi-substitute
	net-analyzer/netcat
	net-dns/dnscrypt-proxy
	net-misc/chrony
	net-misc/keychain
	sys-apps/exa
	sys-apps/lm-sensors
	x11-terms/alacritty

	stkw0-desktop? (
		kde-apps/dolphin
		mail-client/thunderbird
		media-sound/spotify
		net-irc/quassel[-server,-crypt]
		www-client/firefox

		!stkw0-work? (
			net-im/discord
			net-p2p/qbittorrent
		)

		stkw0-work? (
			app-doc/doxygen
			app-containers/docker
			app-containers/docker-cli
			dev-util/kdevelop
			net-analyzer/wireshark
			net-im/slack
		)
	)
"
RDEPEND="${DEPEND}"

S="${FILESDIR}"

src_install() {
	insinto /etc/zsh
	doins "${FILESDIR}/zsh/"*

	insinto /etc/portage
	doins "${FILESDIR}/binrepos.conf"

	for i in /home/*; do
		insinto "$i/.config/alacritty"
		doins "${FILESDIR}/alacritty.yml"

		insinto "$i/.gnupg"
		doins "${FILESDIR}/gpg-agent.conf"

		insinto "$i/.config/git"
		doins "${FILESDIR}/ignore"
	done
}

pkg_config() {
	rc-update add dnscrypt-proxy default
	rc-service dnscrypt-proxy start

	rc-update add chronyd default
	rc-service chronyd start
}
