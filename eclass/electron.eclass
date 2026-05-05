# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: electron.eclass
# @MAINTAINER:
# Chromium in Gentoo Project <chromium@gentoo.org>
# @AUTHOR:
# Matt Jolly <kangie@gentoo.org>
# @BLURB: Electron application packaging utilities
# @DESCRIPTION:
# This eclass provides helper functions for packages that build against Electron.
# It handles automatic Electron version detection, native module rebuilding,
# and provides utilities for electron-builder integration. Supports both
# source and binary Electron installations.
# @SUPPORTED_EAPIS: 8
# @PROVIDES: pkg_setup src_prepare
# @EXAMPLE:
# inherit electron
#
# ELECTRON_MIN_VER="36"
# ELECTRON_MAX_VER="37"
#
# src_compile() {
#     electron_detect_native_modules
#     npm run build
# }

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_ELECTRON_ECLASS} ]]; then
_ELECTRON_ECLASS=1

# @ECLASS_VARIABLE: _ELECTRON_SLOTS
# @INTERNAL
# @DESCRIPTION:
# Array of Eclass-accepted Electron slots, newest first.
declare -a -g -r _ELECTRON_SLOTS=(
	37
	36
)

# Strictly speaking we should be using the electron ABI to slot, but the major version
# is far easier for humans to understand and use.
# Having reviewed the ABI version registry, it doesn't seem that the Node Module ABI has
# ever been unstable within a single electron major version.
# https://github.com/nodejs/node/blob/main/doc/abi_version_registry.json

# == user control knobs ==

# @ECLASS_VARIABLE: ELECTRON_SLOT_OVERRIDE
# @USER_VARIABLE
# @DESCRIPTION:
# Specify the version (slot) of Electron to be used by the package. This is
# useful for troubleshooting and debugging purposes. If unset, the newest
# acceptable Electron version will be used. May be combined with ELECTRON_TYPE_OVERRIDE.
# This variable must not be set in ebuilds.

# @ECLASS_VARIABLE: ELECTRON_TYPE_OVERRIDE
# @USER_VARIABLE
# @DESCRIPTION:
# Specify the type of Electron to be used by the package from options:
# 'source' or 'binary' (-bin). This is useful for troubleshooting and
# debugging purposes. If unset, the standard eclass logic will be used
# to determine the type of Electron to use (i.e. prefer source if binary
# is also available). May be combined with ELECTRON_SLOT_OVERRIDE.
# This variable must not be set in ebuilds.

# == control variables ==

# @ECLASS_VARIABLE: ELECTRON_MAX_VER
# @DEFAULT_UNSET
# @DESCRIPTION:
# Highest Electron slot supported by the package. Needs to be set before
# electron_pkg_setup is called. If unset, no upper bound is assumed.

# @ECLASS_VARIABLE: ELECTRON_MIN_VER
# @DEFAULT_UNSET
# @DESCRIPTION:
# Lowest Electron slot supported by the package. Needs to be set before
# electron_pkg_setup is called. If unset, no lower bound is assumed.

# @ECLASS_VARIABLE: ELECTRON_SLOT
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# The selected Electron slot for building, from the range defined by
# ELECTRON_MAX_VER and ELECTRON_MIN_VER. This is set by electron_pkg_setup.

# @ECLASS_VARIABLE: ELECTRON_TYPE
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# The selected Electron type for building, either 'source' or 'binary'.
# This is set by electron_pkg_setup.

# @ECLASS_VARIABLE: ELECTRON_DEPEND
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# This is an eclass-generated Electron dependency string, filtered by
# ELECTRON_MAX_VER and ELECTRON_MIN_VER.

# @ECLASS_VARIABLE: ELECTRON_OPTIONAL
# @DEFAULT_UNSET
# @DESCRIPTION:
# If set to a non-empty value, the Electron dependency will not be added
# to BDEPEND. This is useful for packages that need to gate electron behind
# certain USE themselves.

# @ECLASS_VARIABLE: ELECTRON_NATIVE_MODULES
# @DEFAULT_UNSET
# @DESCRIPTION:
# If set to a non-empty value eclass-generated dependencies will include slot rebuild operators.

# @ECLASS_VARIABLE: ELECTRON_REQ_USE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Additional USE-dependencies to be added to the Electron dependency.

