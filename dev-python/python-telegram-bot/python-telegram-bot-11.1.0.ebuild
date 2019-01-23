# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7} )

inherit distutils-r1

DESCRIPTION="Python wrapper of telegram bots API"
HOMEPAGE="https://python-telegram-bot.org/"
LICENSE="GPL-3.0"

SLOT="0"
IUSE="test"

RDEPEND="
	dev-python/PySocks[${PYTHON_USEDEP}]
	dev-python/ujson[${PYTHON_USEDEP}]
"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="$HOMEPAGE"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz -> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

#python_test() {
	#tox -v || die
#}