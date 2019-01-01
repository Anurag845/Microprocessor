%macro RW 3
mov rax,%1
mov rdi,1
mov rsi,%2
mov rdx,%3
syscall
%endmacro

section .data

fname db 'assgn7txt.txt',0

msg db "Enter your choice" ,10
    db "1.Ascending Order" ,10
    db "2.Descending Order",10
    db "3.EXIT",10
len equ $-msg

msg1 db " ",10
len1 equ $-msg1

msg3 db "File opened successfully! :)", 10
len3 equ $-msg3

msg4 db "Error in file opening :(", 10
len4 equ $-msg4

cnt db 00h

section .bss

fd resq 01
buff resb 50
choice resb 02
count resb 03

section .text

global _start
_start:

mov rax,2
mov rdi,fname
mov rsi,2
mov rdx,0777
syscall

mov qword[fd],rax
bt rax, 63
jc u1
RW 1,msg3,len3
jmp u2
u1:
RW 1,msg4,len4
u2:
mov rax,0
mov rdi,[fd]
mov rsi,buff
mov rdx,50
syscall

mov qword[count],rax
RW 1,msg,len
RW 0,choice,02

cmp byte[choice],31H
je case1

cmp byte[choice],32H
je case2

cmp byte[choice],33H
je exit

jmp exit

case1:
mov byte[cnt],06h
up10:
l:
mov rsi,buff
mov rdi,buff+2
mov bl,05h
up2:
mov al,byte[rsi]
cmp al,byte[rdi]
jb up

mov dl,byte[rdi]
mov byte[rdi],al
mov byte[rsi],dl

up:
add rsi,02
add rdi,02

dec bl
jnz up2

up1:
dec byte[cnt]
jnz up10

mov rax,1
mov rdi,[fd]
mov rsi,buff
mov rdx,qword[count]                    
syscall

case2:
xor rbx,rbx
mov byte[cnt],06h
u10:

mov rsi,buff
mov rdi,buff+2
mov bl,05h
u4:
mov al,byte[rsi]
cmp al,byte[rdi]
ja u

mov dl,byte[rdi]
mov byte[rdi],al
mov byte[rsi],dl

u:
add rsi,02
add rdi,02

dec bl
jnz u4

dec byte[cnt]
jnz u10

mov rax,1
mov rdi,[fd]
mov rsi,buff
mov rdx,qword[count]                    
syscall

exit:
mov rax,60
mov rdi,0
syscall
