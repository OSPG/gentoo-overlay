# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual package for gui-wm/sway"
SLOT="0"
KEYWORDS="~amd64"

IUSE="pipewire extra gtk termfilechooser screencast"

RDEPEND="
	gui-wm/sway
	gui-apps/wofi
	gui-apps/mako
	gui-apps/waybar
	app-misc/wayland-utils
	gui-apps/wl-clipboard
	gui-apps/wlsunset
	sys-apps/xdg-desktop-portal

	gtk? (
		gui-libs/xdg-desktop-portal-gtk
	)
	termfilechooser? (
		gui-libs/xdg-desktop-portal-termfilechooser
	)

	extra? (
		gui-apps/grim
		gui-apps/slurp
		gui-apps/showmethekey
		gui-apps/wl-mirror
	)

	pipewire? (
		media-video/pipewire[sound-server]
		media-sound/pulseaudio[-daemon]
	)

	screencast? (
		media-video/pipewire
		sys-apps/xdg-desktop-portal-wlr
	)
"

