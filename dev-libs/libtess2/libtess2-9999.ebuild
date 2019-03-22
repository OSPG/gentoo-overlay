# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Game and tools oriented refactored version of GLU tesselator."
HOMEPAGE="https://github.com/memononen/libtess2"

LICENSE="SGI-B-2.0"
IUSE=""
SLOT="0"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="${HOMEPAGE}"
	inherit git-r3
fi

BDEPEND="dev-util/premake:4"
DEPEND=""
RDEPEND=""

src_configure() {
	premake4 gmake
}

src_compile() {
	unset ARCH
	cd Build || die
	emake config=release tess2
}

src_install() {
	doheader Include/*

	cd Build || die
	dolib.a  libtess2.a
}
