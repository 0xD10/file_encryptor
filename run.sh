#!/bin/bash
nasm -f elf64 main_program.asm
gcc -o main_program main_program.o -no-pie
rm main_program.o
