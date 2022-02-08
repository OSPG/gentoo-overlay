# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

MY_PN="Cm"

DESCRIPTION="Base library for Virgo processes"
HOMEPAGE="https://git.ligo.org/virgo/virgoapp/Cm"

MY_VER="v$(ver_rs 1 r 2 p)"

S="${WORKDIR}/${MY_PN}-${MY_VER}"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}"
else
	SRC_URI="https://chaos.kropotkin.rocks/${MY_PN}-${MY_VER}.tar.bz2 -> ${P}.tar.bz2"
	KEYWORDS="~amd64"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="test"

DEPEND=""

