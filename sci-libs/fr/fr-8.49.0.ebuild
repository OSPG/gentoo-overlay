# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Frame library"
HOMEPAGE="https://git.ligo.org/virgo/virgoapp/Fr"

S="${WORKDIR}/Fr-${PV}"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}"
else
	SRC_URI="https://git.ligo.org/virgo/virgoapp/Fr/-/archive/${PV}/Fr-${PV}.tar.bz2 -> ${P}.tar.bz2"
	KEYWORDS="~amd64"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="test"

PATCHES=( "${FILESDIR}/fix-gcc-compat.patch" )
