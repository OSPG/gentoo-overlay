# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7} )

inherit distutils-r1

DESCRIPTION="Library for user interfaces for easy dataset editing and display"
HOMEPAGE="https://pypi.python.org/pypi/guidata"
LICENSE="MIT"

SLOT="0"
IUSE=""

RDEPEND="
	
"

SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip -> ${P}.zip"

KEYWORDS="~amd64 ~x86"

