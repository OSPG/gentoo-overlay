# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild depens on the next overlays:
# 	- guru 
# 	- bombo82

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
	app-misc/zcock
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
	sys-apps/eza
	sys-apps/lm-sensors
	sys-fs/btrfs-progs
	sys-kernel/installkernel[grub]
	sys-process/htop

	stkw0-desktop? (
		app-admin/qtpass
		app-admin/sudo
		app-office/libreoffice
		kde-apps/dolphin
		kde-plasma/plasma-meta
		mail-client/thunderbird
		media-gfx/feh
		media-sound/spotify
		media-video/mpv
		net-irc/quassel[-server,-crypt]
		www-client/firefox
		x11-terms/alacritty

		!stkw0-work? (
			net-im/discord
			net-p2p/qbittorrent
		)

		stkw0-work? (
			app-text/doxygen
			app-containers/docker
			app-containers/docker-cli
			dev-util/ccache
			dev-util/cppcheck
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
		doins "${FILESDIR}/alacritty.toml"

		insinto "$i/.gnupg"
		doins "${FILESDIR}/gpg-agent.conf"

		insinto "$i/.config/git"
		doins "${FILESDIR}/ignore"
	done

	insinto /etc/portage/sets
	for i in ${FILESDIR}/sets/*; do
		doins "${i}"
	done
}

pkg_config() {
	rc-update add dnscrypt-proxy default
	rc-service dnscrypt-proxy start

	rc-update add chronyd default
	rc-service chronyd start

	if use stkw0-work; then
		rc-update add docker default
		rc-service docker start
	fi
}
