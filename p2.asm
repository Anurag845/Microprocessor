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

msg db "Enter character "
len equ $-msg

section .bss
global spacecnt,newlinecnt,charcnt
extern c1,c2,c3,buffer
spacecnt resb 2
newlinecnt resb 2
charcnt resb 2
charcheck resb 2

section .text
global spaces,newlines,occurrences

spaces:
mov rcx,qword[c1]
mov rsi,buffer
mov byte[spacecnt],00h

l1:
cmp byte[rsi],20h
jne down1
inc byte[spacecnt]
down1:
inc rsi
loop l1

ret

newlines:
mov byte[newlinecnt],00h
mov rsi,buffer
mov rcx,qword[c2]
l2:
cmp byte[rsi],10
jne down2
inc byte[newlinecnt]
down2:
inc rsi
loop l2

ret

occurrences:
write msg,len
read charcheck,2
mov rsi,buffer
mov rcx,qword[c3]
mov al,byte[charcheck]
l3:
cmp al,byte[rsi]
jne down3
inc byte[charcnt]
down3:
inc rsi
loop l3

ret
