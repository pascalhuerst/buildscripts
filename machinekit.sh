#!/bin/bash

WORKING_DIR=$(readlink -f `pwd`)

## Dependencies
#####################
# CZMQ
#####################
CZMQ_REPO="https://github.com/zeromq/czmq.git"
CZMQ_DIR="${WORKING_DIR}/czmq"
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
PROTOBUF_REPO="http://protobuf.googlecode.com/svn/tags/2.5.0/"
PROTOBUF_DIR="${WORKING_DIR}/protobuf"
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
	make -j 8 && \
	sudo make install
	# PYTHON
	cd "${PROTOBUF_DIR}/python"
	/usr/bin/python setup.py build && \
	/usr/bin/python setup.py test && \
	sudo /usr/bin/python setup.py install
	cd "${WORKING_DIR}"
fi

#####################
# JANSSON
#####################
JANSSON_REPO="https://github.com/akheron/jansson.git"
JANSSON_DIR="${WORKING_DIR}/jansson"
JANSSON_PC_FILE=$(find /usr/local/lib -name "jansson.pc")
if [ -z "${JANSSON_PC_FILE}" ]; then
	cd "${WORKING_DIR}"
	if [ ! -d "${JANSSON_DIR}" ]; then 
		git clone "${JANSSON_REPO}" "${JANSSON_DIR}" 
	fi
	cd "${JANSSON_DIR}"
	if [ ! -f "${JANSSON_DIR}/configure" ]; then 
		libtoolize --force
		aclocal
		automake --force-missing --add-missing
		autoreconf -s
	fi
	/bin/sh configure && \
	make -j 8 && \
	sudo make install
fi

#####################
# LIBWEBSOCKETS
#####################
LIBWEBSOCKETS_REPO="git://git.libwebsockets.org/libwebsockets"
LIBWEBSOCKETS_DIR="${WORKING_DIR}/libwebsockets"
LIBWEBSOCKETS_PC_FILE=$(find /usr/local/lib -name "libwebsockets.pc")
if [ -z "${LIBWEBSOCKETS_PC_FILE}" ]; then
	cd "${WORKING_DIR}"
	if [ ! -d "${LIBWEBSOCKETS_DIR}" ]; then 
		git clone "${LIBWEBSOCKETS_REPO}" "${LIBWEBSOCKETS_DIR}" 
	fi
	cd "${LIBWEBSOCKETS_DIR}"
	if [ ! -d "${LIBWEBSOCKETS_DIR}/build" ]; then 
		mkdir -p "${LIBWEBSOCKETS_DIR}/build"
		cd "${LIBWEBSOCKETS_DIR}/build"
		cmake .. &&
		make &&
		sudo make install
	fi
fi


#####################
# MACHINEKIT
#####################
MACHINEKIT_REPO="https://github.com/mhaberler/machinekit.git"
MACHINEKIT_DIR="${WORKING_DIR}/machinekit"
if [ ! -d "${MACHINEKIT_DIR}" ]; then
	git clone "${MACHINEKIT_REPO}" "${MACHINEKIT_DIR}"
fi


cd ${MACHINEKIT_DIR}/src

if [ ! -f "${MACHINEKIT_DIR}/src/configure" ]; then
	/bin/bash autogen.sh
fi

/bin/bash configure
make -j8



echo "#############################################################"
echo "#######################    DONE     #########################"
echo "#############################################################"

