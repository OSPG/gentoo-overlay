# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Simple, unix-style music player"
HOMEPAGE="https://github.com/stkw0/cppplayer"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/stkw0/cppplayer"
else
	SRC_URI="https://github.com/stkw0/cppplayer/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="Unlicense"
SLOT="0"
IUSE="test"

DEPEND="dev-libs/spdlog
		media-libs/libsfml
		dev-libs/boost
		media-libs/taglib
		media-sound/mpg123
		dev-cpp/yaml-cpp"

RDEPEND="${DEPEND}"
