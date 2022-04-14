#!/bin/bash
export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

[ ! -d "$AXDIMM_DIR" ] && mkdir -p $AXDIMM_DIR

#openssl
cd ${AXDIMM_DIR}
wget https://www.openssl.org/source/openssl-1.1.1k.tar.gz
tar xf openssl-1.1.1k.tar.gz
cd openssl-1.1.1k
./config --prefix=${AXDIMM_DIR}/openssl/1.1.1k --openssldir=${AXDIMM_DIR}/openssl/1.1.1k
make -j
sudo make install -j
export PATH=${AXDIMM_DIR}/openssl/1.1.1k/bin:$PATH
export LD_LIBRARY_PATH=${AXDIMM_DIR}/openssl/1.1.1k/lib
cd ${AXDIMM_DIR}
openssl version -v -e > build_log.txt

#ipp-crypto
git clone https://github.com/intel/ipp-crypto.git
cd ipp-crypto
git checkout ippcp_2020u3
export OPENSSL_ROOT_DIR=${AXDIMM_DIR}/openssl/1.1.1k
cd sources/ippcp/crypto_mb
cmake . -Bbuild -DCMAKE_INSTALL_PREFIX=${AXDIMM_DIR}/crypto_mb/2020u3
cd build
make -j
sudo make install
export LD_LIBRARY_PATH=${AXDIMM_DIR}/openssl/1.1.1k/lib:${AXDIMM_DIR}/crypto_mb/2020u3/lib
cd ${AXDIMM_DIR}

#ipsec mb
git clone https://github.com/intel/intel-ipsec-mb.git
cd intel-ipsec-mb
git checkout v0.55
make -j SAFE_DATA=y SAFE_PARAM=y SAFE_LOOKUP=y
sudo make install NOLDCONFIG=y PREFIX=${AXDIMM_DIR}/ipsec-mb/0.55
export LD_LIBRARY_PATH=${AXDIMM_DIR}/openssl/1.1.1k/lib:${AXDIMM_DIR}/crypto_mb/2020u3/lib:${AXDIMM_DIR}/ipsec-mb/0.55/lib
cd ${AXDIMM_DIR}

# qatengine
git clone https://github.com/intel/QAT_Engine.git
cd QAT_Engine
git checkout v0.6.5
./autogen.sh
LDFLAGS="-L${AXDIMM_DIR}/ipsec-mb/0.55/lib -L${AXDIMM_DIR}/crypto_mb/2020u3/lib" CPPFLAGS="-I${AXDIMM_DIR}/ipsec-mb/0.55/include -I${AXDIMM_DIR}/crypto_mb/2020u3/include" ./configure --prefix=${AXDIMM_DIR}/openssl/1.1.1k --with-openssl_install_dir=${AXDIMM_DIR}/openssl/1.1.1k --with-openssl_dir=${AXDIMM_DIR}/openssl-1.1.1k --enable-qat_sw
PERL5LIB=${AXDIMM_DIR}/openssl-1.1.1k make -j
sudo PERL5LIB=${AXDIMM_DIR}/openssl-1.1.1k make install
cd ${AXDIMM_DIR}

sudo chmod -R o+rw ${AXDIMM_DIR}/QAT_Engine ${AXDIMM_DIR}/ipsec-mb ${AXDIMM_DIR}/crypto_mb

[ ! -f "${AXDIMM_DIR}/openssl/1.1.1k/lib/engines-1.1/qatengine.so" ] && echo "QATENGINE BUILD FAILED" && exit

#nginx server
wget http://nginx.org/download/nginx-1.20.1.tar.gz
tar -xvzf nginx-1.20.1.tar.gz
cd nginx-1.20.1
./configure --with-stream_ssl_module --with-ld-opt="-L ${AXDIMM_DIR}/openssl-1.1.1k" --with-http_ssl_module --with-openssl=${AXDIMM_DIR}/openssl-1.1.1k --prefix=${AXDIMM_DIR}/offload_nginx
make -j
sudo make install -j 35
cp -r ${ROOT_DIR}/default_nginx_conf/* ${AXDIMM_DIR}/offload_nginx/conf
${AXDIMM_SCRIPTS}/gen_http_files.sh
[ ! -f "${AXDIMM_NGINX}/html/file_256K.txt" ] && ${AXDIMM_SCRIPTS}/gen_http_files.sh
[ ! -f "${AXDIMM_DIR}/offload_nginx/sbin/nginx" ] && echo "NGINX BUILD FAILED" && exit

exit
