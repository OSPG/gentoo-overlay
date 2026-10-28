# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Create a DjVu files from PDF files"
HOMEPAGE="https://github.com/OSPG/pdf2djvu"
SRC_URI="https://github.com/OSPG/pdf2djvu/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="nls openmp test"
KEYWORDS="~amd64"

DEPEND="
	app-text/djvu
	app-text/poppler
	media-gfx/graphicsmagick
	nls? ( virtual/libntl )
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	local mycmakeargs=(
		-DENABLE_GRAPHICSMAGICK=ON
		-DENABLE_NLS=$(usex nls)
		-DENABLE_HEAP_PROFILING=OFF
	)

	cmake_src_configure
}
