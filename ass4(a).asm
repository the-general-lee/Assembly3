.data
 my_array:
 	.align 2
	.space 100
 space:
 	.asciiz " "
 input_message:
	.asciiz "if you want to add another integer please enter 1 else enter 0, note you can't enter more than 25 integer"
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
 beq $v0,$zero, sort
 bne $v0, $zero , wrong_input
 
 sort:
 la $a0,  my_array
 add $a1, $t3, $zero
 # this function takes two paramaters, the array to be sorted and the size of that array in a0 and a1 and returns the address 
 # of the sorted array in a0
 addi $sp, $sp, -12 # reserve stack
 jal bubble_sort 
 lw $a0, 4($sp) # restore the address of the array
 lw $a1, 8($sp) # restore the size of the array
 addi $sp, $sp, 8 #restore the stack 
 add $t0, $a0, $zero # get the address of the array in a buffer to print it, we will need to increment this buffer as a cursor
 
 li $t4, 0 # counter
 print:
 lw $t1, ($t0) # reading each integer at a time
 add $t0, $t0, 4 # getting next integer
 addi $t4, $t4, 1 # counter to compare with the size of the array
 
 
 add $a0, $t1, $zero # putting the intended integer in a0 to print
 li $v0, 1
 syscall
 
 la $a0, space # printing a space after each element in the intger
 li $v0, 4 
 syscall
 
 bne $a1, $t4, print # stopping criteria after which all integers have been printed
 
 
 
 li $v0, 10
 syscall
 
 
 bubble_sort:
 sw $ra, ($sp) 
 sw $a0, 4($sp)
 sw $a1, 8($sp)	
 
 li $t0, 0 # counter for outer loop

 
 addi $t3, $a1,  -1 # this is the stopping criteria for the big_loop
 
 
 big_loop:
 sub $t4, $t3, $t0  #stopping criteria for the small loop
 addi $t0, $t0, 1  # incrementing counter to compare to the value of big loop stopping criteria
 add $t5, $a0, $zero # getting the address into t5 to use it as a cursor
 li $t1, 0 # counter for inner loop
 small_loop:
 lw $t2, ($t5) # get the current element
 add $t5, $t5, 4
 lw $t6, ($t5) # get the next element 
 bgt $t2, $t6, swap # comparing the values of two adjacent integers
 continue_your_life:
 add $t1, $t1, 1 # incremeting counter to compare to value of small loop stopping criteria
 bne $t4, $t1, small_loop # end of the small_loop
 
 bne $t3, $t0, big_loop # end of the big_loop
 
 
 lw $ra, ($sp) 
 addi $sp, $sp, 4
 jr $ra 
 
 swap: 
 jal swap_function # function that swaps when condition are met
 addi $sp, $sp, 4 # restoring t stack after being called from the function
 lw $ra, ($sp) # get the previous function call
 jr $ra # jump to previous function call
 
 
 swap_function:
  sw  $t2, ($t5) # if conditions are met put the value of the left in the right
  sw $t6, -4($t5) # and value of the right in the left
  addi $sp, $sp, -4 # after the function we reserve place in the stack to save the function call
  sw $ra, ($sp)
  j continue_your_life
 
