#!/usr/bin/env python

# Student ID: SLAE – 871

shellcode = (
"\x6a\x0b\x58\x31\xd2\x52\x68\x2d"
"\x61\x6c\x68\x89\xe1\x52\x68\x2f"
"\x2f\x6c\x73\x68\x2f\x62\x69\x6e"
"\x89\xe3\x52\x51\x53\x89\xe1\xcd\x80"
)

ROT = 9 
MaxValue = 256 - ROT
encoded = ""
orginal = ""
asm = []
for x in bytearray(shellcode):
     if x < MaxValue:
         orginal += "\\x%02x" % (x)
         encoded += "\\x%02x" % (x + ROT)
         asm.append("0x%02x" % (x + ROT))
     else:
	 orginal += "\\x%02x" % (x)
         encoded += "\\x%02x" % (ROT - 256 + x)
         asm.append("0x%02x" % (ROT - 256 + x))
print "----------------------------"
print "Shellcode:\n%s" % shellcode
print "----------------------------"
print "Orginal Shellcode:\n%s" % orginal
print "----------------------------"
print "Encoded:\n%s" % encoded
print "----------------------------"
print "NASM (call db):\n%s" % ",".join(asm)
