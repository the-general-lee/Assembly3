section .data
	my_array dd 126, 55, 13, 62, 6
	space db " "
section .bss
	string_array resb 100
section .text
	global _start

_start:

	mov rcx, my_array	; first argument, the address of the array
	mov rdx, 5		; second argument, the size of the array

	push rcx
	push rdx
	call bubble_sort
	pop rdx
	pop rcx


				;printing the array through a function that takes the array and its size
	push rcx
	push rdx
	call print_array
	pop rdx
	pop rcx

	mov rax, 60		; syscall for end
	mov rdi, 0		; error code for no error
	syscall

				; end of the main function


bubble_sort:


	mov r8, 0		; counter for outer loop
	sub rdx, 1		; this is the stopping criteria for the outer loop
big_loop:
	mov r9, rdx		; this will be used to make a stopping criteria for the inner loop

	sub r9, r8		; stopping criteria for the small loop
	inc r8
	mov r10,my_array	; get the address into r10 to act as cursor
	mov r12, 0		; counter for the inner loop
small_loop:
	mov r11d, [r10]		; getting the current element
	add r10, 4
	mov r13d, [r10]		; getting the next element
	cmp r11d, r13d		; compare the values of the two adjacent integers
	jg swap			; swap if the current is bigger than next
continue_your_life:
	inc r12			; incrementing counter to sometime meet the criteria
	cmp r9, r12		; compare the counter to small loop stopping criteria
	jne small_loop		; end of small_loop


	cmp rdx, r8		; compare the counter to large loop stopping criteria
	jne big_loop		; end of big_loop

	ret

swap:
	call swap_function		; function that swaps when conditions are met
	ret

swap_function:
	mov [r10], r11d			; if conditions are met put the value of the left on the right
	mov [r10-4], r13d		; if conditions are met put the right on the left
	jmp continue_your_life




print_array:

	mov r8, rcx      		; getting the address in a register to increment it
	mov r13, rdx    		; size of the array
	mov r12, 0			; counter to know how many elements was converted

convert_array_ascii:
	mov  eax, [r8]			; getting the element to be printed
	mov r10, string_array		; getting the address in a register to increment
	mov r9, 0			; counter to know how many digits are in the element

convert_element_ascii:

	mov rbx, 10			; we are going to divide by 10 to get the lsd in remainder and eliminate it from the number
	mov rdx, 0			; we set rdx to be 0 to prevent it and rax from forming a 128 bit register
	div rbx				; divide rax by rbx put the reminder in rdx and the quotient in rax

	add rdx, 48			; convert into ascii
	mov [r10], dl			; put the value of the digit into the register
	inc r10				; increment to store the next digit
	inc r9				; increment the number of digits counter

	cmp rax, 0
	jne convert_element_ascii
print_element:
	dec r10
	dec r9

	mov rax, 1			; system call for write
	mov rdi, 1			; stdout file handle
	mov rsi, r10     		; string to output
	mov rdx, 1			; number of bytes to input
	syscall

	cmp r9, 0
	jne print_element

	mov rax, 1			; system call for write
	mov rdi, 1			; stdout file handle
	mov rsi, space     		; string to output
	mov rdx, 1			; number of bytes to input
	syscall

	add r8, 4			; get the next element
	inc r12				; increment the counter
	cmp r13, r12			; compare the counter to the size of the array
	jne convert_array_ascii

	ret				; ends the print_array function






