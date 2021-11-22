# add test cases to data section
.data
newline: .asciiz "\n"
str1: .asciiz "Jane Does"
str2: .asciiz "Jane Doe"

str3: .asciiz "Jane Does"
str4: .asciiz "" 
.text:
main:
	la $a0, str1
	la $a1, str2
	jal str_equals
	#write test code
	
	move $a0, $v0 
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	la $a0, str1
	la $a1, str3
	jal str_equals
	#write test code
	
	la $a0, str1
	la $a1, str4
	
	jal str_cpy
	
	
	la $a0, str4 
	
	jal str_len
	
	move $a0, $v0 
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall
	
.include "hw4.asm"