# @FUNCTION: _electron_set_globals
# @INTERNAL
# @DESCRIPTION:
# Set up Electron dependency string based on version constraints.
_electron_set_globals() {
	local usedep="${ELECTRON_REQ_USE+[${ELECTRON_REQ_USE}]}"
	local slot_operator='*'
	local electron_dep=()

	if [[ -n ${ELECTRON_NATIVE_MODULES} ]]; then
		slot_operator="="
	fi

	electron_dep=( "|| (" )

	# If we don't have a max version, we can be more flexible
	if [[ -z "${ELECTRON_MAX_VER}" ]]; then
		electron_dep+=(
			">=dev-util/electron-bin-${ELECTRON_MIN_VER:-30}:${slot_operator}${usedep}"
			">=dev-util/electron-${ELECTRON_MIN_VER:-30}:${slot_operator}${usedep}"
		)
	else
		# Depend on each slot between ELECTRON_MIN_VER and ELECTRON_MAX_VER
		local slot
		for slot in "${_ELECTRON_SLOTS[@]}"; do
			if [[ -n ${ELECTRON_MIN_VER} && ${slot} -lt ${ELECTRON_MIN_VER} ]]; then
				continue
			fi
			if [[ -n ${ELECTRON_MAX_VER} && ${slot} -gt ${ELECTRON_MAX_VER} ]]; then
				continue
			fi
			electron_dep+=(
				"dev-util/electron-bin:${slot}${usedep}"
				"dev-util/electron:${slot}${usedep}"
			)
		done
	fi
	electron_dep+=( ")" )
	ELECTRON_DEPEND="${electron_dep[*]}"

	readonly ELECTRON_DEPEND
	if [[ -z ${ELECTRON_OPTIONAL} ]]; then
		BDEPEND="${ELECTRON_DEPEND}"
		RDEPEND="${ELECTRON_DEPEND}"
	fi
}
_electron_set_globals
unset -f _electron_set_globals

# @FUNCTION: electron_detect_build_system
# @DESCRIPTION:
# Detect the build system used by the package. This is useful for packages
# that need to integrate with Electron's build process.
electron_detect_build_system() {
	if [[ -z ${_ELECTRON_PKG_SETUP} ]]; then
		die "electron_pkg_setup must be called before ${FUNCNAME}"
	fi

	if [[ -f "pnpm-lock.yaml" ]]; then
		echo "pnpm"
	elif [[ -f "yarn.lock" ]]; then
		echo "yarn"
	elif [[ -f "package-lock.json" ]]; then
		echo "npm"
	elif [[ -f "package.json" ]]; then
		echo "npm"
	else
		die "No package.json, pnpm-lock.yaml, yarn.lock, or package-lock.json found in ${S}"
	fi
}

# @FUNCTION: electron_build_native_modules
# @DESCRIPTION:
# Rebuild Node native modules against the Electron version specified by ELECTRON_SLOT.
# This function should be called in src_compile if native modules.
electron_build_native_modules() {
	if [[ -z ${_ELECTRON_PKG_SETUP} ]]; then
		die "electron_pkg_setup must be called before ${FUNCNAME}"
	fi
	local node_include_dir
	case ${ELECTRON_TYPE} in
		source)
			node_include_dir="${EPREFIX}/usr/include/electron/${ELECTRON_SLOT}/include/node"
			;;
		binary)
			node_include_dir="${EPREFIX}/opt/electron/${ELECTRON_SLOT}/include/node"
			;;
		*)
			die "Invalid ELECTRON_TYPE: ${ELECTRON_TYPE}"
			;;
	esac
	# Use Electron's ability to masquerade as nodejs to build native modules against itself.
	# https://www.electronjs.org/docs/latest/tutorial/using-native-node-modules#manually-building-for-a-custom-build-of-electron
	npm rebuild --verbose --foreground-scripts --nodedir="${node_include_dir}" ||
		die "Failed to rebuild native modules with npm (default) against Electron ${ELECTRON_SLOT} (${ELECTRON_TYPE})"

}

