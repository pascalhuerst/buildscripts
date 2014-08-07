#!/bin/bash

XENOMAI_VER=2.6
XENOMAI_VER_FINAL=2.6.3
XENOMAI_REPO="git://xenomai.org/xenomai-${XENOMAI_VER}.git"

LINUX_REPO="git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
LINUX_VER="3.8.13"

MAINTAINTER_EMAIL="pascal.huerst@gmail.com"
MAINTAINER_NAME="Pascal Huerst"

WORKING_DIR=$(readlink -f `pwd`)
PACKAGES_DIR="${WORKING_DIR}/packages"
XENOMAI_DIR="${WORKING_DIR}/xenomai"
LINUX_DIR="${WORKING_DIR}/linux"

#echo "WORKING_DIR=$WORKING_DIR  PACKAGES_DIR=$PACKAGES_DIR  XENOMAI_DIR=$XENOMAI_DIR"


#sudo apt-get install devscripts debhelper dh-kpatches findutils git-core git-buildpackage kernel-package libncurses-dev fakeroot zlib1g-dev autoconf automake
#
mkdir -p "${PACKAGES_DIR}"

if [ ! -d "${XENOMAI_DIR}" ]; then
	git clone "${XENOMAI_REPO}" "${XENOMAI_DIR}"
fi


######################
# XENOMAI
######################
#cd ${XENOMAI_DIR}
#XENOMAI_BRANCH_NAME="v${XENOMAI_VER_FINAL}-deb"
#BRANCH_EXISTS=$(git branch -a | grep ${XENOMAI_BRANCH_NAME})
#if [ -n "${BRANCH_EXISTS}" ]; then
#	git checkout master
#	git branch -D "v${XENOMAI_VER_FINAL}-deb"
#fi
#git checkout -b "v${XENOMAI_VER_FINAL}-deb" "v${XENOMAI_VER_FINAL}"
#DEBEMAIL=\"${MAINTAINTER_EMAIL}\" DEBFULLNAME=\"${MAINTAINER_NAME}\" debchange -v ${XENOMAI_VER_FINAL} Release ${XENOMAI_VER_FINAL}
#git commit -a --author="\"${MAINTAINER_NAME} <${MAINTAINTER_EMAIL}>\"" -m ${XENOMAI_VER_FINAL}
#git-buildpackage --git-ignore-new --git-debian-branch="v${XENOMAI_VER_FINAL}-deb" --git-export-dir="${PACKAGES_DIR}" -uc -us

#####################
# LINUX
#####################
if [ ! -d "${LINUX_DIR}" ]; then
	git clone "${LINUX_REPO}" linux
	cd "${LINUX_DIR}"
	git config user.email ${MAINTAINTER_EMAIL}
	git config user.name ${MAINTAINER_NAME}
else
	cd "${LINUX_DIR}"
fi

LINUX_BRANCH_NAME=linux-${LINUX_VER}-xenomai-${XENOMAI_VER_FINAL}
BRANCH_EXISTS=$(git branch -a | grep ${LINUX_BRANCH_NAME})
if [ -n "${BRANCH_EXISTS}" ]; then
	git checkout master
	git branch -D ${LINUX_BRANCH_NAME}
fi

git checkout -b "${LINUX_BRANCH_NAME}" "v${LINUX_VER}"
${XENOMAI_DIR}/scripts/prepare-kernel.sh --arch=x86 --adeos=${XENOMAI_DIR}/ksrc/arch/x86/patches/ipipe-core-${LINUX_VER}-x86-4.patch --linux=${LINUX_DIR}
git add -A
git commit -m "Xenomai-${XENOMAI_VER_FINAL} Patches Applied"

LINUX_CONFIG=${WORKING_DIR}/configs/linux-${LINUX_VER}-xenomai-${XENOMAI_VER_FINAL}
if [ ! -f ${LINUX_CONFIG} ]; then
	printf "[Error] Config not found: %s" "${LINUX_CONFIG}"
	exit 1;
fi

cp ${LINUX_CONFIG} ${LINUX_DIR}/.config
make -C ${LINUX_DIR} oldconfig
CONCURRENCY_LEVEL=8 CLEAN_SOURCE=no fakeroot make-kpkg --initrd --append-to-version -xenomai-${XENOMAI_VER_FINAL} --revision 1.0 kernel_image kernel_headers
mv "${WORKING_DIR}/*.deb" "${PACKAGES_DIR}"

