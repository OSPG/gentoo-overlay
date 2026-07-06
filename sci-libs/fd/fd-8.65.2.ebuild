# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

MY_PN="Fd"

DESCRIPTION="Frame library"
HOMEPAGE="https://git.ligo.org/virgo/virgoapp/Fd"

S="${WORKDIR}/${MY_PN}-${PV}"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}"
else
	SRC_URI="https://gentoo.kropotkin.rocks/distfiles/${MY_PN}-${PV}.tar.bz2 -> ${P}.tar.bz2"
	KEYWORDS="~amd64"
fi

LICENSE="LGPL-2.1"
SLOT="0"

DEPEND="
	sci-libs/cfg
	sci-libs/frv
"

PATCHES=( "${FILESDIR}/gcc-compat.patch" )
