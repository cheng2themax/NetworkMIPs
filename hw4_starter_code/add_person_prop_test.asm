# add test cases to data section
# Test your code with different Network layouts
# Don't assume that we will use the same layout in all our tests
.data
Name1: .asciiz "Cacophonix"
Name2: .asciiz "Getafix"
Name3: .asciiz "Dolphatex122"
Name_prop: .asciiz "NAME"

Network:
  .word 5   #total_nodes (bytes 0 - 3)
  .word 10  #total_edges (bytes 4- 7)
  .word 12  #size_of_node (bytes 8 - 11)
  .word 12  #size_of_edge (bytes 12 - 15)
  .word 0   #curr_num_of_nodes (bytes 16 - 19)
  .word 0   #curr_num_of_edges (bytes 20 - 23)
  .asciiz "NAME" # Name property (bytes 24 - 28)
  .asciiz "FRIEND" # FRIEND property (bytes 29 - 35)
   # nodes (bytes 36 - 95)	
  .byte 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0	
   # set of edges (bytes 96 - 215)
  .word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0

.text:
main:
	la $a0, Network
	jal create_person
	move $s0, $v0
	
	la $a0, Network
	addi  $a1, $a0, 36
	la $a2, Name_prop
	la $a3, Name1
	jal add_person_property
	
	#write test code
	move $a0, $v0 
	li $v0, 1
	syscall
	
	li $v0, 10 
	syscall
	
	la $a0, Network
	jal create_person
	move $s0, $v0
	
	la $a0, Network
	move $a1, $s0
	la $a2, Name_prop
	la $a3, Name2
	jal add_person_property
	
	#write test code
	move $a0, $v0 
	li $v0, 1
	syscall
	
	la $a0, Network
	jal create_person
	move $s0, $v0
	
	la $a0, Network
	move $a1, $s0
	la $a2, Name_prop
	la $a3, Name2
	jal add_person_property
	
	#write test code
	move $a0, $v0 
	li $v0, 1
	syscall
	
	la $a0, Network
	jal create_person
	move $s0, $v0
	
	la $a0, Network
	move $a1, $s0
	la $a2, Name_prop
	la $a3, Name2
	jal add_person_property
	
	#write test code
	move $a0, $v0 
	li $v0, 1
	syscall
	
	la $a0, Network
	jal create_person
	move $s0, $v0
	
	la $a0, Network
	move $a1, $s0
	la $a2, Name_prop
	la $a3, Name2
	jal add_person_property
	
	#write test code
	move $a0, $v0 
	li $v0, 1
	syscall
	
	#la $a0, Network
	#jal create_person
	#move $s0, $v0
	
	la $a0, Network
	addi  $a1, $s0, 0
	la $a2, Name_prop
	la $a3, Name3
	jal add_person_property
	
	#write test code
	move $a0, $v0 
	li $v0, 1
	syscall
	
	
	la $a0, Network
	la $a1, Name1
	
	jal get_person
	
	move $a0, $v0
	
	li $v0, 4
	syscall
	
	
	
	

	
	
	
	la $s1, Network
	lw $s3, 8($s1) # get size of node 
	lw $s2, 16($s1) # get number of nodes
	addi $s1, $s1, 36
	
	li $t0, 0 
	
	print_nodes_loop:
	
	beq $t0, $s2, end 
	
	li $v0, 4 
	move $a0, $s1
	syscall
	
	addi $t0, $t0, 1
	add $s1, $s1, $s3 #advance the pointer
	
	j print_nodes_loop 
	
	
	

	
	end:
	
	li $v0, 10
	syscall
	
.include "hw4.asm"
