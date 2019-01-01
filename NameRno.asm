section .data
msg1 db "Enter name",0xa
len1 equ $-msg1
msg2 db "Name is "
len2 equ $-msg2
msg3 db "Enter roll number",0xa
len3 equ $-msg3
msg4 db "Roll number is "
len4 equ $-msg4

section .bss
rollno resb 4
name resb 10

section .text 

global _start
_start:

;write system call message 1
MOV eax,4
MOV ebx,1
MOV ecx,msg1
MOV edx,len1
int 80h

;read system call name
MOV eax,3
MOV ebx,2
MOV ecx,name
MOV edx,10
int 80h

;write system call message 2
MOV eax,4
MOV ebx,1
MOV ecx,msg2
MOV edx,len2
int 80h

;write system call name
MOV eax,4
MOV ebx,1
MOV ecx,name 
MOV edx,10
int 80h

;write system call message 3
MOV eax,4
MOV ebx,1
MOV ecx,msg3
MOV edx,len3
int 80h

;read system call roll no
MOV eax,3
MOV ebx,2
MOV ecx,rollno
MOV edx,4
int 80h

;write system call message 4
MOV eax,4
MOV ebx,1
MOV ecx,msg4
MOV edx,len4
int 80h

;write system call roll no
MOV eax,4
MOV ebx,1
MOV ecx,rollno
MOV edx,4
int 80h

MOV eax,1
MOV ebx,0
int 80h
