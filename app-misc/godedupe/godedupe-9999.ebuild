# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Improved and modern fdupes alternative"
HOMEPAGE="https://github.com/ospg/godedupe"

EGO_PN=github.com/ospg/${PN}

if [[ ${PV} == *9999 ]]; then
	inherit golang-vcs
else
	SRC_URI="https://github.com/ospg/godedupe/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	inherit golang-vcs-snapshot
fi

inherit golang-build

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="dev-lang/go"

src_install() {
	dobin godedupe
}
