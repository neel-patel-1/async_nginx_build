#!/bin/bash

export ROOT_DIR=/home/n869p538/patched_async_mode_nginx
source $ROOT_DIR/scripts/async_libsrcs.source

sudo cp -r $BUILD_DIR/QAT_Engine/qat/config/c6xx/multi_thread_optimized/*.conf /etc