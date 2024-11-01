# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="extra configuration files for /etc/portage"

SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

BDEPEND="sys-apps/attr"

S="${FILESDIR}"

src_install() {
	insinto /etc/portage
	doins "${FILESDIR}/binrepos.conf"
	attr -s pkg-source -V ospg "${ED}/etc/portage/binrepos.conf" || die

	insinto /etc/portage/env
	doins "${FILESDIR}/env/"*
	for i in "${ED}/etc/portage/env/"*; do
		attr -s pkg-source -V ospg "${i}" || die
	done

	insinto /etc/portage/package.env
	doins "${FILESDIR}/package.env/"*
	for i in "${ED}/etc/portage/package.env/"*; do
		attr -s pkg-source -V ospg "${i}" || die
	done

	insinto /etc/portage/sets
	doins "${FILESDIR}/sets/"*
	for i in "${ED}/etc/portage/sets/"*; do
		attr -s pkg-source -V ospg "${i}" || die
	done
}
