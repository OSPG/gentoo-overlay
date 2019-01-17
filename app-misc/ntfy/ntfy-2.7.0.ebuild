# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7} )

inherit distutils-r1

DESCRIPTION="A utility for sending notifications, on demand and when commands finish."
HOMEPAGE="https://github.com/dschep/ntfy"
LICENSE="GPL-3.0"

SLOT="0"
IUSE="test telegram"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	dev-python/appdirs[${PYTHON_USEDEP}]

	virtual/notification-daemon

	telegram? (
		app-misc/telegram-send[${PYTHON_USEDEP}]
	)
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
