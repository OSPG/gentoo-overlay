# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION=""
HOMEPAGE="https://git.kropotkin.rocks/david/yamp2"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.kropotkin.rocks/david/${PN}"
else
	SRC_URI=""
	KEYWORDS="~amd64"
fi

LICENSE="Unlicense"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
