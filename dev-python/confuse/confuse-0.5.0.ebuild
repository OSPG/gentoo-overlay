# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7} )

inherit distutils-r1

DESCRIPTION="painless YAML config files that Just Work"
HOMEPAGE="https://github.com/sampsyo/confuse"
LICENSE="MIT"

SLOT="0"
IUSE="test"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
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
