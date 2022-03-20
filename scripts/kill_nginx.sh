#!/bin/bash

ps aux | grep nginx | awk '{print $2}' | xargs sudo kill -s 2
