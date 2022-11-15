
# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8

DESCRIPTION="Open source Old School RuneScape Launcher"
HOMEPAGE="https://runelite.net/"
if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/runelite/launcher.git"
	inherit git-r3
else
	SRC_URI="https://github.com/runelite/launcher/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}
	virtual/jre
"
BDEPEND="dev-java/maven-bin"

src_compile() {
	M2_HOME="${S}/.m2"
	mvn -X clean compile -Dmaven.repo.local="${S}/.m2" -DskipTests -U || die "Maven failed"
}

src_install() {
	M2_HOME="${S}/.m2"
	mvn -X install -Dmaven.repo.local="${S}/.m2" -DskipTests -U || die "Maven failed"

	echo "java -jar /opt/runelite/RuneLite.jar" | tee -a runelite-launcher.sh

	insinto /opt/runelite
	exeinto /opt/runelite

	doins ./target/RuneLite.jar
	newbin ./runelite-launcher.sh runelite
}

