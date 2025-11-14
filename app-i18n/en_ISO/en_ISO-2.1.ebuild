# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="ISO-compliant English locale"
HOMEPAGE="https://github.com/OSPG/force_xdg"
SRC_URI="https://github.com/OSPG/force_xdg/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}/force_xdg-${PV}/other/locales/en_ISO.UTF-8"

src_install() {
	insinto /usr/share/i18n/locales
	doins en_ISO || die

	insinto /usr/share/X11/locale
	doins Compose || die
	doins XLC_LOCALE || die
	doins XI18N_OBJS || die
}

pkg_postinst() {
	elog "In order to use the new locale, remember to configure and build your locales"
	elog "Afterwards, you'll be able to set LANG=en_ISO.UTF-8 in your environment"
	elog ""
	elog "You can automatically rebuild the locales with:"
	elog "    emerge --config ${CATEGORY}/${PN}"
}

pkg_config() {
	if localedef --list-archive 2>/dev/null | grep -qx 'en_ISO.UTF-8'; then
		einfo "en_ISO.UTF-8 is already present in the locale archive; nothing to do."
		return
	fi

	einfo "Generating en_ISO.UTF-8 locale (localedef)..."
	localedef -i en_ISO -f UTF-8 en_ISO.UTF-8 || die "localedef failed to build en_ISO.UTF-8"
}

