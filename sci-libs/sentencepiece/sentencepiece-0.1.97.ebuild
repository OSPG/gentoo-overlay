# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_OPTIONAL="1"
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..11} )

inherit cmake distutils-r1

DESCRIPTION="Unsupervised text tokenizer for Neural Network-based text generation"
HOMEPAGE="https://pypi.org/project/sentencepiece/"
SRC_URI="https://github.com/google/sentencepiece/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="
	${PYTHON_DEPS}
"
BDEPEND="
	${DISTUTILS_DEPS}
"

src_prepare() {
	cmake_src_prepare
	use python && distutils-r1_python_prepare_all
}

src_configure() {
	local mycmakeargs=(
		-DSPM_ENABLE_SHARED=OFF
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}"/usr
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	pushd "${S}/python" || die
	use python && python_foreach_impl distutils-r1_python_compile
	popd || die
}

src_install() {
	cmake_src_install

	use python && python_foreach_impl python_install
}

python_install() {
	local so_files
	so_files="$(find "${BUILD_DIR}" -name '*.so' -type f)"
	python_domodule "${so_files}"

	local sentencepiece_dir
	sentencepiece_dir="$(find "${BUILD_DIR}/install/usr/lib" -name "sentencepiece" -type d)"
	python_domodule "${sentencepiece_dir}"
}
