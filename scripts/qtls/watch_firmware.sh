#!/bin/bash

watch sudo cat /sys/kernel/debug/qat_c6xx_0000:b$((5 + ${1})):00.0/fw_counters
