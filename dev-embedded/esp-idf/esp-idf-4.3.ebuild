# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7


PYTHON_COMPAT=( python3_{8,9} )

VER="esp-2020r3"
CROSSTOOL_URL="https://github.com/espressif/crosstool-NG/releases/download/${VER}"

inherit python-r1

DESCRIPTION="Espressif IoT Development Framework"
HOMEPAGE="https://www.espressif.com/"
SRC_URI="https://dl.espressif.com/dl/esp-idf/releases/esp-idf-v${PV}.zip -> ${P}.zip
	https://github.com/espressif/binutils-esp32ulp/releases/download/v2.28.51-esp-20191205/binutils-esp32ulp-linux-amd64-2.28.51-esp-20191205.tar.gz
	https://github.com/espressif/openocd-esp32/releases/download/v0.10.0-esp32-20210721/openocd-esp32-linux64-0.10.0-esp32-20210721.tar.gz
	${CROSSTOOL_URL}/xtensa-esp32-elf-gcc8_4_0-${VER}-linux-amd64.tar.gz
	${CROSSTOOL_URL}/xtensa-esp32s2-elf-gcc8_4_0-${VER}-linux-amd64.tar.gz
	${CROSSTOOL_URL}/xtensa-esp32s3-elf-gcc8_4_0-${VER}-linux-amd64.tar.gz
	https://dl.espressif.com/dl/toolchains/preview/riscv32-esp-elf-gcc8_4_0-crosstool-ng-1.24.0-123-g64eb9ff-linux-amd64.tar.gz
"
#${CROSSTOOL_URL}/riscv32-esp-elf-gcc8_4_0-${VER}-linux-amd64.tar.gz

S="${WORKDIR}/${PN}-v${PV}"

KEYWORDS="~amd64"
LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/bitstring[${PYTHON_USEDEP}]
	dev-python/construct[${PYTHON_USEDEP}]
	dev-python/ecdsa[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/kconfiglib[${PYTHON_USEDEP}]
	dev-python/pyelftools[${PYTHON_USEDEP}]
	<dev-python/pyparsing-2.4.0[${PYTHON_USEDEP}]
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/python-socketio[${PYTHON_USEDEP}]
	dev-python/reedsolomon[${PYTHON_USEDEP}]
	dev-embedded/esptool[${PYTHON_USEDEP}]
"

RESTRICT="strip"

QA_PREBUILT="opt/* usr/lib*"
QA_PRESTRIPPED="opt/*"

install_tool() {
	shopt -s globstar

	into /opt/${1}

	if [[ -d "../${1}/lib" ]]; then
		if stat *.so &>/dev/null; then
		for i in ../${1}/lib/**/*.so*; do
			dolib.so ${i}
		done
		fi
		
		if stat *.a &>/dev/null; then
		for i in ../${1}/lib/**/*.a*; do
			dolib.a ${i}
		done
		fi
		
		insinto /opt/${1}/lib
		doins -r ../${1}/lib/*
	fi

	exeinto /opt/${1}/bin
	doexe ../${1}/bin/*
	(
	cd ../${1}
	for i in libexec/**/*; do
		exeinto /opt/${1}/$(dirname ${i})
		if [[ -x "${i}" && ! -d "${i}" ]]; then
			doexe ${i}
		fi
	done

	if [[ -d "include" ]]; then
		insinto /opt/${1}
		doins -r include
	fi
	)

	(
		cd ${D}/opt/${1}/bin/ || die
		for i in *; do
			dodir /opt/bin
			cd ${D}/opt/bin || die
			dosym ../${1}/bin/${i} /opt/bin/${i}
		done
	)
}

src_install() {
	echo -e "#!/bin/sh\npython /usr/share/${PN}/tools/idf.py \"$@\"" > idf
	dobin idf

	install_tool xtensa-esp32-elf
	install_tool xtensa-esp32-elf/xtensa-esp32-elf
	install_tool xtensa-esp32s2-elf
	install_tool xtensa-esp32s3-elf
	install_tool riscv32-esp-elf
	install_tool esp32ulp-elf-binutils
	install_tool openocd-esp32

	echo "IDF_PATH=/usr/share/${PN}" > 99esp-idf || die
	doenvd 99esp-idf

	insinto /usr/share/${PN}
	rm requirements.txt || die
	touch requirements.txt

	rm -r .git || die
	doins -r .
}


