# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="IFAE libraries"
HOMEPAGE="https://gitlab.pic.es/ifaecontrol/ifae-libs"
LICENSE="Unlicense"

SLOT="0"
IUSE=""

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.pic.es/ifaecontrol/ifae-libs.git"
fi

