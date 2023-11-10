# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_11 )

inherit distutils-r1

DESCRIPTION="Pyqt tools"
HOMEPAGE="
	https://github.com/IFAEControl/pyqt_tools
"

inherit git-r3

EGIT_REPO_URI="https://github.com/IFAEControl/pyqt_tools"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS=""
