############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
.text:




is_valid_network: 
	#takes $a0 as an argument 
	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $s1, 4($sp)

	li $v0, 1 
	lw $s0, 0($a0) # load max number of nodes
	bltz $s0, invalidNetwork
	lw $s1, 16($a0) #load current number of nodes
	bltz $s1, invalidNetwork
	bgt $s1, $s0, invalidNetwork # if too many nodes then error
	lw $s0, 8($a0) #negative size of nodes? 
	bltz $s0, invalidNetwork

	lw $s0, 4($a0) # load the max number of edges
	bltz $s0, invalidNetwork
	lw $s1, 20($a0) # load the current number of edges
	bltz $s1, invalidNetwork
	bgt $s1, $s0, invalidNetwork 
	lw $s0, 12($a0) #negative size of edges?
	bltz $s0, invalidNetwork 

	j returnValidNetwork 

	invalidNetwork: 
	li $v0, 0 

	returnValidNetwork: 

	lw $s0, 0($sp)
	lw $s1, 4($sp)
	addi $sp, $sp, 8
	jr $ra 


str_len: #argument $a0 is the string address

addi $sp, $sp, -12
sw $s0, 0($sp) #counter value
sw $s1, 4($sp) #looking character by character
sw $s2, 8($sp)

	move $s2, $a0 
	li $s0, 0 # instantiate counter
	length_loop:
		lbu $s1, 0($s2)
		beqz $s1, returnLength
		addi $s0, $s0, 1 #add counter 
		addi $s2, $s2, 1 #advance string along

	j length_loop 

	returnLength: 
	move $v0, $s0 

lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
addi $sp, $sp, 12 
	jr $ra

str_equals: #a0 address of first string, $a1 address of second string


addi $sp, $sp, -20
sw $s0, 0($sp) # save byte loading 
sw $s1, 4($sp) #save byte loading
sw $s2, 8($sp) #save $a0
sw $s3, 12($sp) #save $a1

	move $s2, $a0 #move in the string arguments 
	move $s3, $a1 

	equality_loop:
		lbu $s0, 0($s2)
		beqz $s0, sameLengthCheck
		lbu $s1, 0($s3)
		beqz $s1, sameLengthCheck
		bne $s0, $s1, notEqual 

	addi $s2, $s2, 1 #advance the string
	addi $s3, $s3, 1 #advance the string

	j equality_loop

		sameLengthCheck: 
		lbu $s0, 0($s2)
		lbu $s1, 0($s3)
		beq $s0, $s1, isEqual #if both terminate at the same point

		notEqual: #return condition if not equal
		li $v0, 0

		j returnEquality

		isEqual:
		li $v0, 1

		returnEquality:

		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)

		addi $sp, $sp, 20 #reset the stack
		
	jr $ra


str_cpy: #$a0 is the source, $a1 is the destination 
	li $t0, 0 # counter for number of characters copied
	copy_loop:

		lbu $t1, 0($a0)
		beqz, $t1, returnCopy #stopping condition
		sb $t1, 0($a1)
		addi $a0, $a0, 1
		addi $a1, $a1, 1
		addi $t0, $t0, 1 # increment the counter

	j copy_loop

	returnCopy: 
	sb $zero, 0($a1) #null terminate
	move $v0, $t0 

	jr $ra



create_person: #$a0 = address of the network 
	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $ra, 4($sp)

	move $s0, $a0 #save the address of the network
	
	jal is_valid_network #check if valid network 

	beqz $v0, destroyPerson 

	lw $t0, 0($s0) #total_nodes loaded in (max number)
	lw $t1, 16($s0) #current number of nodes 

bge $t1, $t0, destroyPerson # total number of nodes == current number of nodes then error insertion

	addi $t0, $a0, 36 # get base address for start of nodes 

	lw $t2, 8($a0) #load the size of a node 

mult $t1, $t2 # multiply size of node by the number of nodes currently
mflo $t3

