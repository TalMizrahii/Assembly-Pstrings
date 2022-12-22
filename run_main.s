

    .section	.rodata	   # Read only data section
	
formatS:		.string     "%s"
formatD:    	.string     "%d"

	########
	.text	
.globl	main	
	.type	main, @function	
main:

    pushq   %rbp				# Save the old frame pointer.
    movq    %rsp, %rbp 			# Set %rbp to %rsp's value.
	
    subq    $528, %rsp			# Allocate memory on the stack for pstring1, pstring2 and the choice of the client.
								# Aloocation 528 (more then needed) becouse it's a 16 multiplication.
	
	# receiving PS1 number:
	leaq    -528(%rbp), %rsi	# Loading the length of pstring1 (n1) to %rsi as second argument to scanf.
	movq    $formatD, %rdi		# Setting the format of the number (%d) to %rdi as first argument to scanf.
    xorq    %rax, %rax			# Clearing %rax.
    call    scanf				# Calling scanf.
	
	# receiving PS1 string:
    leaq    -527(%rbp), %rsi	# Loading the string of pstring1 to %rsi as second argument to scanf.
	movq    $formatS, %rdi		# Setting the format of the string (%s) to %rdi as first argument to scanf.
    xorq    %rax, %rax			# Clearing %rax.
    call    scanf				# Calling scanf.
	
	# Receiving PS2 number:
    leaq    -272(%rbp), %rsi	# Loading the length of pstring2 (n2) to %rsi as second argument to scanf.
	movq    $formatD, %rdi		# Setting the format of the number (%d) to %rdi as first argument to scanf.
    xorq    %rax, %rax			# Clearing %rax.
    call    scanf				# Calling scanf.
	
	# Receiving PS2 string:
	leaq    -271(%rbp), %rsi	# Loading the string of pstring2 to %rsi as second argument to scanf.
	movq    $formatS, %rdi		# Setting the format of the string (%s) to %rdi as first argument to scanf.
    xorq    %rax, %rax			# Clearing %rax.
    call    scanf				# Calling scanf.
	
	# Receiving the switch value:
	leaq    -16(%rbp), %rsi		# Loading the number of the choice to %rsi as second argument to scanf.
	movq    $formatD, %rdi		# Loading the format of the choice (%d) to %rdi as first argument to scanf.
    xorq    %rax, %rax			# Clearing %rax.
    call    scanf				# Calling scanf.
	
	# Clear all relevant registers.
	xorq	%rdi, %rdi
	xorq	%rsi, %rsi
	xorq	%rdi, %rdx
	
	# Pass caller arguments.
	leaq	-272(%rbp), %rdx	# Set PS2 to %rdx as third argument. 
	leaq	-528(%rbp), %rsi	# Set PS1 to %rsi as second argument.
	movl	-16(%rbp), %edi		# Set the choice to %edi as first argument.
	
	# Clear %rax and call func_select (where the switch case is).
	xorq	%rax, %rax
	call 	func_select
	
	# Restor the alocated space.
    addq    $528, %rsp
	
    #pop back %rbp and return
    xorq	%rax, %rax			# Clear %rax.
    movq	%rbp, %rsp			# Restore the old stack pointer - release all used memory.
    popq	%rbp				# Restore old frame pointer (the caller function frame).
    ret							# Return to caller function.
	
