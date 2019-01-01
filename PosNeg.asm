;Assembly program to determine number of positive and negative numbers in a predefined array

section .data
arr dq 9234567812345678H,1234567821348569H,1245369823145982H,1263548723654891H,8936548921364598H,2136548924654861H
msg1 db "Positive numbers are "
len1 equ $-msg1
msg2 db "Negative numbers are "
len2 equ $-msg2
nwline db 10
nwlen equ $-nwline
cnt equ 6
pcnt db 00h
ncnt db 00h

section .bss
temp resb 02

section .text

global _start
_start:

mov rcx,cnt
mov rsi,arr

l2:
bt qword[rsi],63
jnc pos
inc byte[ncnt]
jmp l3
pos:
inc byte[pcnt]

l3:
add rsi,08
loop l2

mov dl,[pcnt]
call HtoA

;write system call for message 1
mov rax,1
mov rdi,1
mov rsi,msg1
mov rdx,len1
syscall

;write sytem call for positive numbers
mov rax,1
mov rdi,1
mov rsi,temp
mov rdx,2
syscall

;write system call for new line
mov rax,1
mov rdi,1
mov rsi,nwline
mov rdx,nwlen
syscall

mov dl,[ncnt]
call HtoA

;write system call for message 2
mov rax,1
mov rdi,1
mov rsi,msg2
mov rdx,len2
syscall

;write sytem call for negative numbers
mov rax,1
mov rdi,1
mov rsi,temp
mov rdx,2
syscall

;write system call for new line
mov rax,1
mov rdi,1
mov rsi,nwline
mov rdx,nwlen
syscall

;system call for termination
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
