section .data
	my_array dd 6, 13, 55, 62, 126, 206
section .bss
	string_array resb 100
section .text
	global _start

_start:

	mov rcx, my_array		; load the address of the array to a register
	mov rdi, 6			; put the size of the array
	mov r8, 206			; put the value you want to search the array for

	mov r9, my_array		; set the left pointer
	mov rax, 4			; put 4 in rax because we need to multiply by 4
	mov r10, rdi
	dec r10				; get the size-1 which is the number of words between the first and last element
	mul r10				; get the number of bytes between first and last element to add to the left cursor,r9, to get the right cursor r10
	mov r10, my_array		; get the left pointer
	add r10, rax			; adding the number of bytes between first and last element in rax to the address in r10 gives the right pointer
	push rcx
	push rdi
	push r8
	call binary_search		; the function will return the index where the value is found in rax if no value found rax return -1
	pop r8
	pop rdi
	pop rcx

	call print_rax			; print the value in rax which tells where the value searched was found or has -1 if the value is not found



	mov rax, 60			; systemcall for ending program
	mov rdi, 0			; code for no error
	syscall


binary_search:

	mov r12, r10
	add r12, r9			; adding the left and right pointers, to get a pointer to the middle element
	mov rdx, 0			; put 0 in rdx to not act as a 128-bit register with rax
	mov rax, r12			; put addition of both pointers in rax because we will get the pointer to element between left and right pointers
	mov r12, 2			; we will divide by 2
	div r12				; rax contain the middle element pointer and rdi contains the remainder
	mov r12, rax			; middle pointer
	mov r13, 4			; we will divide by 4 to check if the middle pointer needs fixing if it is not word-aligned
	mov rdx, 0			; put 0 in rdx to not act with rax as a 128-bit register
	div r13				; rdi contains the value we want if it isnot equal zero we need to fix alignment

	cmp rdx, 0
	jne fix				; fix alignment

continue_your_life:

	mov r13d, [r12]			; get the value at the middle element
	cmp r9, r10
	je limit			; if both left and right pointers point to the same element this element is the last element if it is not the value searched then there is no value
	cmp r13, r8			; compare the value searched to the middle element
	jg left_branch
	jl right_branch
	je index

limit:
	cmp r13, r8
	je index
	jne no_index

left_branch:
	mov r10, r12 			; make our middle cursor the new right cursor
	call binary_search
	ret
right_branch:
	add r12, 4			; adding one element to not cover the same element twice in both branches
	mov r9, r12			; make the element to the right of the middle cursor be the new left pointer
	call binary_search
	ret

index:
	mov r14, r12			; get the address of the index at which the element is found
	sub r14, my_array		; get the number of bytes between the index address and the referrence address
	mov rax, r14			; we move these byte to rax since we are gonna divide them
	mov r14, 4
	div r14				; now rax contains the value of index that contains the value we will leave it that way according to the abi
	ret

fix:
	add r12, -2
	jmp continue_your_life

no_index:
	mov rax, -1
	ret



print_rax:
	mov r10, string_array
	mov r9, 0
convert_rax_ascii:

	mov rbx, 10			; we are going to divide by 10 to get the lsd in remainder and eliminate it from the number
	mov rdx, 0			; we set rdx to be 0 to prevent it and rax from forming a 128 bit register
	div rbx				; divide rax by rbx put the reminder in rdx and the quotient in rax

	add rdx, 48			; convert into ascii
	mov [r10], dl			; put the value of the digit into the register
	inc r10				; increment to store the next digit
	inc r9				; increment the number of digits counter

	cmp rax, 0
	jne convert_rax_ascii
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

	ret
