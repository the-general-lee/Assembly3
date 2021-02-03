.data 
my_array:
	.align 2
	.space 100
input_message:
	.asciiz "if you want to add another integer (ascendingly) please enter 1 else enter 0, note you can't enter more than 25 integer"
val:
	.asciiz "what is the number you want searched?"
.text
main:
# input a user-input array
la $t8, my_array
li $t3, 0
enter_array:
li $v0, 5 #enter an integer
syscall
sw $v0, ($t8) # store the integer in memory
addi $t8,$t8,4 # after storing store in next address
addi $t3,$t3,1 #counter to how many elements in array
wrong_input:
li $v0, 4 # print a message asking if there is more
la $a0, input_message 
syscall
li $v0,5
syscall
beq $v0,1,enter_array
beq $v0,$zero, search
bne $v0, $zero , wrong_input
 
 
search:
li $v0, 4 # printing a message to ask for the value searched
la $a0, val 
syscall 
 
li $v0, 5 # entering the value and storing it in v0
syscall 
 


li $t4, 0
la $a0, my_array
add $a1, $v0, $zero
add $a2, $t3, $zero



# this function takes 3 parameters, the address of first element in array,  the value to be searched
# and the size of the array in a0, a1 and a2 respectively, the function returns the index the value was found in
# in v0 if the element is not found -1 is passed to v0
add $t0, $a0, $zero # pointer to the first element
addi $t1, $a2, -1
mul $t1, $t1, 4    # know how many words between the beginning and the end multiply them by the number of bytes in a word
add $t6, $a0, $t1    # pointer to the last element
add $sp, $sp, -12    # reserving stack
sw $a0, 12($sp)      # storing address
sw $a1, 8($sp)       # storing value searched
sw $a2, 4($sp)       # storing size
jal binary_search
lw $a2, 4($sp)      #loading size
lw $a1, 8($sp)      # loading searched value
lw $a0, 12($sp)     # loading address to array
add $t4, $v0, $zero # getting the output of the function into t4
addi $sp, $sp, 16   # restoring stack

add $a0,$t4,$zero   # printing the output, index of the value.
li $v0, 1
syscall

li $v0, 10
syscall

binary_search:
sw $ra, ($sp)
add $sp, $sp, -4 
add $t5, $t6, $t0   # getting the middle element
div $t5, $t5, 2     # getting the middle element
add $t8, $t5, $zero # copying the value to see if it is divisible by 4 or not to determine whether we need to fix or not
div $t8, $t8, 4     # check divisible by 4
mfhi $t8            # move remainder to t8
bne $t8, $zero, fix      # if the middle element is not word aligned we need to fix it
continue_your_life:
lw $t2, ($t5)       # gets the value at the middle element
add $t3, $a1, $zero # get the value you want searched
beq $t0, $t6, limit # if both cursors are the same,  meaning the whole array is searched we have to possibilities either index exist or not
bgt $t2, $t3, left_branch
blt $t2, $t3, right_branch
beq $t2, $t3, index

limit:
beq $t2, $t3, index
bne $t2, $t3, no_index

left_branch:
add $t6, $t5, $zero # we make our new right cursor be pointing at the middle value that we checked
jal binary_search
addi $sp, $sp,4    # restoring stack to get back to main function
lw  $ra, ($sp)     # loading the call of the preivous function
jr $ra             # calling the previous function

right_branch:
add $t5, $t5, 4 # adding one to not cover the same element twice in both branches
add $t0, $t5, $zero # changing left cursor to be the next element to the right of the middle element we insepected
jal binary_search
addi $sp, $sp,4  # restoring stack to get back to main function
lw  $ra, ($sp)   # loading the call of the preivous function
jr $ra           # calling the previous function

index:
sub $t7, $t5, $a0 # gets the number of bytes by subtracting the value of the address found from the reference address
div $t7, $t7, 4 # dividing this difference by for to get how many words hence how the exact number of the index
add $v0, $t7, $zero
addi $sp, $sp,4
lw  $ra, ($sp)
jr $ra

fix:
add $t5, $t5, -2
j continue_your_life
no_index:
addi $v0,$zero, -1
addi $sp, $sp,4
lw  $ra, ($sp)
jr $ra