add $v0, $t0, $t3 # return the sum to the correct address

addi $t1, $t1, 1 #increment the number of nodes
sw $t1, 16($a0) #write into memory

j creationDone 

destroyPerson:
	li $v0, -1
creationDone: 
lw $s0, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8 
	jr $ra


is_person_exists: #$a0 = node network, $a1 = node person address 
	addi $sp, $sp , -8
		sw $ra, 4($sp)
		sw $s0, 0($sp)

	jal is_valid_network

	beqz $v0, returnFromPersonExists # if invalid board just return 0 

	addi $s0, $a0, 36 # get to the start of the node subarray
		li $v0, 0
		blt $a1, $s0, returnFromPersonExists #if address occurs before the node list even begins
		lw $t2, 0($a0) #load max number of nodes
		lw $t0, 16($a0) #load current number of nodes
		lw $t1, 8($a0) #load the size of each node

		mult $t0, $t1 #multiply
		mflo $t3 #get product 

	add $t3, $s0, $t3 # add to find the address of the end of the node array 

		sub $s0, $t3, $a1 #find distance between end and start
		blez $s0, returnFromPersonExists #person does not exist if the difference between final address and the person's address is negative or zero

		div $s0, $t1 #divide the distance by the size of each node
		mfhi $s0 
		bnez $s0, returnFromPersonExists #if the remainder is not zero then not a person

	personExists:
	li $v0, 1

returnFromPersonExists:

lw $s0, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
	jr $ra


is_person_name_exists:
	#$a0 Network, $a1 # character name
	#looping through the set of persons, check if the address of the person passed in is less than the address of the full array (curr_nodes * node size)

	addi $sp, $sp, -12
	sw $s1, 8($sp) #save iterator
	sw $s0, 4($sp) #save the pointer of the Network
	sw $ra, 0($sp) #save the return address

	jal is_valid_network #check if valid board 

	beqz $v0, personNameDNE 

	move $s0, $a0 #save the network address pointer
	
	lw $t0, 16($a0) #load the number of nodes (iteration stop point)

	move $t8, $a1 #save the comparison string 

	addi $s1, $s0, 36 #get to the start of the nodes
	lw $t3, 8($s0) # load the size of each node
	li $t4, 0 # counter for number of nodes

	name_node_loop: 

		beq $t4, $t0, personNameDNE # if we have iterated through and no person found
		move $a0, $s1 #iterating address
		move $a1, $t8 #the string name for comparison 

		jal str_equals 

		move $v1, $s1 # preload the address in case
		bnez $v0, personNameExists # if not equal to zero, then person exists and $v0 is 1 

		addi $t4, $t4, 1 # increment the counter
		add $s1, $s1, $t3 # increment by size of each node 

		j name_node_loop 


personNameDNE: 
li $v0, 0
li $v1, 0

personNameExists: 

lw $ra, 0($sp)
lw $s0, 4($sp)
lw $s1, 8($sp)
addi $sp, $sp, 12 #reset the stack after loading back the return address 
jr $ra




add_person_property:

	#$a0 : network pointer
	#$a1: person node
	#$a2: prop_name
	#$a3: prop_val  

	addi $sp, $sp, -8
	sw $s0, 4($sp)
	sw $ra, 0($sp)

	jal is_valid_network

	beqz $v0, DNEPerson # if the network is not valid, then return with invalid 

	move $s0, $a0 
	move $t5, $a1 #save the person node to find/update for (this is an address)

	move $a0, $a2 
	#
	addi $a1, $s0, 24 # get the name property

	jal str_equals #check if the string is equal 
	beqz $v0, invalidProperty

	# Finished checking for if the property is invalid

	move $a0, $s0 
	move $a1, $t5 # person node moved in 

	jal is_person_exists 

	beqz $v0, DNEPerson

	# Finished checking if the person exists
	

	move $a0, $a3 # string length computation 

	jal str_len 

	lw $t1, 8($s0) #load the size of a node

	bge $v0, $t1, propertyTooBig # if person is too big  #BGE?


	#Finished checking if the property is too big in size

	move $a0, $s0 #load in network pointer
	move $a1, $a3 # load in name
	jal is_person_name_exists ##TODO:
	
	bnez $v0, duplicateName
	
	#end of checking duplicate name 

	move $a0, $a3 #move in string to be copied
	move $a1, $t5 #the person node to be written into

	jal str_cpy #copy the string into the correct destination

	li $v0, 1 #sucessful adding of property

	j returnFromAddPersonProp

	invalidProperty: 
	move $v0, $zero 
	j returnFromAddPersonProp

	DNEPerson:
	li $v0, -1 
	j returnFromAddPersonProp

	propertyTooBig: 
	li $v0, -2
	j returnFromAddPersonProp 

	duplicateName: 
	li $v0, -3

	returnFromAddPersonProp:
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8 #reset stack

	jr $ra


