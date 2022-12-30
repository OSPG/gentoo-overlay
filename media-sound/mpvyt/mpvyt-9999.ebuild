# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10,11} pypy3 )
DISTUTILS_USE_PEP517=setuptools
inherit git-r3 distutils-r1

DESCRIPTION="A playlist manager daemon for mpv"
HOMEPAGE="https://github.com/mattmelling/mpvyt"
EGIT_REPO_URI="https://github.com/mattmelling/mpvyt"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

DEPEND="
	dev-python/requests
	dev-python/beautifulsoup4
	dev-python/lxml
"
RDEPEND="media-video/mpv"
BDEPEND="
	dev-python/setuptools
"

python_install_all() {
	distutils-r1_python_install_all
	doexe ${PN}
}
