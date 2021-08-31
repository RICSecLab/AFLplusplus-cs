#!/bin/bash

make -C coresight-trace -j$(nproc)
cp coresight-trace/cs-proxy ../afl-cs-proxy
