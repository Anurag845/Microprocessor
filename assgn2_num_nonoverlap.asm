section .data

msg1 db "Before non-overlapped",10
len1 equ $-msg1

msg2 db "After non-overlapped",10
len2 equ $-msg2

msgcol db " : "
lencol equ $-msgcol

nwline db 10
nwlen equ $-nwline

array dq 1234567812345678h,1236547892589631h,7412583699632587h,8523697412316548h,8521479632145639h

count db 05h

cnt db 05h

section .bss

temp resb 16

section .text

global _start
_start:

mov rax,1
mov rdi,1
mov rsi,msg1
mov rdx,len1
syscall

xor rsi,rsi
xor rdx,rdx

mov rsi,array

l1:
mov rdx,rsi
push rsi
call HtoA

mov rax,1
mov rdi,1
mov rsi,temp
mov rdx,16
syscall

mov rax,1
mov rdi,1
mov rsi,msgcol
mov rdx,lencol
syscall

pop rsi
mov rdx,qword[rsi]
push rsi
call HtoA

mov rax,1
mov rdi,1
mov rsi,temp
mov rdx,16
syscall

mov rax,1
mov rdi,1
mov rsi,nwline
mov rdx,nwlen
syscall

pop rsi
add rsi,08
dec byte[count]
jnz l1

mov rdi,array+100h
mov rsi,array
mov cl,byte[cnt]

l2:
xor rax,rax
mov rax,qword[rsi]
mov [rdi],rax
add rsi,08
add rdi,08
dec cl
jnz l2
;loop l2

mov rax,1
mov rdi,1
mov rsi,msg2
mov rdx,len2
syscall

xor rdx,rdx
xor rsi,rsi

mov rsi,array+100h

l3:
mov rdx,rsi
push rsi
call HtoA

mov rax,1
mov rdi,1
mov rsi,temp
mov rdx,16
syscall

mov rax,1
mov rdi,1
mov rsi,msgcol
mov rdx,lencol
syscall

pop rsi
mov rdx,qword[rsi]
push rsi
call HtoA

mov rax,1
mov rdi,1
mov rsi,temp
mov rdx,16
syscall

mov rax,1
mov rdi,1
mov rsi,nwline
mov rdx,nwlen
syscall

pop rsi
add rsi,08
dec byte[cnt]
jnz l3

exit:
mov rax,60
mov rdi,0
syscall

HtoA:
mov rcx,16
mov rdi,temp

up2:
rol rdx,4
mov al,dl
and al,0Fh
cmp al,09h
jbe a2
add al,7h
a2:
add al,30h
mov [rdi],al
inc rdi
loop up2
ret

