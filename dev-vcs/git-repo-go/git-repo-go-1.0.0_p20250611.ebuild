# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

COMMIT="41c644e4df6b03eb15b186bb330db7c4a844ac73"
DESCRIPTION="CLI/Git extension for interacting with AGit-Flow compatible or Gerrit servers"
HOMEPAGE="https://git-repo.info/"
SRC_URI="
	https://github.com/apteryks/git-repo-go/archive/${COMMIT}.tar.gz -> ${P}.gh.tar.gz
	https://home.cit.tum.de/~salu/distfiles/${P}-deps.tar.xz
"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	emake REPO_VERSION="${PV}"
}

src_install() {
	dobin git-repo-go
	local DOCS=( CHANGELOG.md README.md )
	einstalldocs
}
