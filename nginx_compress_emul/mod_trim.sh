#!/bin/bash

len=$1

sed -i -E "s/trim_length [0-9]+;/trim_length ${len};/g" nginx_default.conf
