# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Command-line utility for wlr Wayland extensions (pointer, keyboard, toplevel)"
HOMEPAGE="https://git.sr.ht/~brocellous/wlrctl"
SRC_URI="https://git.sr.ht/~brocellous/wlrctl/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/wlrctl-v${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="+man +zsh-completion"

DEPEND="
dev-libs/wayland
x11-libs/libxkbcommon
man? ( app-text/scdoc )
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local emesonargs=(
		-Dman-pages=$(usex man enabled disabled)
		-Dzsh-completions=$(usex zsh-completion true false)
	)
	meson_src_configure
}
