; Student ID: SLAE – 871

global _start           

section .text

_start:
    jmp short call_decoder

decoder:
; esi => edi
    pop edi                     ; shellcode address
    xor ecx, ecx                ; zero out ecx
; cl
    mov cl, len                 ; initialize counter

decode:
    cmp byte [edi], 0x9         ; can we substract 13?
; jnle
    jnle wrap_around            ; nope, we need to wrap around
    sub byte [edi], 0x9         ; substract 9
    jmp short process_shellcode ; process the rest of the shellcode

wrap_around:
    xor edx, edx                ; zero out edx
; dl
    mov dl, 0x9                ; edx = 9
; dl
    sub dl, byte [edi]         ; 9 - shellcode byte value
    xor ebx,ebx                 ; zero out ebx
; bl
    mov bl, 0xff                ; store 0x100 without introducing null bytes
    inc ebx
 sub bx, dx
;    sub ebx, edx                  ; 256 - (13 - shellcode byte value)
; bl
    mov byte [edi], bl          ; write decoded value

process_shellcode:
    inc edi                     ; move to the next byte
    loop decode                 ; decode current byte
    jmp short encoded         ; execute decoded shellcode

call_decoder:
    call decoder
    encoded: 
        db 0x73,0x14,0x61,0x3a,0xdb,0x5b,0x71,0x36,0x6a
	db 0x75,0x71,0x92,0xea,0x5b,0x71,0x38,0x38,0x75
	db 0x7c,0x71,0x38,0x6b,0x72,0x77,0x92,0xec,0x5b
	db 0x5a,0x5c,0x92,0xea,0xd6,0x89
    len: equ $-encoded
