%macro write 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .data

array dq 1236547896542317h,7418529632587415h,1236547899632587h,7412583698521236h,7896541239632584h

msg1 db "Before overlap",10
len1 equ $-msg1

msg2 db "After overlap",10
len2 equ $-msg2

cnt1 db 05h

cnt2 db 05h

cnt3 db 05h

cnt4 db 07h

msgcol db " : "
lencol equ $-msgcol

nwline db 10
nwlen equ $-nwline

section .bss

temp resb 16

section .text

global _start
_start:

write msg1,len1

xor rsi,rsi
xor rdx,rdx

mov rsi,array

l1:
mov rdx,rsi
push rsi
call HtoA

write temp,16

write msgcol,lencol

pop rsi
mov rdx,qword[rsi]
push rsi
call HtoA

write temp,16

write nwline,nwlen

pop rsi
add rsi,8
dec byte[cnt1]
jnz l1

xor rax,rax
xor rdi,rdi
xor rsi,rsi
xor rdx,rdx

mov rsi,array
mov rdi,array+100h

l2:
xor rax,rax
mov rax,qword[rsi]
mov [rdi],rax
add rsi,8
add rdi,8
dec byte[cnt2]
jnz l2

xor rax,rax
xor rdi,rdi
xor rsi,rsi
xor rdx,rdx

mov rsi,array+100h
mov rdi,array+10h

l3:
xor rax,rax
mov rax,qword[rsi]
mov [rdi],rax
add rsi,8
add rdi,8
dec byte[cnt3]
jnz l3

write msg2,len2

xor rax,rax
xor rdi,rdi
xor rsi,rsi
xor rdx,rdx

mov rsi,array

l4:
mov rdx,rsi
push rsi
call HtoA

write temp,16

write msgcol,lencol

pop rsi
mov rdx,qword[rsi]
push rsi
call HtoA

write temp,16

write nwline,nwlen

pop rsi
add rsi,8
dec byte[cnt4]
jnz l4

exit:
mov rax,60
mov rdi,0
syscall

HtoA:
mov rdi,temp
mov rcx,16

up2:
rol rdx,4
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
