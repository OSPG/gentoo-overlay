# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ELECTRON_MIN_VER=42
ELECTRON_MAX_VER=42
ELECTRON_NATIVE_MODULES=1

inherit desktop edo electron wrapper xdg

DESCRIPTION="Encrypted, local-first workspace and knowledge manager"
HOMEPAGE="https://anytype.io/ https://github.com/anyproto/anytype-ts"

# To create the dependency archive from an unpacked source tree:
# bun install --frozen-lockfile --ignore-scripts
# mkdir -p "../${P}-vendor"
# mv node_modules "../${P}-vendor/"
# ( cd .. && tar -cJf "${P}-vendor.tar.xz" "${P}-vendor" )
MIDDLEWARE_VERSION="0.51.0-rc1"
SRC_URI="
	https://github.com/anyproto/anytype-ts/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
	amd64? (
		https://github.com/anyproto/anytype-heart/releases/download/v${MIDDLEWARE_VERSION}/js_v${MIDDLEWARE_VERSION}_linux-amd64.tar.gz
			-> ${P}-middleware.tar.gz
	)
	https://gentoo.kropotkin.rocks/distfiles/${P}-vendor.tar.xz
"
S="${WORKDIR}/anytype-ts-${PV}"

LICENSE="ASAL-1.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

RDEPEND="
	${ELECTRON_DEPEND}
	app-crypt/libsecret
	dev-libs/glib:2
"
BDEPEND="
	${RDEPEND}
	dev-lang/go
	dev-libs/protobuf
	net-libs/nodejs
	virtual/pkgconfig
"

QA_PREBUILT="usr/*/anytype/app.asar.unpacked/dist/anytypeHelper"

src_unpack() {
	unpack "${P}.tar.gz"

	mkdir "${WORKDIR}/${P}-middleware" || die
	pushd "${WORKDIR}/${P}-middleware" > /dev/null || die
	unpack "${P}-middleware.tar.gz"
	popd > /dev/null || die

	unpack "${P}-vendor.tar.xz"
	mv "${WORKDIR}/${P}-vendor/node_modules" "${S}" || die
}

src_prepare() {
	electron_src_prepare
	edo ./node_modules/.bin/patch-package
	generate_electron-builder_bailout_config
}

src_compile() {
	local electron_headers middleware="${WORKDIR}/${P}-middleware"

	rm -rf dist/lib/{pb,pkg,protos} dist/lib/json/generated || die
	cp -r "${middleware}/protobuf/." dist/lib/ || die
	mkdir -p dist/lib/json/generated || die
	cp "${middleware}"/json/*.json dist/lib/json/generated/ || die
	cp "${middleware}/grpc-server" dist/anytypeHelper || die

	edo bash scripts/generate-protos.sh --from-dist
	# The upstream module name, "nativeMessagingHost", collides with the main
	# package under newer Go toolchains; this program only imports the stdlib.
	edo env CGO_ENABLED=0 GO111MODULE=off go build -o dist/nativeMessagingHost \
		./go/nativeMessagingHost.go

	edo node scripts/build-electron.js
	edo env NODE_OPTIONS="--max-old-space-size=8192" \
		./node_modules/.bin/vite build --config vite.config.ts
	find dist -type f -name "*.map" -delete || die

	# keytar is the only native Node module and the vendor archive deliberately
	# does not contain a downloaded prebuild. Bun's node_modules layout cannot
	# be processed by `npm rebuild`, so call the vendored node-gyp directly.
	case ${ELECTRON_TYPE} in
		source)
			electron_headers="${EPREFIX}/usr/include/electron/${ELECTRON_SLOT}/node/include/node"
			;;
		binary)
			electron_headers="${ELECTRON_DIR}include/node"
			;;
		*)
			die "Unsupported Electron type: ${ELECTRON_TYPE}"
			;;
	esac
	# Remove staging left by an interrupted/older build.  In particular, an
	# earlier symlink here makes node-gyp resolve --nodedir back into Electron's
	# native include tree and look for common.gypi at the wrong level.
	rm -rf "${T}/electron-node-headers" || die
	mkdir -p "${T}/electron-node-headers/include" || die
	cp -r "${electron_headers}" "${T}/electron-node-headers/include/node" || die
	cp "${electron_headers}"/{common,config}.gypi \
		"${T}/electron-node-headers/" || die
	# electron.eclass exports npm_config_nodedir for npm rebuild.  node-gyp gives
	# that variable precedence over its --nodedir option, so override it here.
	edo env npm_config_nodedir="${T}/electron-node-headers" \
		node node_modules/node-gyp/bin/node-gyp.js rebuild \
		--directory=node_modules/keytar \
		--target="${ELECTRON_VERSION}" \
		--runtime=electron \
		--nodedir="${T}/electron-node-headers" \
		--build-from-source

	# electron-builder 26 does not apply Bun's root-level dependency overrides
	# while traversing node_modules. All runtime modules are already enumerated
	# in upstream's build.files, so disable the redundant dependency collector.
	edo node -e '
		const fs = require("fs");
		const pkg = require("./package.json");
		pkg.dependencies = {};
		fs.writeFileSync("package.json", JSON.stringify(pkg, null, "\t") + "\n");
	'

	edo env ELECTRON_SKIP_SENTRY=1 \
		./node_modules/.bin/electron-builder \
		--config "${ELECTRON_BUILDER_CONFIG}" \
		--linux dir --x64 --publish=never \
		-c.npmRebuild=false \
		-c.electronDist="${ELECTRON_DIR}" \
		-c.electronVersion="${ELECTRON_VERSION}"
}

src_install() {
	local appdir="/usr/$(get_libdir)/${PN}" size

	insinto "${appdir}"
	doins dist/linux-unpacked/resources/app.asar
	doins -r dist/linux-unpacked/resources/app.asar.unpacked
	fperms +x \
		"${appdir}/app.asar.unpacked/dist/anytypeHelper" \
		"${appdir}/app.asar.unpacked/dist/nativeMessagingHost"

	make_wrapper anytype \
		"env ELECTRON_IS_DEV=0 ${ELECTRON} ${appdir}/app.asar"

	for size in 16 32 64 128 256 512 1024; do
		newicon -s "${size}" "electron/img/icons/${size}x${size}.png" anytype.png
	done

	domenu anytype.desktop anytype-xwayland.desktop
	einstalldocs
}
