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

msg1 db "Enter your choice:",10
     db "1.SUCCESSIVE ADDITION",10
     db "2.ADD AND SHIFT",10
     db "3.EXIT the program",10
len1 equ $-msg1

msg2 db "Enter 1st HEX NO",10
len2 equ $-msg2

msg3 db "Enter 2nd HEX NO",10
len3 equ $-msg3

msg4 db "INVALID CHOICE",10
len4 equ $-msg4

nwline db 10
nwlen equ $-nwline

section .bss

choice resb 02
num resb 03
temp resb 04
res resb 02

section .text

global _start
_start:

write msg1,len1    
read choice,02

cmp byte[choice],31H   
je case1

cmp byte[choice],32H  
je case2

cmp byte[choice],33H
je exit

write msg4,len4   
jmp _start

case1:
	write msg2,len2
	read num,03
	call AtoH
	mov byte[res],bl

	write msg3,len3
	read num,03
	call AtoH

	xor rax,rax
	
	l1:
	add rax,rbx
	dec byte[res]
	cmp byte[res],00h
	jnz l1
	
	mov rdx,rax
	call HtoA
	write temp,04
	write nwline,nwlen
	
	jmp _start
	
case2:
	write msg2,len2
	read num,03
	call AtoH
	mov byte[res],bl
	
	write msg3,len3
	read num,03
	call AtoH

	xor rax,rax
	
	mov dl,byte[res]
	mov rcx,08
	
	l2:
	shr bl,01
	jnc l3
	add rax,rdx
	l3:
	shl dx,01
	loop l2
	
	mov rdx,rax
	call HtoA
	write temp,04
	write nwline,nwlen
	
	jmp _start

exit:	mov rax,60
		mov rdi,0
		syscall

AtoH:
mov rcx,02
mov rsi,num
xor rbx,rbx
up:
rol bx,04
mov al,byte[rsi]
cmp al,39h
jbe a2
sub al,07h
a2:
sub al,30h
add bl,al
inc rsi
loop up
ret

HtoA:
mov rcx,04
mov rdi,temp
up3:
rol dx,04
mov al,dl
and al,0Fh
cmp al,09h
jbe a3
add al,07h
a3:
add al,30h
mov [rdi],al
inc rdi
loop up3
ret

