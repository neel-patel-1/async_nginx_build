#!/bin/bash

export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

sudo cp -r $ROOT_DIR/new_qat_dev_confs/* /etc
