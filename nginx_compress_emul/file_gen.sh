#!/bin/bash
f_sz=( "4K" "16K" "32K" "1M" )
for i in "${f_sz[@]}"; do
	for j in `seq 0 100`; do
		[ ! -f "nginx_default_build/html/rand_file_${i}_${j}.txt" ] && head -c ${i} < /dev/urandom | sudo tee nginx_default_build/html/rand_file_${i}_${j}.txt >/dev/null
		[ ! -f "nginx_default_build/html/zero_file_${i}_${j}.txt" ] && head -c ${i} < /dev/zero | sudo tee nginx_default_build/html/zero_file_${i}_${j}.txt >/dev/null
	done
done
for i in "${f_sz[@]}"; do
	for j in `seq 0 100`; do
		[ ! -f "nginx_gzip_build/html/rand_file_${i}_${j}.txt" ] &&  head -c ${i} < /dev/urandom | sudo tee nginx_gzip_build/html/rand_file_${i}_${j}.txt >/dev/null
		[ ! -f "nginx_gzip_build/html/zero_file_${i}_${j}.txt" ] && head -c ${i} < /dev/zero | sudo tee nginx_gzip_build/html/zero_file_${i}_${j}.txt >/dev/null
	done
done

[ ! -d "calgary_dir" ] && mkdir calgary_dir
[ ! -f "largecalgarycorpus.zip" ] &&  wget http://www.data-compression.info/files/corpora/largecalgarycorpus.zip
unzip largecalgarycorpus.zip -d calgary_dir
for i in calgary_dir/*; do
	[ ! -f "nginx_gzip_build/html/$(basename $i)" ] && cp $i nginx_gzip_build/html/$(basename $i)
	[ ! -f "nginx_default_build/html/$(basename $i)" ] && cp $i nginx_default_build/html/$(basename $i)
done
