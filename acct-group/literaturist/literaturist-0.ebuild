# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-group

DESCRIPTION="A user-group for blog authors"

ACCT_GROUP_ID=-1

pkg_postinst() {
	einfo "This ebuild simply installs the group on your system."
	einfo ""
	einfo "You probably want to change the ownership of your blog files"
	einfo "and add yourself to this group"

	einfo ""
	einfo "  chown -R nginx:${PN} /srv/yourwebsite/html"
	einfo "  usermod -a -G ${PN} \"\$(whoami)\""
}

