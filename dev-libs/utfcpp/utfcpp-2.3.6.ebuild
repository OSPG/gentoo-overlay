# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="UTF-8 with C++ in a Portable Way"
HOMEPAGE="https://github.com/nemtrif/utfcpp"

LICENSE="Boost-1.0"
IUSE="test"
SLOT="0"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="${HOMEPAGE}"
	inherit git-r3
else
	SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DEPEND=""
RDEPEND=""
