# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Script to help secure a computer system"
HOMEPAGE="https://github.com/OSPG/sv2"
LICENSE="Unlicense"

SLOT="0"
IUSE=""

RDEPEND="
	dev-python/python-iptables[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/OSPG/sv2"
fi

