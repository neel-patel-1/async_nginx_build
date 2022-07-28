#!/bin/bash

export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

sudo cp -r $QTLS_DIR/QAT_Engine/qat/config/c6xx/multi_thread_optimized/*.conf /etc
