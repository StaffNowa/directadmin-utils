#!/bin/bash
OPENSSL_VER="1.1.1";
INSTALL_DIR="/usr";

WORKDIR="/usr/local/src"
USERNAME="root"

CWD=${WORKDIR}

URL="https://www.openssl.org/source/old/${OPENSSL_VER}/openssl-${OPENSSL_VER}.tar.gz"
LOCAL_NAME="openssl-${OPENSSL_VER}-latest.tar.gz"
OUTPUT_DIR="${CWD}/openssl-${OPENSSL_VER}-latest.tar.gz"

wget ${URL} -O ${CWD}/${LOCAL_NAME}
tar -zxvf ${OUTPUT_DIR} -C ${WORKDIR};

cd ${WORKDIR};
DIR=`ls -1d openssl-${VER}*/ | tail -1`;
cd ${DIR};

./config --prefix=${INSTALL_DIR} no-ssl2 no-ssl3 zlib-dynamic -fPIC shared;
make depend && make install;

c=`grep "${INSTALL_DIR}/lib" /etc/ld.so.conf -c`;
if [ "${c}" == "0" ]; then
     echo "${INSTALL_DIR}/lib" >> /etc/ld.so.conf;
fi;
ldconfig

c=`grep "${INSTALL_DIR}/lib" /${USERNAME}/.bashrc -c`
if [ "${c}" == "0" ]; then
    echo "export LD_LIBRARY_PATH=${INSTALL_DIR}/lib" >> /${USERNAME}/.bashrc
fi

exit 0;

