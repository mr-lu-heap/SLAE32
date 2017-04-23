; This is my shellcode, you can find it: https://www.exploit-db.com/exploits/41403/
; shellcode was edited for SLAE EggHunter purpose
: see blog for details

 ; Student ID: SLAE – 871


global _start
section .text
_start:
;    xor eax, eax
	push 0xb	; 0xb (execve) syscall-ID
        pop eax

	xor edx, edx
	push edx

	push 0x686c612d
;	push byte 0x30
	mov ecx, esp

	push edx

;	push 0x6563726f
;	push 0x666e6574
;	push 0x65732f6e
;	push 0x6962732f
;	push 0x7273752f
	
	push 0x736c2f2f
	push 0x6e69622f

	mov ebx, esp
	push edx
	push ecx
	push ebx
	mov ecx, esp

	int 0x80
