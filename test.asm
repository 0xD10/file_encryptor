section .text
  global main;
  extern printf;

main:
  push rbp;
  mov rbp, rsp;
  sub rsp, 1056;
  
  call read_user_file_input;
  call open_user_file_input;
  call generate_pseudorandom_numbers;
  call encrypt_file;

  mov rsp, rbp;                    
  pop rbp;
  call exit_success;

encrypt_file:
  xor rax, rax;
  mov edi, dword [rbp-992];
  lea rsi, [rbp-512];
  mov rdx, 256;
  syscall;

  mov qword [rbp-520], rax;
  mov byte [rbp-512+rax], 0; 

  xor rbx, rbx;
  loop_1:
    mov rax, qword [rbp-1024+rbx]

  jne loop_1;

  ret;

generate_pseudorandom_numbers:
  xor rbx, rbx;
  loop_2:
    rdtsc;
    mul rdx;
    mov qword [rbp-1024+rbx], rax;     
    add rbx, 8;
    cmp rbx, 32;
  jl loop_2;
  ret; 

open_user_file_input:
  mov rax, 2;
  lea rdi, [rbp-1056];
  mov rsi, 0;
  mov rdx, 0;
  syscall;

  test rax, rax;
  js error_exit;
  mov dword [rbp-992], eax;
  ret;

read_user_file_input:
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


;; Variables location in stack
;; [rbp-1056] + 31bytes for filename and 1byte for null-byte
;; [rbp-1024] + 32bytes pseudo-random numbers generated with rdtsc 8bytes each
;; [rbp-992] file_discriptor var
;; [rbp-520] filesize in bytes
;; [rbp-512] file data MAXSIZE=256bytes
;; [rbp-256] encrypted file data output MAXSIZE=256bytes 