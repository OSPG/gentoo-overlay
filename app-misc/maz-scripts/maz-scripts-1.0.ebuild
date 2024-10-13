# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Generic collection of scripts"
HOMEPAGE="https://mazunki.tech"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
    app-shells/zsh
    sys-apps/coreutils
    app-editors/vim
    net-misc/curl
    app-arch/bzip2
    sys-apps/util-linux
    sys-devel/gcc
    net-misc/wget
    app-shells/bash
    sys-process/findutils
    sys-apps/inotify-tools
    sys-apps/grep
    app-misc/fzf
    sys-apps/bat
    app-text/gnuplot
"

src_unpack() {
	cp -r -T "${FILESDIR}" "${S}"
}

src_install() {
	insinto /usr/lib/maz-scripts/bin
	dobin src/*

	insinto /usr/share/zsh/site-functions
	doins zsh-completions/*
}

pkg_postinst() {
	elog "You may want to add these scripts to your PATH"
	elog "    : export PATH=\"/usr/bin/maz-scripts:${PATH}\""
}


