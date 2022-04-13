#!/bin/bash

export ROOT_DIR=/home/n869p538/patched_async_mode_nginx

source ${ROOT_DIR}/scripts/async_libsrcs.source

sudo cp -r $QTLS_DIR/QAT/build/c6xx_dev*.conf /etc