# @FUNCTION: electron_check_native_modules
# @DESCRIPTION:
# Check that native modules are properly linked and can be loaded by Electron.
# This function should be called in src_test.
electron_check_native_modules() {

	# Based on the macros that the SUSE electron package installs:
	# https://build.opensuse.org/projects/openSUSE:Factory/packages/nodejs-electron/files/nodejs-electron.spec

	if [[ -z ${_ELECTRON_PKG_SETUP} ]]; then
		die "electron_pkg_setup must be called before ${FUNCNAME}"
	fi

	# 1. Detect underlinking (missing dependencies)
	# 2. Detect accidental linking to libuv which must not be used (Electron exports its own incompatible version)
	# 3. Actually load each module

	einfo "Checking native modules for proper linking and compatibility..."

	# Check for undefined symbols (except NAPI and libuv which are expected)
	find "${ED}" -type f -name '*.node' -print0 | \
		xargs -0 -I{} sh -c 'ldd -d -r "{}" 2>&1 | grep "^undefined symbol" | grep -v "napi_" | grep -v "uv_" && exit 1 || true' || \
		die "Found undefined symbols in native modules"

	# Check that native modules don't link against system libuv (Electron provides its own)
	find "${ED}" -type f -name '*.node' -print0 | \
		xargs -0 -I{} sh -c 'objdump -p "{}" | grep -F libuv.so && exit 1 || true' || \
		die "Native modules incorrectly linked against system libuv"

	# Test that each module can actually be loaded by Electron
	find "${ED}" -type f -name '*.node' -print0 | \
		xargs -0 -I{} env ELECTRON_RUN_AS_NODE=1 "${ELECTRON}" -e 'require("{}")' || \
		die "Native modules failed to load in Electron"
}

# @FUNCTION: electron_detect_native_modules
# @DESCRIPTION:
# Detect native modules in node_modules and rebuild them against the Electron version specified by ELECTRON_SLOT.
# This function should be called in src_compile. It is only useful for packages that have native modules in their sources
# which have not been pre-stripped from (e.g.) a vendor tarball.
electron_detect_native_modules() {
	if [[ -z ${_ELECTRON_PKG_SETUP} ]]; then
		die "electron_pkg_setup must be called before ${FUNCNAME}"
	fi
	if [[ ! -d node_modules ]]; then
		einfo "No node_modules directory found, skipping native module detection."
		return 0
	fi
	# Detect native modules in the current directory and rebuild them against Electron.
	# This is useful for packages that have native modules in their source tree.
	local modules
	modules=$(find node_modules -type f -name "*.node" 2>/dev/null | grep -v "obj\.target")
	if [[ -z ${modules} ]]; then
		einfo "No native modules found in node_modules."
		return 0
	fi

	electron_build_native_modules || die "Failed to detect native modules"
}

