section .text
  global main;
  extern printf;

main:
  push rbp;
  mov rbp, rsp;
  sub rsp, 32;
  
  call read_filename;
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
  loop1:
    rdtsc;
    mul rdx;
    mov rdx, rbp;
    add rbx, 8;
    sub rdx, rbx;
    mov [rdx], rax;
    cmp rbx, 32;
  jl loop1;
  
  ret; 

open_filename:
  mov rax, 2;
  lea rdi, [rbp-32];
  mov rsi, 0;
  mov rdx, 1;
  ret;

read_filename:
  mov rax, 0;
  mov rdi, 0;
  lea rsi, [rbp-32];
  mov rdx, 31;
  syscall;
  ret;
