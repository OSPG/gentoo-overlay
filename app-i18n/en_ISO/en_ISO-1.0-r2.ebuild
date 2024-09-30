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
	elog "    emerge --config ${CATEGORY}/${P}"
}

pkg_config() {
	if ! locale-gen -l | grep -q "^[[:space:]]*en_ISO.UTF-8 UTF-8"; then
		einfo "Adding locale to locale.gen..."
		echo "en_ISO.UTF-8 UTF-8" >> /etc/locale.gen
	fi

	locale-gen || die
}

