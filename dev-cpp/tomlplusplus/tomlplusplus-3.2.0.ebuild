# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="IFAE libraries"
HOMEPAGE="https://gitlab.pic.es/ifaecontrol/ifae-libs"
LICENSE="MIT"
SRC_URI="https://github.com/marzer/tomlplusplus/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

SLOT="0"
IUSE=""