get_person:
	addi $sp, $sp, -4
	sw $ra, 0($sp) #save the return address

	jal is_person_name_exists #v1 has the address 

	beqz $v0, returnfromGet # if person name could not be gotten then return 0 

	move $v0, $v1 # move in the address


	returnfromGet: 

	lw $ra, 0($sp)
	addi $sp, $sp, 4 #reset the stack
	jr $ra


is_relation_exists: 
	addi $sp, $sp, -16
	sw $s0, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $ra, 0($sp)

	move $s0, $a0 #save network address

	### IDEA: Check the two words in the front of a relation for equality

	jal is_valid_network #check if valid network 

	beqz $v0, relationDNE 


	beq $a1, $a2, relationDNE #if the arguments are the same, then there is no relation betweeen them (supposed)#TODO: ???

	lw $s1, 20($s0) #load the number of edges to iterate through

	lw $t0, 8($a0) #load size of node 
	lw $t1, 0($a0) #load max amount of nodes

	mult $t0, $t1
	mflo $t0 #product of size of nodes and nuber of nodes

	#TODO: test if this works 
	li $t1, 4
	div $t0, $t1 #(nodes size *number of nodes)/4
	mfhi $t2 #check the remainder

	beqz $t2, isRelationContinue

	mflo $t2 #move the quotient
	addi $t2, $t2, 1
	mult $t2, $t1
	mflo $t0 #move in the product of (1 + (nodes * number of nodes)/4) * 4 

	isRelationContinue: 


	addi $s0, $s0, 36 
	add $s0, $s0, $t0 #get to front of the edges
	
	li $s2, 0 #counter through edges

	isRelationLoop:
		beq $s2, $s1, relationDNE #we have looped through all the edges at this point
		lw $t4, 0($s0) # front edge
		beq $t4, $a1, checkArg2_edge1 # if the first node* in edge is equal to $a1
		beq $t4, $a2, checkArg1_edge1 # if the first node* in edge is equal to $a2 

		nextRelation:

		addi $s0, $s0, 12 #iterate through edges
		addi $s2, $s2, 1 #increment counter

		j isRelationLoop 

	checkArg2_edge1: #from the edge part 1 check, we check that second part of the edge is arg2
		lw $t4, 4($s0)
		beq $t4, $a2, relationExists
		j nextRelation
	
	checkArg1_edge1: #from edge part 1 check, we check that the second part of the edge is arg1
		lw $t4, 4($s0)
		beq $t4, $a1, relationExists
		j nextRelation 

	relationExists:
		move $v1, $s0 #save the final address
		li $v0, 1
		j  returnIsRelation 

	relationDNE: 
	li $v0, 0 

	returnIsRelation:

	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $ra, 0($sp)
	lw $s0, 12($sp)
	addi $sp, $sp, 16

	jr $ra



