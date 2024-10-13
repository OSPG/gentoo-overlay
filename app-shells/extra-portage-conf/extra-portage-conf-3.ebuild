# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="extra configuration files for /etc/portage"

SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

S="${FILESDIR}"

src_install() {
	insinto /etc/portage
	doins "${FILESDIR}/binrepos.conf"

	insinto /etc/portage/env
	doins "${FILESDIR}/env/"*

	insinto /etc/portage/package.env
	doins "${FILESDIR}/package.env/"*
}
