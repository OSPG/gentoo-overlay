# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8


DESCRIPTION="Jump quickly to directories that you have visited \"frecently.\" A native Zsh port of z.sh with added features."
HOMEPAGE="https://github.com/agkozak/zsh-z"
EGIT_REPO_URI="https://github.com/agkozak/zsh-z"
inherit git-r3


LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="app-shells/zsh app-shells/zsh-completions"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	default
	mkdir -p "${D}"/usr/share/zsh/plugins  # not standard i think
	mkdir -p "${D}"/usr/share/zsh/site-functions
}

src_install() {
	insinto /usr/share/zsh/plugins
	newins zsh-z.plugin.zsh zshz

	insinto /usr/share/zsh/site-functions
	doins _zshz
}

pkg_postinst() {
	elog "To enable zsh-z, you need to source the plugin from your zshrc"
	elog "Add the following line to your zsh configuration files:"
	elog "    . /usr/share/zsh/plugins/zshz"
	elog "For autocompletion, make sure your fpath includes /usr/share/zsh/site-functions"
}