add_relation: 
# $a0 = network address
# $a1 = person1
# $a2 = person2


	addi $sp, $sp, -16
	sw $s2, 12($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $ra, 0($sp)

	#needs get person to get the address, and then add the addresses?

	#TODO: Likewise here, does get_person get invoked outside of the method? 
	#otherwise replace with is_person_exists

	move $s0, $a0 #save network pointer
	move $s1, $a1 # move person 1 in
	move $s2, $a2 # move person 2 in

	move $a0, $s0 #network address
	move $a1, $s1 #move person 1 in

	jal is_person_exists #check if person 1 exists

	beqz $v0, return_AddRelation 

	move $a0, $s0  #network address
	move $a1, $s2  #move person 2 in 

	jal is_person_exists #check if person 2 exists

	beqz $v0, return_AddRelation


	lw $t6, 20($s0) #load the number of edges (current)
	lw $t7, 4($s0) # load the max number

	bge $t6, $t7, tooManyEdges #if there are already too many edges

	move $a0, $s0 #move in the network address
	move $a1, $s1 #move in person 1 address within the network
	move $a2, $s2 #move in person 2 address within the network

	jal is_relation_exists 

	bnez $v0, duplicateEdge # if this function returns 1 then we know that there is duplicate

	beq $s1, $s2, samePersonError

	#Math to get to the next vacant edge and sw to fill properly 

	lw $t6, 20($s0) # load number of edges currently 
	lw $t7, 12($s0) # get the size of edge
	mult $t6, $t7
	mflo $t6 # save the product of the number of edges and size of edge to know where to begin storing word

	lw $t0, 0($s0) #get the max number of nodes
	lw $t1, 8($s0) # get the size of a node

	mult $t0, $t1 
	mflo $t0 #product to yield the start 

	#TODO: Test this
	li $t1, 4
	div $t0, $t1
	mfhi $t2 #save the remainder to check if multiple of four 

	beqz $t2, continueAddR #if the remainder is zero continue with adding relation

	#otherwise we save the quotient, increment it by 1, and multiply by four to get the word-aligned start of edges
	mflo $t0 
	addi $t0, $t0, 1
	mult $t0, $t1 #product of (nodes size*nodes)/4 +1
	mflo $t0 #move the new offset in 

	continueAddR: 

	#EXTRA PADDING CHECK? 

	addi $t3, $s0, 36 #gets to start of the nodes
	add $t3, $t3, $t0   #get to start of edges
	add $t3, $t3, $t6 # increment to the new point of insertion

	sw $s1, 0($t3) #fill in first person
	sw $s2, 4($t3) # fill in the second person 
	sw $zero, 8($t3) # fill in zero for friendship condition


	# increment number of edges

	lw $t1, 20($s0)
	addi $t1, $t1, 1
	sw $t1, 20($s0) #increment the number of edges


	li $v0, 1 #successful add
	j return_AddRelation #misnomer, this is just the return 

	samePersonError: 
	li $v0, -3
	j return_AddRelation

	duplicateEdge: # if the edge already exists 
	li $v0, -2
	j return_AddRelation

	tooManyEdges: 

	li $v0, -1 

	return_AddRelation: 
	lw $ra, 0($sp)
	lw $s0, 4($sp) #reset the stack
	lw $s1, 8($sp)
	lw $s2, 12($sp)

	addi $sp, $sp, 16 #reset the stack

	jr $ra



add_relation_property:

	lw $t4, 0($sp) #load in the prop_value
	addi $sp, $sp, -20 
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)

