# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="A lightweight multi-platform, multi-architecture assembler framework."
HOMEPAGE="https://github.com/radare/radare2-extras"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/radare/radare2-extras"
else
	SRC_URI="https://github.com/radare/radare2-extras/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="LGPL-3.0"
SLOT="0"
IUSE="test"

DEPEND="dev-libs/keystone"

RDEPEND="${DEPEND}"

src_prepare() {
	cd "${WORKDIR}/${P}/keystone"
	default
}

src_configure() {
	cd "${WORKDIR}/${P}/keystone"
	default
}

src_compile() {
	cd "${WORKDIR}/${P}/keystone"
	export R2PM_PLUGDIR="${D}/usr/lib/radare2/last/"
	export R2PM_PREFIX="${D}/usr/share/radare2/last/prefix"
	default
}

src_install() {
	cd "${WORKDIR}/${P}/keystone"
	mkdir -p "$R2PM_PREFIX"
	mkdir -p "$R2PM_PLUGDIR"
	default
}
