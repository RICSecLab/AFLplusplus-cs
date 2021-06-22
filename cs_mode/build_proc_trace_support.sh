#!/bin/bash

make -C proc-trace
cp proc-trace/proc-trace ../afl-proc-trace
