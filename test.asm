section .text
  global main;
  extern printf;

main:
  push rbp;
  mov rbp, rsp;
  sub rsp, 1056;
  
  call read_input_file;
  call open_file;
  call generate_random_numbers;
  call encrypt_file;

  mov rsp, rbp;                    
  pop rbp;
  call exit_success;

encrypt_file:
  xor rax, rax;
  mov rsi, rbp;
  mov rdx, 1024;
  syscall;
  mov byte [rbp+rax], 0;

  mov rax, 1;
  mov rdi, 1;
  mov rsi, rbp;
  syscall;
  ret;

generate_random_numbers:
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

open_file:
  mov rax, 2;
  lea rdi, [rbp-1056];
  mov rsi, 0;
  mov rdx, 0;
  syscall;
  test rax, rax;
  js error_exit;
  mov rdi, rax;
  ret;

read_input_file:
  mov rax, 0;
  mov rdi, 0;
  lea rsi, [rbp-1056];
  mov rdx, 32;
  syscall;
  dec rax;
  mov byte [rbp-1056+rax], 0;
  ret;

exit_success:
  mov rax, 60;
  xor rdi, rdi;
  syscall;

error_exit:
  mov rax, 60;   
  mov rdi, 1;   
  syscall;