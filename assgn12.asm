section .data

nwline db 10
nwlen equ $-nwline

meanmsg db "CALCULATED MEAN IS:-"
meanmsg_len equ $-meanmsg

sdmsg db "CALCULATED STANDARD DEVIATION IS:-"
sdmsg_len equ $-sdmsg

varmsg db "CALCULATED VARIANCE IS:-"
varmsg_len equ $-varmsg

array dd 102.56,198.21,100.67,230.78,67.93

arraycnt dw 05
dpoint db '.'
hdec dd 100

section .bss

dispbuff resb 2
resbuff rest 1
mean resd 1
variance resd 1

%macro linuxsyscall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

section .text

global _start
_start:

finit
fldz
mov rbx,array
mov rsi,00
xor rcx,rcx
mov cx,[arraycnt]

up:
fadd dword[rbx+rsi*4]
inc rsi
loop up

fidiv word[arraycnt]
fst dword[mean]
linuxsyscall 01,01,meanmsg,meanmsg_len
call dispres

mov rcx,00
mov cx,[arraycnt]
mov rbx,array
mov rsi,00
fldz

up1:
fld dword[array+rsi*4]              ;load the number
fsub dword[mean]                    ;st0(1st number)minus mean
fmul st0                            ;square it
faddp                               ;add st1=st0+st1
inc rsi    
loop up1

fidiv word[arraycnt]
fst dword[variance]
fsqrt
linuxsyscall 01,01,nwline,nwlen
linuxsyscall 01,01,sdmsg,sdmsg_len
call dispres

fld dword[variance]
linuxsyscall 01,01,nwline,nwlen
linuxsyscall 01,01,varmsg,varmsg_len
call dispres
linuxsyscall 01,01,nwline,nwlen

exit:
mov rax,60
mov rdi,0
syscall

disp8_proc:
mov rdi,dispbuff
mov rcx,02

back:
rol bl,04
mov dl,bl
and dl,0FH
cmp dl,09
jbe next1
add dl,07H

next1:
add dl,30H
mov [rdi],dl
inc rdi
loop back
ret

dispres:
fimul dword[hdec]
fbstp tword[resbuff]
xor rcx,rcx
mov rcx,09H
mov rsi,resbuff+9

up2:
push rcx
push rsi
mov bl,[rsi]
call disp8_proc

linuxsyscall 01,01,dispbuff,2

pop rsi
dec rsi
pop rcx
loop up2

linuxsyscall 01,01,dpoint,1
mov bl,[resbuff]
call disp8_proc
linuxsyscall 01,01,dispbuff,2
ret
