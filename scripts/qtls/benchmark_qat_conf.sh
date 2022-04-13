#!/bin/bash

export ROOT_DIR=/home/n869p538/patched_async_mode_nginx
source $ROOT_DIR/scripts/async_libsrcs.source

sudo cp -r $ROOT_DIR/qat_dev_confs/* /etc
