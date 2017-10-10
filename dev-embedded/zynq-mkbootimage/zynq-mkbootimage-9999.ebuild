# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Simple, unix-style music player"
HOMEPAGE="https://github.com/antmicro/zynq-mkbootimage"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/antmicro/zynq-mkbootimage"
fi

LICENSE="BSD-2-Clause"
SLOT="0"
IUSE=""

DEPEND="dev-libs/libpcre
		dev-libs/libelf"

RDEPEND=""
