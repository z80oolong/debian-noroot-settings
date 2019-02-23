#!/bin/bash

## Shell script for building Plank Dock Launcher.
## Written by Z.OOL. <zool@zool.jpn.org>

##----
## MIT License
##
## Copyright (c) 2019 NAKATSUKA, Yukitaka (mailto:zool@zool.jpn.org)
##
## Permission is hereby granted, free of charge, to any person obtaining a copy
## of this software and associated documentation files (the "Software"), to deal
## in the Software without restriction, including without limitation the rights
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
## copies of the Software, and to permit persons to whom the Software is
## furnished to do so, subject to the following conditions:
##
## The above copyright notice and this permission notice shall be included in all
## copies or substantial portions of the Software.
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
## SOFTWARE.
##----

## Version of Plank.
PLANK_VERSION="0.11.4"

## Path of commands.
WHICH="/usr/bin/which"
DATE=`${WHICH} date`
SUDO=`${WHICH} sudo`
APT_GET=`${WHICH} apt-get`
MKDIR=`${WHICH} mkdir`
WGET=`${WHICH} wget`
TAR=`${WHICH} tar`
ENV=`${WHICH} env`
PKG_CONFIG="/usr/bin/pkg-config"
XSTOW="/usr/bin/xstow"

## Dependencies for building Plank.
PLANK_DEP="automake gnome-common intltool pkg-config valac libbamf3-dev libdbusmenu-gtk3-dev libgdk-pixbuf2.0-dev libgee-dev libglib2.0-dev libgtk-3-dev libwnck-3-dev libx11-dev libgee-0.8-dev build-essential xstow"

## URL and source code file of Plank.
PLANK_URL="https://launchpad.net/plank/1.0/${PLANK_VERSION}/+download/plank-${PLANK_VERSION}.tar.xz"
PLANK_SRC="plank-${PLANK_VERSION}.tar.xz"

## Directories for building and installing Plank.
BUILD_DIR="/tmp/plank-build-`${DATE} +'%Y%m%d%H%M%S'`"
USR_LOCAL_DIR="/usr/local"
USR_LOCAL_OPT_DIR="${USR_LOCAL_DIR}/opt"
INSTALL_DIR="${USR_LOCAL_OPT_DIR}/plank-${PLANK_VERSION}"

## Functions

function install_dependencies() {
    (${SUDO} ${APT_GET} install -y ${PLANK_DEP}) || (echo "==> Error: Install Dependencies to build Plank!"; exit 1)
}

function fetch_plank() {
    ${MKDIR} -p ${BUILD_DIR}
    (cd ${BUILD_DIR} && ${WGET} -O ${PLANK_SRC} ${PLANK_URL}) || (echo "==> Error: Fetch Plank source code!"; exit 1)
}

function extruct_plank() {
    (cd ${BUILD_DIR} && ${TAR} -Jxvf ${PLANK_SRC}) || (echo "==> Error: Extruct Plank source code!"; exit 1)
}

function build_install_plank() {
    (cd ${BUILD_DIR}/plank-${PLANK_VERSION} && \
     ${ENV} PKG_CONFIG="${PKG_CONFIG}" ./configure --prefix=${INSTALL_DIR} --disable-silent-rules && \
     make && make install) || (echo "==> Error: Build Plank!"; exit 1)
}

function link_xstow_plank() {
    (cd ${USR_LOCAL_OPT_DIR} && ${XSTOW} -v ./plank-${PLANK_VERSION}) || (echo "==> Error: Link Plank to /usr/local!"; exit 1)
}

## Main

install_dependencies && \
fetch_plank && \
extruct_plank && \
build_install_plank && \
link_xstow_plank

exit 0

## End of Shell script.
