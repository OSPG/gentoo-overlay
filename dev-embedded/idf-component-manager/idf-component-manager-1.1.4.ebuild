# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} pypy3 )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Tool for installing ESP-IDF components"
HOMEPAGE="https://github.com/espressif/idf-component-manager"
SRC_URI="https://github.com/espressif/${PN}/archive/refs/tags/v${PV}.tar.gz	-> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/requests-toolbelt[${PYTHON_USEDEP}]
	dev-python/schemschemaa[${PYTHON_USEDEP}]
"

