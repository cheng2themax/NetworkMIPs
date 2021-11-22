# add test cases to data section
.data
src: .asciiz "Jane Doerrrr"
newline: .asciiz "\n"
dest: .asciiz ""

.text:
main:
	la $a0, src
	la $a1, dest
	jal str_cpy
	#write test code
	
	move $a0, $v0 
	li $v0, 1
	syscall 
	
	li $v0, 4
	la $a0, newline
	syscall
	
	li $v0, 4 
	la $a0, dest
	syscall
	
	
	li $v0, 10
	syscall
	
.include "hw4.asm"
