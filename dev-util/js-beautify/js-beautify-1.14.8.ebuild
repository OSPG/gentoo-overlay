# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
# DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Beautifier for javascript"
HOMEPAGE="https://beautifier.io/"
SRC_URI="https://github.com/beautify-web/js-beautify/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="javascript +python test"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${P}/python"

distutils_enable_tests pytest

python_prepare_all() {
	cp setup-js.py setup.py || die
	distutils-r1_python_prepare_all
}
