# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="An unofficial collection of profile for AppArmor application"
HOMEPAGE="https://github.com/OSPG/apparmor-community"

EGIT_REPO_URI="https://github.com/OSPG/apparmor-community.git"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS=""

BDEPEND="sys-apps/attr"

src_install() {
	insinto /etc/apparmor.d
	doins -r profiles/*
	find "${ED}/etc/apparmor.d/"* -type f -exec attr -s pkg-source -V ospg {} \; || die
}
