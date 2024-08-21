#!/bin/bash
nasm -f elf64 test.asm
gcc -o test test.o -no-pie
rm test.o
