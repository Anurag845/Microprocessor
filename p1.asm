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

msg3 db "Number of occurrences is "
len3 equ $-msg3

errmsg db "Error opening file"
errlen equ $-errmsg

nwline db 10
nwlen equ $-nwline

filename db 'a.txt',0

section .bss

global c1,c2,c3,buffer
extern spacecnt,newlinecnt,charcnt

fd resq 1
flength resq 1
c1 resq 1
c2 resq 1
c3 resq 1
temp resb 1
buffer resb 100

section .text

extern spaces,newlines,occurrences

global _start
_start:

mov rax,2
mov rdi,filename
mov rsi,2
mov rdx,0777
syscall

mov qword[fd],rax
bt qword[fd],63
jc error

mov rax,0
mov rdi,qword[fd]
mov rsi,buffer
mov rdx,100
syscall

mov qword[flength],rax

mov qword[c1],rax
mov qword[c2],rax
mov qword[c3],rax

write msg1,len1

call spaces

mov dl,byte[spacecnt]
call HtoA
write temp,2
write nwline,nwlen

write msg2,len2

call newlines

mov dl,byte[newlinecnt]
call HtoA
write temp,2
write nwline,nwlen

call occurrences
write msg3,len3
mov dl,byte[charcnt]
call HtoA
write temp,2
write nwline,nwlen

jmp exit

error:	write errmsg,errlen

exit:
mov rax,60
mov rdi,0
syscall

HtoA:
mov rdi,temp
mov rcx,2
up2:
rol dl,4
mov al,dl
and al,0Fh
cmp al,09h
jbe a2
add al,07h
a2:
add al,30h
mov [rdi],al
inc rdi
loop up2
ret
