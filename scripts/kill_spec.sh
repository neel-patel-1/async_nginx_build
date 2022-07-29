#!/bin/bash
export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

ps aux | grep -e 'runcpu' -e 'run_base'  | awk '{print $2}' | xargs sudo kill -s 2
rm -Rf $SPEC_DIR/benchspec/C*/*/run
rm -Rf $SPEC_DIR/benchspec/C*/*/build
rm -Rf $SPEC_DIR/benchspec/C*/*/exe 
