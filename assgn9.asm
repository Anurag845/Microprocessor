%macro write 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .data

msg1 db "Number accepted"
len1 equ $-msg1

nwline db 10
nwlen equ $-nwline

section .bss

ans resb 16

section .text

global _start
_start:

pop rbx
pop rbx
pop rbx

xor rax,rax
mov al,byte[rbx]
sub al,30h
xor rbx,rbx
mov bl,al

cmp bl,00h
je zero

call Fact

mov rdx,rax
call HtoA
jmp l

zero:
mov rdx,01h
call HtoA

l:
write ans,16
write nwline,nwlen

mov rax,60
mov rdi,0
syscall

Fact:
cmp bl,01h
je last
sub bl,01
mul bx
call Fact
last: ret

HtoA:
mov rcx,16
mov rdi,ans

up2:
rol rdx,04
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
