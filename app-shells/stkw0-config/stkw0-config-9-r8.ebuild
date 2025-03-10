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
	app-admin/needrestart
	app-editors/vim
	app-misc/godedupe
	app-misc/zcock
	app-portage/eix
	app-portage/pfl
	app-portage/genlop
	app-portage/gentoolkit
	app-shells/atuin
	app-shells/extra-portage-conf
	app-shells/zsh
	app-shells/zsh-completions
	media-fonts/kochi-substitute
	media-fonts/ja-ipafonts
	net-analyzer/netcat
	net-misc/chrony
	net-misc/keychain
	net-vpn/tailscale
	sys-apps/bat
	sys-apps/eza
	sys-apps/lm-sensors
	sys-fs/btrfs-progs
	sys-kernel/installkernel[grub]
	sys-process/htop

	stkw0-desktop? (
		app-admin/qtpass
		app-admin/sudo
		app-backup/restic
		app-benchmarks/hyperfine
		app-doc/stdman
		app-misc/diff-so-fancy
		app-misc/wayland-utils
		app-i18n/translate-shell
		app-office/libreoffice
		app-text/aha
		dev-util/vulkan-tools
		kde-apps/ark
		kde-apps/dolphin
		kde-apps/kompare
		kde-apps/ffmpegthumbs
		kde-apps/kdepim-addons
		kde-misc/kdeconnect
		kde-misc/kio-gdrive
		kde-misc/plasma-pass
		kde-plasma/plasma-meta
		mail-client/thunderbird
		media-gfx/feh
		media-video/mpv
		net-dns/avahi
		net-dns/dnscrypt-proxy
		net-irc/quassel[-server,-crypt]
		www-client/firefox
		x11-terms/alacritty
		x11-apps/xdpyinfo

		!stkw0-work? (
			net-im/discord
			net-im/nheko
			net-im/telegram-desktop
			net-p2p/qbittorrent
		)

		stkw0-work? (
			app-text/doxygen
			app-containers/docker
			app-containers/docker-buildx
			app-containers/docker-cli
			dev-util/ccache
			dev-util/cppcheck
			dev-util/kdevelop
			net-analyzer/wireshark
			net-im/slack
			sys-auth/nss-mdns
		)
	)
"
RDEPEND="${DEPEND}"

S="${FILESDIR}"

src_install() {
	insinto /etc/zsh
	doins "${FILESDIR}/zsh/"*

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

	rc-update add tailscale default
	rc-service tailscale start

	if use stkw0-work; then
		rc-update add docker default
		rc-service docker start

		rc-update add avahi-daemon default
		rc-service avahi-daemon start
		# For the client-side eddit /etc/nsswitch.conf 
	fi

	if use stkw0-desktop; then
		# Ensure same basic plasma settings
		cd /home
		elog "Updating kwinrc"
		for i in *; do
			su -c 'kwriteconfig6 --file kwinrc --group "Desktops" --key Rows "3"' $i || die
			su -c 'kwriteconfig6 --file kwinrc --group "Desktops" --key Number "9"' $i || die
			su -c 'kwriteconfig6 --file kwinrc --group "Desktops" --key Name_1 "💻1"' $i || die
			su -c 'kwriteconfig6 --file kwinrc --group "Desktops" --key Name_2 "💻2"' $i || die
			su -c 'kwriteconfig6 --file kwinrc --group "Desktops" --key Name_3 "💻3"' $i || die
			su -c 'kwriteconfig6 --file kwinrc --group "Desktops" --key Name_4 "✒"' $i || die
			su -c 'kwriteconfig6 --file kwinrc --group "Desktops" --key Name_5 "⚒"' $i || die
			su -c 'kwriteconfig6 --file kwinrc --group "Desktops" --key Name_6 "🩺"' $i || die
			su -c 'kwriteconfig6 --file kwinrc --group "Desktops" --key Name_7 "🕯"' $i || die
			su -c 'kwriteconfig6 --file kwinrc --group "Desktops" --key Name_8 "🌏"' $i || die
			su -c 'kwriteconfig6 --file kwinrc --group "Desktops" --key Name_9 "🗨"' $i || die
		done
		elog "Updating git"
		for i in *; do
			su -c 'git config --global branch.sort -committerdate' $1 || die
			su -c 'git config --global tag.sort version:refname' $1 || die
			su -c 'git config --global init.defaultBranch main' $1 || die
			su -c 'git config --global diff.algorithm histogram' $1 || die
			su -c 'git config --global diff.colorMoved plain' $1 || die
			su -c 'git config --global diff.renames true' $1 || die
			su -c 'git config --global diff.mnemonicPrefix true' $1 || die
			su -c 'git config --global merge.conflictstyle zdiff3' $1 || die
			su -c 'git config --global pull.rebase merges' $1 || die
			su -c 'git config --global core.pager "diff-so-fancy | less --tabs=4 -RF"' $1 || die
			su -c 'git config --global interactive.diffFilter "diff-so-fancy --patch"' $1 || die
		done
	fi
}
