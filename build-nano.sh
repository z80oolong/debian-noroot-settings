#!/bin/bash

## Shell script for building Nano Text Editor.
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

## Version of Nano.
NANO_VERSION="3.2"

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

## Dependencies for building Nano.
NANO_DEP="pkg-config libncursesw5-dev libgettextpo-dev libmagic-dev build-essential xstow"

## URL and source code file of Nano.
NANO_URL="https://nano-editor.org/dist/v3/nano-${NANO_VERSION}.tar.gz"
NANO_SRC="nano-${NANO_VERSION}.tar.gz"

## Directories for building and installing Nano.
BUILD_DIR="/tmp/nano-build-`${DATE} +'%Y%m%d%H%M%S'`"
USR_LOCAL_DIR="/usr/local"
USR_LOCAL_OPT_DIR="${USR_LOCAL_DIR}/opt"
INSTALL_DIR="${USR_LOCAL_OPT_DIR}/nano-${NANO_VERSION}"

## Functions

function install_dependencies() {
    (${SUDO} ${APT_GET} install -y ${NANO_DEP}) || (echo "==> Error: Install Dependencies to build Nano!"; exit 1)
}

function fetch_nano() {
    ${MKDIR} -p ${BUILD_DIR}
    (cd ${BUILD_DIR} && ${WGET} -O ${NANO_SRC} ${NANO_URL}) || (echo "==> Error: Fetch Nano source code!"; exit 1)
}

function extruct_nano() {
    (cd ${BUILD_DIR} && ${TAR} -zxvf ${NANO_SRC}) || (echo "==> Error: Extruct Nano source code!"; exit 1)
}

function build_install_nano() {
    (cd ${BUILD_DIR}/nano-${NANO_VERSION} && \
     ${ENV} PKG_CONFIG="${PKG_CONFIG}" ./configure --disable-debug --disable-dependency-tracking \
                                                   --prefix=${INSTALL_DIR} --sysconfdir=${INSTALL_DIR}/etc \
                                                   --localedir=${INSTALL_DIR}/share/locale \
                                                   --enable-color --enable-extra --enable-multibuffer \
                                                   --enable-nanorc --enable-nls --enable-utf8 && \
     make && make install) || (echo "==> Error: Build Nano!"; exit 1)
}

function link_xstow_nano() {
    (cd ${USR_LOCAL_OPT_DIR} && ${XSTOW} -v ./nano-${NANO_VERSION}) || (echo "==> Error: Link Nano to /usr/local!"; exit 1)
}

## Main

install_dependencies && \
fetch_nano && \
extruct_nano && \
build_install_nano && \
link_xstow_nano

exit 0

## End of Shell script.