#$a0 = network pointer
	#$a1 = node person1 
	#$a2 = node person 2
	#$a3 = node person 3
	#0($sp) = prop_value

	move $s3, $t4 #save the prop_value
	move $s0, $a0 #move the network address 
	move $s1, $a1 #save the first person in the relationship 
	move $s2, $a2 #save the second person in the relationship

	jal is_relation_exists #check if the relation exists
	beqz $v0, noRelationNoProperty

	addi $a0, $s0, 29  #'FRIEND"
	move $a1, $a3 #the friend property loaded in 

	jal str_equals 

	beqz $v0, invalidRelationProp # if the value is not equal to "FRIEND" then we error 

	bltz $s3, propValNegError

	## ADD IN CODE FOR LOOPING THROUGH THE EDGES

	move $a0, $s0 #move in network
	move $a1, $s1 #move in first person (node*)
	move $a2, $s2 #move in second person (node*)
	 
	jal is_relation_exists #returns the return address of the relation in $v1

	sw $s3, 8($v1) #write in the edge value

	j returnFromRelationPropAdd
	
	propValNegError: 
	li $v0, -2 
	j returnFromRelationPropAdd

	invalidRelationProp:
	li $v0, -1 
	j returnFromRelationPropAdd

	noRelationNoProperty:
	li $v0, 0 

	returnFromRelationPropAdd: #Returning label
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	addi $sp, $sp, 20
	jr $ra


is_friend: #Helper method
	#$a0 = network
	#$a1 = friend node* 1
	#$a2 = friend node* 2
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	jal is_relation_exists #check if relation exists with the return address

	beqz $v0, returnFromFriend #relation doesn't even exist 

	lw $t2, 8($v1) # get the value of the third word in the edge

	li $v0, 1 #load in value assuming is friend
	bgtz $t2 , returnFromFriend #if the third word is equal to 1, then we returnFrom Friend with return val of 1
	li $v0, 0 #we return from, they are not a friend

	returnFromFriend:

	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra


is_friend_of_friend:

	addi $sp, $sp, -20
	sw $s3, 16($sp) #save the max number of nodes
	sw $s2, 12($sp)
	sw $s1, 8($sp)
	sw $s0, 4($sp)
	sw $ra, 0($sp)

	move $s0, $a0 #save network address
	move $t9, $a0  #save another copy of $a0
	move $s1, $a1 #save person 1
	move $s2, $a2 # save person 2


	jal get_person  #check if person 1 exists/get person 1

	beqz $v0, nanPerson # if this returns zero then a person does not exist
	move $s1, $v0 #save the address (Node*)

	move $a0, $s0 
	move $a1, $s2 #check person 2 exists/get person

	jal get_person #check if person 2 exists/get person 2 

	beqz $v0, nanPerson 
	move $s2, $v0 # save the address (Node*)

 
	beq $s1, $s2, notFOF #if we check for the same persons


	move $a0, $s0 #move in pointer to Network
	move $a1, $s1
	move $a2, $s2

	jal is_friend #are the two people friends with eachother already?


	bnez $v0, notFOF #if the two people are already friends they are not friends of friends

	#loop through the nodes

	lw $t6, 8($a0) # get the size of each node
	lw $s3, 0($a0) #get the number of nodes max
	li $t3, 0 #counter for nodes iterating through
	
	addi $s0, $a0, 36 # get to start of nodes

	fof_loop:

		bge $t3, $s3, notFOF #after reaching end of iteration,we realize not friend
		
		move $a0, $t9 # save $t9 to 
		move $a1, $s0
		move $a2, $s1

		jal is_friend 

		bnez $v0, checkAlsoFriend

		addi $t3, $t3, 1
		add $s0, $s0, $t6 # advance along nodes

		j fof_loop 

	checkAlsoFriend: 
		#$a0 never changes, always the pointer to network
		move $a0, $t9
		move $a1, $s0
		move $a2, $s2

		jal is_friend #check if friend

		bnez $v0, returnFOF #if $v0 is 1 then return 
		addi $t3, $t3, 1
		add $s0, $s0, $t6 # advance along nodes
		j fof_loop


	nanPerson: #person does not exist (either one)
	li $v0, -1

	j returnFOF 

	notFOF: #not friend of friend
	li $v0, 0 

	returnFOF: 

	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $ra, 0($sp)
	lw $s3, 16($sp) #load back in $s3
	addi $sp, $sp, 20

# idea use is relation exists on all of the nodes twice for each friend_of_friend, check if the 8($) offset is equal to 1 and then branch check. 
	jr $ra