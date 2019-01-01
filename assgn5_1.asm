%macro write 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .data

msg1 db "Number of spaces is "
len1 equ $-msg1

msg2 db "Number of new lines is "
len2 equ $-msg2

msg3 db "Occurrences of specified character are "
len3 equ $-msg3

errmsg db "Error opening file",10
errlen equ $-errmsg

nwline db 10
nwlen equ $-nwline

filename db 'a.txt',0

section .bss

global c1,c2,c3,buffer
extern spacecnt,newlinecnt,charcnt
c1 resq 01
c2 resq 01
c3 resq 01
fd resq 01
flength resq 01
buffer resq 01

section .text

extern spaces,newlines,occurrences

global _start
_start:

;system call for opening file
mov rax,2
mov rdi,filename
mov rsi,2
mov rdx,0777
syscall

mov qword[fd],rax
bt qword[fd],63
jc error

;reading contents of file into buffer
mov rax,0
mov rdi,[fd]
mov rsi,buffer
mov rdx,100
syscall

mov qword[flength],rax

mov qword[c1],rax
mov qword[c2],rax
mov qword[c3],rax

call spaces

write msg1,len1
write spacecnt,01
write nwline,nwlen

call newlines

write msg2,len2
write newlinecnt,01
write nwline,nwlen

call occurrences

write msg3,len3
write charcnt,01
write nwline,nwlen

jmp exit

error:	write errmsg,errlen

exit:	mov rax,60
		mov rdi,0
		syscall


