# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="A lightweight multi-platform, multi-architecture assembler framework."
HOMEPAGE="https://github.com/keystone-engine/keystone"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/keystone-engine/keystone"
else
	SRC_URI="https://github.com/keystone-engine/keystone/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2.0"
SLOT="0"
IUSE="test"


CMAKE_BUILD_TYPE=Release
