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

msg db "Enter character whose occurrences are to be found: "
len equ $-msg

mes db "Read successfully"
ln equ $-mes

section .bss

global spacecnt,newlinecnt,charcnt
extern c1,c2,c3,buffer

spacecnt resb 01
newlinecnt resb 01
charcnt resb 01
charcheck resb 01

section .text

global spaces,newlines,occurrences

spaces:
mov byte[spacecnt],00h
mov rsi,buffer
mov rcx,qword[c1]

l1:
cmp byte[rsi],20h
jnz l2
inc byte[spacecnt]
l2:
inc rsi
loop l1

;call HtoA
;mov al,byte[temp]
;mov [spacecnt],al
add byte[spacecnt],30h
ret

newlines:
mov byte[newlinecnt],00h
mov rsi,buffer
mov rcx,qword[c2]

l3:
cmp byte[rsi],10
jne l4
inc byte[newlinecnt]
l4:
inc rsi
loop l3

add byte[newlinecnt],30h
ret

occurrences:

write msg,len
read charcheck,01

mov rsi,buffer
mov rcx,qword[c3]
mov byte[charcnt],00h

l5:
mov dl,[charcheck]
cmp byte[rsi],dl
jne l6
inc byte[charcnt]
l6:
inc rsi
loop l5
dec byte[charcnt]
add byte[charcnt],30h
ret
