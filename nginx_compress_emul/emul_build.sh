#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source ../scripts/async_libsrcs.source
sudo rm -rf nginx_gzip_build
cd nginx-gzip_offload
./configure --prefix=$(pwd)/../nginx_gzip_build \
	--with-ld-opt="-L ${DEFAULT_DIR}/openssl" \
	--with-http_ssl_module \
	--with-http_slice_module \
	--with-openssl=${DEFAULT_DIR}/openssl-3.0.0 \
	--with-cc-opt='-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' \
	--with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie'
make -j 30
make -j 30 install 
cd ../
cp nginx_default.conf nginx_gzip_build/conf/nginx.conf
cp -r localhost.* nginx_gzip_build/conf/
ps aux | grep nginx | awk '{print $2}' | xargs sudo kill -s 2
sudo ./nginx_gzip_build/sbin/nginx
f_sz=( "4K" "16K" "32K" )
for i in "${f_sz[@]}"; do
	head -c ${i} < /dev/urandom | sudo tee nginx_gzip_build/html/rand_file_${i}.txt >/dev/null
	head -c ${i} < /dev/zero | sudo tee nginx_gzip_build/html/zero_file_${i}.txt >/dev/null
done
