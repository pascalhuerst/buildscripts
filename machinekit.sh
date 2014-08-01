#!/bin/bash

MACHINEKIT_REPO="https://github.com/mhaberler/machinekit.git"
MACHINEKIT_DIR="machinekit"

WORKING_DIR=$(readlink -f `pwd`)

CZMQ_REPO="https://github.com/zeromq/czmq.git"
CZMQ_DIR="${WORKING_DIR}/czmq"

PROTOBUF_REPO="http://protobuf.googlecode.com/svn/tags/2.5.0/"
PROTOBUF_DIR="${WORKING_DIR}/protobuf"

#####################
# MACHINEKIT
#####################
if [ ! -d "${MACHINEKIT_DIR}" ]; then
	git clone "${MACHINEKIT_REPO}" "${MACHINEKIT_DIR}"
fi

## Dependencies
#####################
# CZMQ
#####################
CZMQ_PC_FILE=$(find /usr/local/lib -name "libczmq.pc")
if [ -z "${CZMQ_PC_FILE}" ]; then
	if [ ! -d "${CZMQ_DIR}" ]; then 
		git clone "${CZMQ_REPO}" "${CZMQ_DIR}" 
	fi
	if [ ! -f "${CZMQ_DIR}/configure" ]; then 
		/bin/bash "${CZMQ_DIR}/autogen.sh"
	fi

	/bin/bash "${CZMQ_DIR}"/configure
	make -C "${CZMQ_DIR}"
	sudo make -C "${CZMQ_DIR}" install
fi

#####################
# PROTOBUF
#####################
PROTOBUF_PC_FILE=$(find /usr/local/lib -name "protobuf.pc")
if [ -z "${PROTOBUF_PC_FILE}" ]; then
	cd "${WORKING_DIR}"
	if [ ! -d "${PROTOBUF_DIR}" ]; then 
		svn co "${PROTOBUF_REPO}" "${PROTOBUF_DIR}" 
	fi
	cd "${PROTOBUF_DIR}"
	if [ ! -f "${PROTOBUF_DIR}/configure" ]; then 
		/bin/bash autogen.sh
	fi
	/bin/sh configure && \
	make && \
	sudo make install
#	# PYTHON
#	cd "${PROTOBUF_DIR}/python"
#	/usr/bin/python setup.py build && \
#	/usr/bin/python setup.py test && \
#	sudo /usr/bin/python setup.py install
#	cd "${WORKING_DIR}"
fi















exit 1;


## 





cd ${MACHINEKIT_DIR}/src

if [ ! -f "${MACHINEKIT_DIR}/src/configure" ]; then
	/bin/bash autogen.sh
fi

/bin/bash configure


#XENOMAI_VER=2.6
#XENOMAI_VER_FINAL=2.6.3
#XENOMAI_REPO="git://xenomai.org/xenomai-${XENOMAI_VER}.git"
#
#LINUX_REPO="git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
#LINUX_VER="3.8.13"
#
#MAINTAINTER_EMAIL="pascal.huerst@gmail.com"
#MAINTAINER_NAME="Pascal Huerst"
#
#WORKING_DIR=$(readlink -f `pwd`)
#PACKAGES_DIR="${WORKING_DIR}/packages"
#XENOMAI_DIR="${WORKING_DIR}/xenomai"
#LINUX_DIR="${WORKING_DIR}/linux"
#
##echo "WORKING_DIR=$WORKING_DIR  PACKAGES_DIR=$PACKAGES_DIR  XENOMAI_DIR=$XENOMAI_DIR"
#
#
##sudo apt-get install devscripts debhelper dh-kpatches findutils git-core git-buildpackage kernel-package libncurses-dev fakeroot zlib1g-dev autoconf automake
##
#mkdir -p "${PACKAGES_DIR}"
#
#if [ ! -d "${XENOMAI_DIR}" ]; then
#	git clone "${XENOMAI_REPO}" "${XENOMAI_DIR}"
#fi
#
#
#######################
## XENOMAI
#######################
##cd ${XENOMAI_DIR}
##XENOMAI_BRANCH_NAME="v${XENOMAI_VER_FINAL}-deb"
##BRANCH_EXISTS=$(git branch -a | grep ${XENOMAI_BRANCH_NAME})
##if [ -n "${BRANCH_EXISTS}" ]; then
##	git checkout master
##	git branch -D "v${XENOMAI_VER_FINAL}-deb"
##fi
##git checkout -b "v${XENOMAI_VER_FINAL}-deb" "v${XENOMAI_VER_FINAL}"
##DEBEMAIL=\"${MAINTAINTER_EMAIL}\" DEBFULLNAME=\"${MAINTAINER_NAME}\" debchange -v ${XENOMAI_VER_FINAL} Release ${XENOMAI_VER_FINAL}
##git commit -a --author="\"${MAINTAINER_NAME} <${MAINTAINTER_EMAIL}>\"" -m ${XENOMAI_VER_FINAL}
##git-buildpackage --git-ignore-new --git-debian-branch="v${XENOMAI_VER_FINAL}-deb" --git-export-dir="${PACKAGES_DIR}" -uc -us
#
######################
## LINUX
######################
#if [ ! -d "${LINUX_DIR}" ]; then
#	git clone "${LINUX_REPO}" linux
#	cd "${LINUX_DIR}"
#	git config user.email ${MAINTAINTER_EMAIL}
#	git config user.name ${MAINTAINER_NAME}
#else
#	cd "${LINUX_DIR}"
#fi
#
#LINUX_BRANCH_NAME=linux-${LINUX_VER}-xenomai-${XENOMAI_VER_FINAL}
#BRANCH_EXISTS=$(git branch -a | grep ${LINUX_BRANCH_NAME})
#if [ -n "${BRANCH_EXISTS}" ]; then
#	git checkout master
#	git branch -D ${LINUX_BRANCH_NAME}
#fi
#
#git checkout -b "${LINUX_BRANCH_NAME}" "v${LINUX_VER}"
#${XENOMAI_DIR}/scripts/prepare-kernel.sh --arch=x86 --adeos=${XENOMAI_DIR}/ksrc/arch/x86/patches/ipipe-core-${LINUX_VER}-x86-4.patch --linux=${LINUX_DIR}
#git add -A
#git commit -m "Xenomai-${XENOMAI_VER_FINAL} Patches Applied"
#cp ${WORKING_DIR}/configs/my_config ${LINUX_DIR}/.config
#make -C ${LINUX_DIR} oldconfig
#CONCURRENCY_LEVEL=8 CLEAN_SOURCE=no fakeroot make-kpkg --initrd --append-to-version -xenomai-${XENOMAI_VER_FINAL} --revision 1.0 kernel_image kernel_headers








