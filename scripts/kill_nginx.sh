#!/bin/bash
export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

ps aux | grep -e 'nginx:' | awk '{print $2}' | xargs sudo kill -s 2
