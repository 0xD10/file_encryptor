section .data
  filename db "newfile.enc", 0;

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
  call write_new_output_file;

  mov rsp, rbp;                    
  pop rbp;
  call exit_success;

write_new_output_file:
  mov rax, 2;
  lea rdi, [filename];
  mov rsi, 64 | 2;
  mov rdx, 0o664;
  syscall;

  mov dword [rbp-984], eax;

  mov rax, 1;
  lea rsi, [rbp-512];
  mov rdx, [rbp-520];
  mov rdi, [rbp-984];
  syscall;

  mov rax, 3;
  mov edi, dword [rbp-984];
  syscall;

  mov rax, 3;
  mov edi, dword [rbp-992];
  syscall;

  ret;

encrypt_file:
  xor rax, rax;
  mov edi, dword [rbp-992];
  lea rsi, [rbp-512];
  mov rdx, 512;
  syscall;

  mov qword [rbp-520], rax;
  mov byte [rbp-512+rax], 0; 

  xor r8, r8;
  xor r9, r9;
  loop_1:
    mov al, byte [rbp-1024+r8];
    mov bl, byte [rbp-512+r9];
    cmp bl, 0;
    je return_main;

    xor al, bl;
    mov byte [rbp-512+r9], al;
    inc r8;
    inc r9;
    cmp r8, 32;
    je make_zero;
  
  jne loop_1;
  return_main:
    ret;
  make_zero:
    xor r8,r8;


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
;; [rbp-992] input_file_discriptor
;; [rbp-984] output_file_discriptor
;; [rbp-520] filesize in bytes
;; [rbp-512] file data MAXSIZE=512bytes