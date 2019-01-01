%macro write 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro read 2
mov rax,0
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .data

msg1 db "Copied successfully!",10
len1 equ $-msg1

msg2 db "Deleted successfully!",10
len2 equ $-msg2

msg3 db "Contents of the file are:",10
len3 equ $-msg3

msg4 db "ERROR!",10
len4 equ $-msg4

section .bss

fname resq 1
fname2 resq 1
fd resq 1
fd2 resq 1
buffer resb 100
fileleng resq 1

section .text

global _start
_start:

pop rbx
pop rbx
pop rbx

cmp byte[rbx],43h
je copy
cmp byte[rbx],44h
je delete
cmp byte[rbx],54h
je type
jmp exit

copy:
pop rbx
mov rsi,fname

pop rcx
mov rdi,fname2

up1:
mov al,byte[rbx]
mov byte[rsi],al
inc rbx
inc rsi
cmp byte[rbx],00h
jne up1

up2:
mov al,byte[rcx]
mov byte[rdi],al
inc rcx
inc rdi
cmp byte[rcx],00h
jne up2

;open the file
mov rax,2
mov rdi,fname
mov rsi,2
mov rdx,0777
syscall

mov qword[fd],rax
bt qword[fd],63
jc error

;open the file
mov rax,2
mov rdi,fname2
mov rsi,2
mov rdx,0777
syscall

mov qword[fd2],rax
bt qword[fd2],63
jc error

;get the contents of file in buffer
mov rax,0
mov rdi,[fd]
mov rsi,buffer
mov rdx,100
syscall

mov qword[fileleng],rax

;write the contents of buffer in file
mov rax,1
mov rdi,[fd2]
mov rsi,buffer
mov rdx,qword[fileleng]
syscall

write msg1,len1
jmp exit

delete:
pop rbx
mov rsi,fname

up:
mov al,byte[rbx]
mov byte[rsi],al
inc rbx
inc rsi
cmp byte[rbx],00h
jne up

mov rax,87
mov rdi,fname
syscall

write msg2,len2
jmp exit

type:
pop rbx
mov rsi,fname

up3:
mov al,byte[rbx]
mov byte[rsi],al
inc rbx
inc rsi
cmp byte[rbx],00h
jne up3

;open the file
mov rax,2
mov rdi,fname
mov rsi,2
mov rdx,0777
syscall

mov qword[fd],rax
bt qword[fd],63
jc error

;get the contents of file in buffer
mov rax,0
mov rdi,[fd]
mov rsi,buffer
mov rdx,100
syscall

write msg3,len3
write buffer,100

jmp exit

;system call for printing error message
error:
mov rax,1        
mov rdi,1
mov rsi,msg4      
mov rdx,len4
syscall

exit:
mov rax,60
mov rdi,0
syscall
