#!/bin/bash

ps aux | grep -e 'nginx :' | awk '{print $2}' | xargs sudo kill -s 2
