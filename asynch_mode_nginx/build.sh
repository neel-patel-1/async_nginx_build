#!/bin/bash
source libsrcs.source
[ ! -d "$QAT_BUILD" ] && mkdir $QAT_BUILD

./autogen.sh
#env LDFLAGS="-L/home/n869p538/intel-ipsec-mb/lib -L/home/n869p538/crypto_mb/2020u3/lib" \
#CPPFLAGS="-I/home/n869p538/intel-ipsec-mb/lib/include -I/home/n869p538/crypto_mb/2020u3/include" \
./configure --enable-qat_sw \
--enable-qat_hw \
--with-openssl_install_dir=$ROOT_DIR/openssl \
--with-openssl_dir=$ROOT_DIR/openssl \
--prefix=$QAT_BUILD \
--exec-prefix=$QAT_BUILD

PERL5LIB=$ROOT_DIR/openssl make -j35 -C .
#env PERL5LIB=$ROOT_DIR/openssl make -j35 -C .
#sudo env PERL5LIB=$ROOT_DIR/openssl make install -j
sudo PERL5LIB=$ROOT_DIR/openssl make install -j
