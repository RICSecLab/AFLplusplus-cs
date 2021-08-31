#!/bin/bash

make -C proc-trace -j$(nproc)
cp proc-trace/cs-proxy ../afl-proc-trace
