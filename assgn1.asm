%macro write 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro read 2
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .data

array dq 8321465974123589h,1234567891234567h,3698521471236548h,9638527413216549h,9638521475913496h

msg1 db "Positive numbers in array "
len1 equ $-msg1

msg2 db "Negative numbers in array "
len2 equ $-msg2

nwline db 10
nwlen equ $-nwline

cnt equ 05h
pcnt db 00h
ncnt db 00h

section .bss

temp resb 2

section .text

global _start
_start:

mov rsi,array
mov rcx,cnt

l1:
bt qword[rsi],63
jc neg
inc byte[pcnt]
jmp l2
neg:  inc byte[ncnt]
l2:   add rsi,08
loop l1

write msg1,len1
mov dl,[pcnt]
call HtoA
write temp,2
write nwline,nwlen

write msg2,len2
mov dl,[ncnt]
call HtoA
write temp,2
write nwline,nwlen

mov rax,60
mov rdi,0
syscall

HtoA:
mov rcx,02
mov rdi,temp

up2:
rol dl,04
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
