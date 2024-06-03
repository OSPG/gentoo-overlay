# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11,12} )

inherit distutils-r1

DESCRIPTION="Pyqt tools"
HOMEPAGE="
	https://github.com/IFAEControl/pyqt_tools
"

if [[ ${PV} == *9999 ]]; then
    inherit git-r3
	EGIT_REPO_URI="https://github.com/IFAEControl/pyqt_tools"
else
    SRC_URI="https://github.com/IFAEControl/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
    KEYWORDS="~amd64"
fi

LICENSE="Unlicense"
SLOT="0"
