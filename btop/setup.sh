#!/usr/bin/env bash
set -e -u -o pipefail

BUILD_SCRIPT_DIR=$(dirname $(readlink -f $BASH_SOURCE))
CACHE_DIR="${HOME}/Downloads"

PACKAGE_PREFIX_DIR="${HOME}/.local"

#####################################################################################################
###  CHECKS
#####################################################################################################

SETUP_VERSION="1.4.5"

# https://github.com/aristocratos/btop/archive/refs/tags/v1.4.5.tar.gz
BTOP_FOLDER=btop-${SETUP_VERSION}
BTOP_ARCHIVE=${BTOP_FOLDER}.tar.gz
BTOP_URL=https://github.com/aristocratos/btop/archive/refs/tags/v${SETUP_VERSION}.tar.gz
BTOP_CACHE=${CACHE_DIR}/${BTOP_ARCHIVE}

SOURCE_DIR="${BUILD_SCRIPT_DIR}/${BTOP_FOLDER}"
BUILD_DIR="${BUILD_SCRIPT_DIR}/${BTOP_FOLDER}_build"


#####
## Download & extract
#####
mkdir -p "${CACHE_DIR}"
[ ! -f "${BTOP_CACHE}" ] && echo "## -- Download to ${BTOP_CACHE}" && curl -L -o "${BTOP_CACHE}" "${BTOP_URL}"
[ ! -d "${BUILD_SCRIPT_DIR}/${BTOP_FOLDER}" ] &&  tar xf "${BTOP_CACHE}" -C "${BUILD_SCRIPT_DIR}"

#####################################################################################################
###  Build & Install
#####################################################################################################

if [ ! -f ${PACKAGE_PREFIX_DIR}/bin/btop ]; then
    rm -rf "${BUILD_DIR}"
    mkdir -p "${BUILD_DIR}"
    cd "${BUILD_DIR}"
    
    # need gcc 14 too build latest btop
    source /opt/rh/gcc-toolset-14/enable
    
    export CFLAGS="-O2 -march=native -mtune=native -Wno-implicit-function-declaration"
    export CXXFLAGS="-O2 -march=native -mtune=native"
    
    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -Wno-dev \
        -DCMAKE_INSTALL_PREFIX="${PACKAGE_PREFIX_DIR}" \
        -DBTOP_GPU=true \
        -DCMAKE_C_FLAGS="${CFLAGS}" \
        -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
        "${SOURCE_DIR}"

    make -j 20 V=1 VERBOSE=1
    make install
else 
    echo ">> Skip btop"
fi

echo "Install btop Done"
exit 0
