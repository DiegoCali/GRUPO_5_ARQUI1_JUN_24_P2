#!/bin/bash
gcc -g -nostartfiles -o $1 $1.s -e _start 
gdb $1 