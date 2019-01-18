# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

HOMEPAGE="https://cloud.google.com/sdk/"

DESCRIPTION="Google Cloud SDK"
SLOT="0"
SRC_URI="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${P}-linux-x86_64.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/google-cloud-sdk"

src_prepare() {
	default
	python_fix_shebang --force .
}

src_install() {
	dodir ${ROOT}/usr/share/google-cloud-sdk || die
	cp -R "${S}/" "${D}/usr/share/" || die "Install failed!"
	dosym ${D}/usr/share/google-cloud-sdk/bin/gcloud /usr/bin/gcloud || die
	python_optimize "${D}"usr/share/${PN}
}
