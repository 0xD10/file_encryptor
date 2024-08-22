section .bss
  buffer: resb 1024;
section .text
  global main;
  extern printf;

main:
  push rbp;
  mov rbp, rsp;
  sub rsp, 32;
  
  call read_input_filename;
  call sanitize_input_filename;
  call open_filename;
  call generate_randnumb;

  ;; DEALLOCATE
  mov rsp, rbp;                    
  pop rbp;
  ;; EXIT_SUCCESS
  mov rax, 60;   
  xor rdi, rdi;   
  syscall;


generate_randnumb:
  xor rbx, rbx;
  loop_start:
    rdtsc;
    mul rdx;
    mov rdx, rbp;
    add rbx, 8;
    sub rdx, rbx;
    mov [rdx], rax;
    cmp rbx, 32;
  jl loop_start;
  ret; 

open_filename:
  mov rax, 2;
  mov rdi, rbp;
  mov rsi, 0;
  mov rdx, 0;
  syscall;
  test rax, rax;
  js exit_NOT_SUCCESS;

  mov rdi, rax;
  mov rax, 0;
  mov rsi, buffer;
  mov rdx, 1024;
  syscall;

  test rax, rax;
  js exit_NOT_SUCCESS;

  mov rdi, 1;
  mov rax, 1;
  mov rsi, buffer;
  syscall;
  ret;

sanitize_input_filename:
  xor rbx, rbx;
  loop:
    mov rdx, rbp;
    add rdx, rbx;
    add rbx, 1;
    mov al, byte [rdx];
    cmp al, 0x0a;
  jne loop;
  dec rbx;
  mov byte [rbp+rbx], 0x00;
  ret;

read_input_filename:
  mov rax, 0;
  mov rdi, 0;
  mov rsi, rbp;
  mov rdx, 32;
  syscall;
  ret;

exit_NOT_SUCCESS:
  mov rax, 60;   
  mov rdi, 1;   
  syscall;