# @FUNCTION: _get_electron_slot
# @INTERNAL
# @DESCRIPTION:
# Find the newest Electron install that is acceptable for the package,
# and export its version (i.e. SLOT) and type (source or bin[ary])
# as ELECTRON_SLOT and ELECTRON_TYPE. Prefers source Electron if both
# source and binary are available, unless ELECTRON_TYPE_OVERRIDE is set.
_get_electron_slot() {
	# Validate version constraints early
	if [[ -n ${ELECTRON_MIN_VER} && -n ${ELECTRON_MAX_VER} && ${ELECTRON_MIN_VER} -gt ${ELECTRON_MAX_VER} ]]; then
		die "ELECTRON_MIN_VER (${ELECTRON_MIN_VER}) cannot be greater than ELECTRON_MAX_VER (${ELECTRON_MAX_VER})"
	fi

	local usedep="${ELECTRON_REQ_USE+[${ELECTRON_REQ_USE}]}"
	local slot

	# Check each slot in order (newest first) until we find a suitable one
	for slot in "${_ELECTRON_SLOTS[@]}"; do
		if [[ -n "${ELECTRON_SLOT_OVERRIDE}" ]]; then
			[[ "${slot}" == "${ELECTRON_SLOT_OVERRIDE}" ]] || continue
		else
			# If we're explicitly overriding the slot we can skip the version checks
			if [[ -n ${ELECTRON_MIN_VER} && ${slot} -lt ${ELECTRON_MIN_VER} ]]; then
				continue
			fi
			if [[ -n ${ELECTRON_MAX_VER} && ${slot} -gt ${ELECTRON_MAX_VER} ]]; then
				continue
			fi
		fi

		case "${ELECTRON_TYPE_OVERRIDE}" in
			source)
				if has_version "dev-util/electron:${slot}${usedep}"; then
					ELECTRON_SLOT="${slot}"
					ELECTRON_TYPE="source"
					return 0
				fi
				;;
			binary)
				if has_version "dev-util/electron-bin:${slot}${usedep}"; then
					ELECTRON_SLOT="${slot}"
					ELECTRON_TYPE="binary"
					return 0
				fi
				;;
			*)
				if has_version "dev-util/electron:${slot}${usedep}"; then
					ELECTRON_SLOT="${slot}"
					ELECTRON_TYPE="source"
					return 0
				elif has_version "dev-util/electron-bin:${slot}${usedep}"; then
					ELECTRON_SLOT="${slot}"
					ELECTRON_TYPE="binary"
					return 0
				fi
				;;
		esac
	done

	# If we reach here, no suitable Electron was found
	local constraints=()

	[[ -n ${ELECTRON_MIN_VER} ]] && constraints+=( ">= ${ELECTRON_MIN_VER}" )
	[[ -n ${ELECTRON_MAX_VER} ]] && constraints+=( "<= ${ELECTRON_MAX_VER}" )
	[[ -n ${ELECTRON_REQ_USE} ]] && constraints+=( "use=${ELECTRON_REQ_USE}" )
	[[ -n ${ELECTRON_SLOT_OVERRIDE} ]] && constraints+=( "slot=${ELECTRON_SLOT_OVERRIDE}" )
	[[ -n ${ELECTRON_TYPE_OVERRIDE} ]] && constraints+=( "type=${ELECTRON_TYPE_OVERRIDE}" )

	local constraint_msg=""
	if [[ ${#constraints[@]} -gt 0 ]]; then
		constraint_msg=" matching: $(IFS=', '; echo "${constraints[*]}")"
	fi

	die "No suitable Electron found${constraint_msg}"
}

# @FUNCTION: get_electron_path
# @USAGE: slot electron_type
# @DESCRIPTION:
# Given arguments of slot and electron_type, return an appropriate path
# for the Electron install. The electron_type should be either "source"
# or "binary". If the electron_type is not one of these, the function
# will die.
get_electron_path() {
	local slot="${1}"
	local electron_type="${2}"

	if [[ ${#} -ne 2 ]]; then
		die "${FUNCNAME}: invalid number of arguments"
	fi

	case ${electron_type} in
		source) echo "/usr/$(get_libdir)/electron/${slot}/";;
		binary) echo "/opt/electron/${slot}/";;
		*) die "${FUNCNAME}: invalid electron_type=${electron_type}";;
	esac
}

# @FUNCTION: get_electron_prefix
# @DESCRIPTION:
# Find the newest Electron install that is acceptable for the package,
# and print an absolute path to it. If both -bin and regular Electron
# are installed, the regular Electron is preferred.
get_electron_prefix() {
	_get_electron_slot
	get_electron_path "${ELECTRON_SLOT}" "${ELECTRON_TYPE}"
}

# @FUNCTION: generate_electron-builder_bailout_config
# @USAGE: generate_electron-builder_bailout_config
# @DESCRIPTION:
# Create a custom electron-builder configuration that will bail out after building the asar file.
# This avoids the need to run the full electron-builder packaging process where we would throw away
# the output anyway. Exports ELECTRON_BUILDER_CONFIG to point to the generated config file.
generate_electron-builder_bailout_config() {
	if [[ -z ${_ELECTRON_PKG_SETUP} ]]; then
		die "electron_pkg_setup must be called before ${FUNCNAME}"
	fi

	local file="${S}/electron-builder-gentoo-config.js"

	cat <<-EOF > "${file}"
// Load the original configuration from the project's package.json
const originalConfig = require('./package.json').build;

// Define the new configuration by merging the original our hook
const newConfig = {
...originalConfig, // Spread the original config first
afterPack: (context) => {
	console.log('✅ afterAsar hook triggered from external process.');
	console.log('app.asar created at: ${S}/dist/linux-unpacked/resources/app.asar');

	console.log('Build process will now terminate as requested.');
	process.exit(0); // Success code
},
};

// Export the new configuration
module.exports = newConfig;
EOF
	einfo "Created ${file} to bail out after building asar"
	export ELECTRON_BUILDER_CONFIG="${file}"
	return 0

}

# @FUNCTION: electron_create_wrapper_scripts
# @DESCRIPTION:
# Create wrapper scripts for using Electron as nodejs for various build systems
# like npm, npx, and yarn. This allows these tools to run in the context of Electron.
# Wrapper scripts are prefixed to PATH.
electron_create_wrapper_scripts() {
	local electron_node="${EPREFIX}${ELECTRON_DIR}node"
	local binaries=( npm npx pnpm yarn )
	local binary

	mkdir -p "${T}/bin" || die "Failed to create wrapper scripts directory"

	# In Gentoo we install the build scripts system-wide to /usr/bin to be invoked by system nodejs.
	for binary in "${binaries[@]}"; do
		cat <<-EOF > "${T}/bin/${binary}"
		#!/bin/sh
		exec ${electron_node} ${EPREFIX}/usr/bin/${binary} "\$@"
		EOF
	done

	chmod -v 0755 "${T}"/bin/* > /dev/null || die "Failed to set permissions on wrapper scripts"

	export PATH="${T}/bin:${PATH}"
}

# @FUNCTION: electron_pkg_setup
# @DESCRIPTION:
# Find and set up the appropriate Electron installation for the package.
# Sets ELECTRON_SLOT and ELECTRON_TYPE variables and exports ELECTRON.
#
# The highest acceptable Electron slot can be set in the ELECTRON_MAX_VER variable.
# If it is unset or empty, any slot is acceptable.
#
# The lowest acceptable Electron slot can be set in the ELECTRON_MIN_VER variable.
# If it is unset or empty, any slot is acceptable.
#
# The function is a no-op when installing a binary package.
electron_pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		_get_electron_slot
		local path=$(get_electron_path "${ELECTRON_SLOT}" "${ELECTRON_TYPE}")
		export ELECTRON="${EPREFIX}${path}electron"
		export ELECTRON_DIR="${EPREFIX}${path}"
		local electron_version
		# no-sandbox is required for electron to run as root
		electron_version=$(${ELECTRON} --no-sandbox --version | sed 's/^v//' || die "failed to get Electron version")
		export ELECTRON_VERSION="${electron_version}"
		# Probably not required, but let's make sure no part of the build process tries to download Electron binaries
		export ELECTRON_SKIP_BINARY_DOWNLOAD=1
		einfo "Using Electron ${ELECTRON_VERSION} (${ELECTRON_TYPE})"

		# There are a bunch of environment variables that we now need to set so that electron-builder, npm, & friends
		# can find the Electron installation and build against it (etc).
		# Force use of the system `app-builder` binary
		export USE_SYSTEM_APP_BUILDER=true
		export ELECTRON_OVERRIDE_DIST_PATH="${ELECTRON_DIR}"

		# Use portage temp directory for electron cache; defaults are not suitable for portage
		local cache_base="${T}/electron-cache"
		mkdir -p "${cache_base}/electron" "${cache_base}/electron-builder" "${cache_base}/npm" || die
		export ELECTRON_CACHE="${cache_base}/electron"
		export ELECTRON_BUILDER_CACHE="${cache_base}/electron-builder"

		# Yes, these are canonically lowercase envvars. Thanks npm!
		if [[ "${ELECTRON_TYPE}" == "source" ]]; then
			# For source builds, node headers are installed to /usr/include/electron/${SLOT}/node/
			export npm_config_nodedir="${EPREFIX}/usr/include/electron/${ELECTRON_SLOT}/node"
		else
			# For binary builds, headers are in the electron directory
			export npm_config_nodedir="${ELECTRON_DIR}include"
		fi
		# Additional npm config for native modules
		export npm_config_target="${ELECTRON_VERSION}"
		export npm_config_disturl="https://electronjs.org/headers"
		export npm_config_runtime="electron"
		export npm_config_build_from_source=true
		export npm_config_cache="${cache_base}/npm"
		electron_create_wrapper_scripts
	fi
	export _ELECTRON_PKG_SETUP=1
}

# @FUNCTION: electron_src_prepare
# @DESCRIPTION:
# Prepare the package for building against Electron. This function should be called in src_prepare.
electron_src_prepare() {

	default_src_prepare

	if [[ -z ${_ELECTRON_PKG_SETUP} ]]; then
		die "electron_pkg_setup must be called before ${FUNCNAME}"
	fi

	# We vendor our node_modules anyway, so we can patch the electron version to match the one we are building against.
	sed -i "s/\"electron\": \".*\"/\"electron\": \"${ELECTRON_VERSION}\"/" package.json || die
	einfo "Patched electron version in package.json"
}

fi

EXPORT_FUNCTIONS pkg_setup src_prepare
