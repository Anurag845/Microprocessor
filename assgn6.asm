%macro write 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .data

msg1 db "The system is in protected mode",10
len1 equ $-msg1

msg2 db "The system is in real mode",10
len2 equ $-msg2

msg3 db "MSW:- "
len3 equ $-msg3

msg4 db "GDTR:- "
len4 equ $-msg4

msg5 db "LDTR:- "
len5 equ $-msg5

msg6 db "IDTR:- "
len6 equ $-msg6

msg7 db "TR:- "
len7 equ $-msg7

colon db ":"
lcol equ $-colon

nwline db 10
nwlen equ $-nwline

section .bss

msw resw 01
gdt resw 03
ldt resw 01
idt resw 03
tr resw 01
temp resd 01

section .text

global _start
_start:

;print machine status word
write msg3,len3
smsw [msw]
mov ax,word[msw]
mov rdx,rax
call HtoA
write nwline,nwlen
bt word[msw],00
jc p
write msg2,len2
jmp next
p:	write msg1,len1

next:
;printing GDTR
write msg4,len4
sgdt [gdt]
mov ax,word[gdt+4]
mov rdx,rax
call HtoA
mov ax,word[gdt+2]
mov rdx,rax
call HtoA
write colon,lcol
mov ax,[gdt]
mov rdx,rax
call HtoA
write nwline,nwlen

;printing LDTR
write msg5,len5
sldt [ldt]
mov ax,word[ldt]
mov rdx,rax
call HtoA
write nwline,nwlen

;printing IDTR
write msg6,len6
sidt [idt]
mov ax,word[idt+4]
mov rdx,rax
call HtoA
mov ax,word[idt+2]
mov rdx,rax
call HtoA
write colon,lcol
mov ax,word[idt]
mov rdx,rax
call HtoA
write nwline,nwlen

;printing TR
write msg7,len7
str [tr]
mov ax,word[tr]
mov rdx,rax
call HtoA
write nwline,nwlen

mov rax,60
mov rdi,0
syscall

HtoA:
mov rcx,04
mov rdi,temp
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
write temp,04
ret
