# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: Next generation completion framework after neocomplcache"
HOMEPAGE="https://github.com/Shougo/neocomplete.vim"
SRC_URI="https://github.com/Shougo/neocomplete.vim/archive/ver.${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="!!app-vim/neocomplcache"

VIM_PLUGIN_HELPFILES="${PN}.txt"

S="${WORKDIR}/${PN}.vim-ver.${PV}"
