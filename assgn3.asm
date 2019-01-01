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

nwline db 10
nwlen equ $-nwline

msg db "Enter your choice",10
    db "1:HEX to BCD",10
    db "2:BCD to HEX",10
    db "3:Exit",10
len equ $-msg

msg1 db "Invalid choice",10
len1 equ $-msg1

msg2 db "HEX to BCD",10
len2 equ $-msg2

msg3 db "BCD to HEX",10
len3 equ $-msg3

msg4 db "Enter HEX number",10
len4 equ $-msg4

msg5 db "Enter BCD number",10
len5 equ $-msg5

cnt db 00H

section .bss

choice resb 02
hex resb 05
result resb 01
ans resb 04
BCD resb 06

section .text

global _start
_start:

	    write msg,len
        read choice,02
        cmp byte[choice],31H
        je case1
        cmp byte[choice],32H
        je case2
        cmp byte[choice],33H
        je exit
        write msg1,len1
        jmp exit

case1:	write msg4,len4
		read hex,05
		call AtoH
		mov rax,rbx
		mov rbx,0AH
	label:
		xor rdx,rdx
		div rbx
		push rdx
		inc byte[cnt]
		cmp rax,00h
		jne label
	repeat:
		pop rdx
		add dl,30h
		mov byte[result],dl
		write result,01
		dec byte[cnt]
		jnz repeat
		write nwline,nwlen
		jmp _start

case2:  write msg5,len5
        read BCD,06
        xor rax,rax
        xor rbx,rbx
        mov rbx,0AH
        mov rsi,BCD
        mov rcx,05H
    l1:
        xor rdx,rdx
        mul rbx
        xor rdx,rdx
        mov dl,byte[rsi]
        sub dl,30H
        add rax,rdx
        inc rsi
        loop l1

        mov rdx,rax
        call HtoA
        write ans,04
        write nwline,nwlen
        jmp _start

exit:   mov rax,60
        mov rdi,0
        syscall


AtoH:
mov rcx,04
mov rsi,hex
xor rbx,rbx

up1:
rol bx,04
mov al,byte[rsi]
cmp al,39h
jbe a1
sub al,07h

a1:
sub al,30h
add bl,al
inc rsi
loop up1
ret

HtoA:
mov rcx,04
mov rdi,ans

up2:
rol dx,04
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
