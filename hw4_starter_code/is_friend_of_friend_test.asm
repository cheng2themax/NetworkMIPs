# add test cases to data section
# Test your code with different Network layouts
# Don't assume that we will use the same layout in all our tests
.data
Name1: .asciiz "Cacophonix"
Name2: .asciiz "Getafix"
Name3: .asciiz "Hi"
Name4: .asciiz "Roger"
Name_prop: .asciiz "NAME"
Frnd_prop: .asciiz "FRIEND"

# Network:
#   .word 5   #total_nodes (bytes 0 - 3)
#   .word 10  #total_edges (bytes 4- 7)
#   .word 12  #size_of_node (bytes 8 - 11)
#   .word 12  #size_of_edge (bytes 12 - 15)
#   .word 3   #curr_num_of_nodes (bytes 16 - 19)
#   .word 3   #curr_num_of_edges (bytes 20 - 23)
#   .asciiz "NAME" # Name property (bytes 24 - 28)
#   .asciiz "FRIEND" # FRIEND property (bytes 29 - 35)
#    # nodes (bytes 36 - 95)	
#   .byte 'C' 'a' 'c' 'o' 'p' 'h' 'o' 'n' 'i' 'x' 0 0 'G' 'e' 't' 'a' 'f' 'i' 'x' 0 0 0 0 0 'H' 'i' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0	
#    # set of edges (bytes 96 - 215)
#   .word 268501064 268501088 1 268501076 268501088 1 268501064 268501076 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0

Network:
  .word 5   #total_nodes (bytes 0 - 3)
  .word 4  #total_edges (bytes 4- 7)
  .word 11  #size_of_node (bytes 8 - 11)
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


la $a0, Network #create person 1
jal create_person

move $s0, $v0 


la $a0, Network # give person 1 a name, Cacophonix 
move $a1, $s0 
la $a2, Name_prop
la $a3, Name1

jal add_person_property

la $a0, Network 
jal create_person #create person 2
move $s1, $v0 




la $a0, Network
move $a1, $s1
la $a2, Name_prop # give person 2 a name, Getafix 
la $a3, Name2

jal add_person_property

la $a0, Network
jal create_person

move $s2, $v0 


la $a0, Network
move $a1, $s2
la $a2, Name_prop
la $a3, Name3

jal add_person_property

la $a0, Network
move $a1, $s1
move $a2, $s0 
jal add_relation  #add relation between person 1 and person 2 
move $a0, $v0 


la $a0, Network
move $a1, $s0
move $a2, $s1
la $a3, Frnd_prop 
addi $sp, $sp, -4 
li $s5, 1
sw $s5, 0($sp)

jal add_relation_property #make person 1 and person 2 friends 

addi $sp, $sp, 4







la $a0, Network
move $a1, $s1
move $a2, $s2

jal add_relation # add relation between person 2 and 3 

la $a0, Network 
move $a1, $s1 # add friendship bewteen person 2 and person 3 
move $a2, $s2
la $a3, Frnd_prop
addi $sp, $sp, -4
li $s5, 22
sw $s5, 0($sp)

jal add_relation_property

addi $sp, $sp, 4

la $a0, Network
la $a1, Name1
la $a2, Name1

jal is_friend_of_friend

# move $a0, $v0 
# li $v0, 1
# syscall 





# li $v0, 10 
# syscall



la $a0, Network
move $a1, $s0
move $a2, $s2

jal add_relation  




la $a0 , Network 
jal create_person 


move $s6, $v0 


la $a0, Network
move $a1, $s6
la $a2, Name_prop
la $a3, Name4

jal add_person_property

la $a0, Network 
move $a1, $s6
move $a2, $s1

jal add_relation 


# la $a0, Network 
# move $a1, $s6
# move $a2, $s1

# jal is_friend 

la $a0, Network
la $a1, Name4
jal get_person 
move $a0, $v0
li $v0, 4
syscall 
































	# la $a0, Network
	# la $a1, Name1
	# la $a2, Name2
	# jal is_friend_of_friend
	
	# #write test code
	
	# move $a0, $v0 
	
	# li $v0, 1 
	# syscall
	
	# li $v0, 10 
	# syscall
	
	# la $a0, Network
	# la $a1, Name1
	
	
	
	# jal get_person
	
	# move $s0, $v0 
	
	
	
	
	#move $a0, $v0 
	#li $v0, 1
	#syscall
	
	
	# la $a0, Network
	# la $a1, Name3
	
	# jal get_person
	
	# move $s1, $v0
	
	# move $a0, $v0 
	# li $v0, 1
	# syscall
	
	# li $v0, 10 
	# syscall
	
	# la $a0, Network
	# move $a1, $s0
	# move $a2, $s1 
	
	# jal is_relation_exists
	
	# move $a0, $v0 
	# li $v0, 1
	# syscall
	
	
	
	
	li $v0, 10
	syscall
	
.include "hw4.asm"
