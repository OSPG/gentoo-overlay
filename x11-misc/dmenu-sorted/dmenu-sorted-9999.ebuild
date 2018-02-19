# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Sorted dmenu"
HOMEPAGE="https://github.com/stkw0/dmenu-sorted"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}"
else
	KEYWORDS="~amd64"
fi

LICENSE="Unlicense"
SLOT="0"
IUSE="test"

DEPEND="x11-misc/dmenu"
