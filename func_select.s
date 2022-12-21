#206960890 Tal Mizrahi

    .section	.rodata	#read only data section
	

formatD:    		.string     	" %d"
formatChar:			.string			" %c"

formatDefault:    	.string     	"invalid option!\n"
formatStrlen:		.string			"first pstring length: %d, second pstring length: %d\n"
formatReplaceChar:	.string			"old char: %c, new char: %c, first string: %s, second string: %s\n"
formatPstrijcpy:	.string			"length: %d, string: %s\n"
formatCompare:		.string			"compare result: %d\n"


.align  8       #Align addreses to multiple of 8.
.jmpTbl:
    .quad   .case31     				# case 31.
    .quad   .case32     				# case 32.
    .quad   .case32     				# Case 33.
    .quad   .defaultCase     			# default case(34).
    .quad   .case35     				# case 35.
    .quad   .case36     				# case 36.
    .quad   .case37     				# case 37.

	########
	.text	
.globl	func_select					
	.type	func_select, @function	
	
func_select:				   			# %rsi contains PS1, %rdx contains PS2 and %rdi contains the client's choice. 

    pushq   %rbp	           			# Save the old frame pointer.
    movq	%rsp, %rbp	       			# Create the new frame pointer.
    	
    leaq    -31(%rdi), %rcx    			# %rdi had the conten of x, now we passed it to %rcx.
    cmpq    $7, %rcx    				# Check the cioce with 7 (the number of options).    
    ja      .defaultCase				# If an invalide choice was made, go to the default.
    jmp     *.jmpTbl(,%rcx,8)			# jump tp the valide option.
    
	
	
#######################################################################################################################
	
    # Case 31
   .case31:
    
    xorq	%r8, %r8					# Clear %r8.
	xorq	%r9, %r9					# Clear %r9.
	
    movq	%rsi, %rdi					# Move PS1 to %rdi as first argument.
	xorq    %rax, %rax					# Clear %rax.
	call	pstrlen						# Call pstrlen.
	movq	%rax, %r8					# Save the return value in %r8.
	
	movq	%rdx, %rdi					# Move PS2 to %rdi as first argument.
	xorq    %rax, %rax					# Clear %rax.
	call	pstrlen						# Call pstrlen.
	movq	%rax, %r9					# Save the return value in %r9.
	
	movq	%r8, %rsi					# Move %r8 (The result length of PS1) to %rsi as second argument to printf.
	movq	%r9, %rdx					# Move %r9 (The result length of PS2) to %rsi as third argument to printf.
    movq    $formatStrlen, %rdi			# Set the format of the result to %rdi as first argument to printf.
    xorq    %rax, %rax					# Clear %rax.
    callq    printf						# Call printf.
	
    jmp     .finish						# End of case, jump to return.
   
#######################################################################################################################
   
   
    # Case 32 or 33.
   .case32:
   
	pushq	%r12						# Save r12 as a callee function.
	pushq	%r13						# Save r13 as a callee function.
	
    movq	%rsi, %r12					# Save PS1 in %r12.
	movq	%rdx, %r13					# Save PS2 in %r13.
	subq	$16, %rsp					# Allocate space in the stack for two charecters (8 bytes each).
	
	# Scan the old char.
	leaq    -16(%rbp), %rsi				# Loading the first input (oldChar) to %rsi as second argument to scanf.
	movq    $formatChar, %rdi			# Loading the format (%c) as first argument to %rdi.
    xorq    %rax, %rax					# Clearing %rax.
    call    scanf						# Calling scanf.
	
	# Scan the new char.
	leaq    -8(%rbp), %rsi				# Loading the second input (newChar) to %rsi as second argument to scanf.
	movq    $formatChar, %rdi			# Loading the format (%c) as first argument to %rdi.
    xorq    %rax, %rax					# Clearing %rax.
    call    scanf						# Calling scanf.
	
	# Clear all relevant registers.
	xorq	%rdi, %rdi
	xorq	%rsi, %rsi
	xorq	%rdx, %rdx
	
	# Changing PS1 using replaceChar.
	movq	%r12, %rdi					# Move pstring1 to %rdi as first argument.
	movzbq	-16(%rbp), %rsi				# Move oldChar to %rsi as second argument.
	movzbq	-8(%rbp), %rdx				# Move newChar to %rdx as third argument.
    call  	replaceChar					# call replaceChar on pstring1.
	movq	%rax, %r12					# Store the result in %r12.
	
	# Clear all relevant registers.
	xorq	%rdi, %rdi				
	xorq	%rsi, %rsi				
	xorq	%rdx, %rdx				
	
	# Changing PS1 using replaceChar.
	movq	%r13, %rdi					# Move pstring2 to %rdi as first argument.
	movzbq	-16(%rbp), %rsi				# Move oldChar to %rsi as second argument.
	movzbq	-8(%rbp), %rdx				# Move newChar to %rdx as third argument.
	call  	replaceChar					# call replaceChar on pstring2.
	movq	%rax, %r13					# Store the result in %r13.
	
	# Clear all relevant registers.
	xorq	%rsi, %rsi
	xorq	%rdx, %rdx
	
	incq	%r12						# Skip the length.
	incq	%r13						# Skip the length.
	
	# Print the result.
	movq	$formatReplaceChar, %rdi	# Set the format to %rdi as first argument.
	movzbq	-16(%rbp), %rsi				# Set oldChar to %rsi as second argument.
	movzbq	-8(%rbp), %rdx				# Set newChar to %rdx as third argument.
	movq	%r12, %rcx					# Set pstring1 (after swap) to %rcx as fourth argument.
	movq	%r13, %r8					# Set pstring 2 (after swap) to %r8 as fifth argument.
	xorq	%rax, %rax					# Clear %rax.
	call	printf						# Call printf.
	
	popq	%r13						# Restore the value of %r13 as a callee function.
	popq	%r12						# Restore the value of %r12 as a callee function.
	
	addq	$16, %rsp					# Dealocate the stack space we used.

    jmp     .finish						# End of case, jump to return.
	
	
#######################################################################################################################

    # Case 35
   .case35:
    
	pushq	%r12						# Save r12 as a callee function.
	pushq	%r13						# Save r13 as a callee function.
	
    movq	%rsi, %r12					# Save PS1 in %r12.
	movq	%rdx, %r13					# Save PS2 in %r13.
	subq	$16, %rsp					# Allocate space in the stack for two charecters (8 bytes each).
	
	# Scan i.
	leaq    -16(%rbp), %rsi				# Loading the first input (i) to %rsi as second argument to scanf.
	movq    $formatD, %rdi				# Loading the format (%d) as first argument to %rdi.
    xorq    %rax, %rax					# Clearing %rax.
    call    scanf						# Calling scanf.
	
	# Scan j.
	leaq    -8(%rbp), %rsi				# Loading the second input (j) to %rsi as second argument to scanf.
	movq    $formatD, %rdi				# Loading the format (%d) as first argument to %rdi.
    xorq    %rax, %rax					# Clearing %rax.
    call    scanf						# Calling scanf.
	
	# Clear all relevant registers.
	xorq	%rsi, %rcx
	xorq	%rdx, %rdx
	
	movq	%r12, %rdi					# Set PS1 to %rdi as first argument.
	movq	%r13, %rsi					# Set PS2 to %rsi as second argument.
	movzbq	-16(%rbp),%rdx				# Set i to %rdx as third argument.
	movzbq	-8(%rbp),%rcx				# Set j to %rcx as fourth argument.
	xorq	%rax, %rax					# Clear %rax.
	call    pstrijcpy					# Call pstrijcpy.
	
	movq	$formatPstrijcpy, %rdi		# Set the case's format to %rdi.
	movzbq	(%rax), %rsi				# Set the length of dest (PS1) to %rsi.
	incq	%rax						# Skip the length.
	movq	%rax, %rdx					# Set the string of dest (PS1) to %rdx.
	xorq	%rax, %rax					# Clear %rax.
	call	printf						# Call printf.
	
	movq	$formatPstrijcpy, %rdi		# Set the case's format to %rdi.
	movzbq	(%r13), %rsi				# Set the length of src (PS2) to %rsi.
	incq	%r13						# Skip the length.
	movq	%r13, %rdx					# Set the string of src (PS2) to %rdx.
	xorq	%rax, %rax					# Clear %rax.
	call	printf						# Call printf.
	
	addq	$16, %rsp					# Dealocate the stack space we used.
	popq	%r13						# Restore the value of %r13 as a callee function.
	popq	%r12						# Restore the value of %r12 as a callee function.
	
    jmp     .finish						# End of case, jump to return.
   
#######################################################################################################################
    # Case 36
   .case36:
   
	pushq	%r12						# Save r12 as a callee function.
	pushq	%r13						# Save r13 as a callee function.
   
    xorq	%r12, %r12					# Clear %r12.
	xorq	%r13, %r13					# Clear %r13.
	movq	%rsi, %r12					# Move PS1 to %r12
	movq	%rdx, %r13					# Move PS2 to %r13.
	
	movq	%r12, %rdi					# Move PS1 to %rdi as first argument.
	xorq	%rax, %rax					# Clear %rax.
	call	swapCase
	movq	%rax, %r12					# Set the result in %r12.
	
	movq	%r13, %rdi					# Move PS1 to %rdi as first argument.
	xorq	%rax, %rax					# Clear %rax.
	call	swapCase
	movq	%rax, %r13					# Set the result in %r12.
	
	xorq	%rsi, %rsi					# Clear %rsi.
	movq	$formatPstrijcpy, %rdi		# Set the case's format to %rdi.
	movzbq	(%r12), %rsi				# Set the length of PS1 to %rsi.
	incq	%r12						# Skip the length.
	movq	%r12, %rdx					# Set the string of PS1 to %rdx.
	xorq	%rax, %rax					# Clear %rax.
	call	printf						# Call printf.
		
	xorq	%rsi, %rsi					# Clear %rsi.
	movq	$formatPstrijcpy, %rdi		# Set the case's format to %rdi.
	movzbq	(%r13), %rsi				# Set the length of PS2 to %rsi.
	incq	%r13						# Skip the length.
	movq	%r13, %rdx					# Set the string of PS2 to %rdx.
	xorq	%rax, %rax					# Clear %rax.
	call	printf						# Call printf.
	
	popq	%r13						# Restore the value of %r13 as a callee function.
	popq	%r12						# Restore the value of %r12 as a callee function.
	
    jmp     .finish						# End of case, jump to return.

#######################################################################################################################


    # Case 37
   .case37:
   
    pushq	%r12						# Save r12 as a callee function.
	pushq	%r13						# Save r13 as a callee function.
   
    xorq	%r12, %r12					# Clear %r12.
	xorq	%r13, %r13					# Clear %r13.
	movq	%rsi, %r12					# Move PS1 to %r12
	movq	%rdx, %r13					# Move PS2 to %r13.
	
	subq	$16, %rsp					# Allocate space in the stack for two numbers (8 bytes each).
    
	
	# Scan the first number (i).
	leaq    -16(%rbp), %rsi				# Loading the first input (i) to %rsi as second argument to scanf.
	movq    $formatD, %rdi				# Loading the format (%d) as first argument to %rdi.
    xorq    %rax, %rax					# Clearing %rax.
    call    scanf						# Calling scanf.
	
	# Scan the second number (j).
	leaq    -8(%rbp), %rsi				# Loading the second input (j) to %rsi as second argument to scanf.
	movq    $formatD, %rdi				# Loading the format (%d) as first argument to %rdi.
    xorq    %rax, %rax					# Clearing %rax.
    call    scanf						# Calling scanf.
	
	# Clear all relevant registers.
	xorq	%rsi, %rcx
	xorq	%rdx, %rdx
	
	movq	%r12, %rdi					# Set PS1 to %rdi as first argument.
	movq	%r13, %rsi					# Set PS2 to %rsi as second argument.
	movzbq	-16(%rbp),%rdx				# Set i to %rdx as third argument.
	movzbq	-8(%rbp),%rcx				# Set j to %rcx as fourth argument.
	xorq	%rax, %rax					# Clear %rax.
	call	pstrijcmp					# Call pstrijcmp.
	
	movq	$formatCompare, %rdi		# Set the case's format to %rdi.
	movq	%rax, %rsi					# Set the return value of pstrijcmp to %rsi.
	xorq	%rax, %rax					# Clear %rax.
	call	printf						# Call printf.
	

	addq	$16, %rsp
	popq	%r13						# Restore the value of %r13 as a callee function.
	popq	%r12						# Restore the value of %r12 as a callee function.
	
    jmp     .finish						# End of case, jump to return.

#######################################################################################################################
   
    # Default case.
   .defaultCase:
	movq    $formatDefault, %rdi		# Put the default format in %rdi.
	xorq    %rax, %rax					# Clear %rax.
	callq    printf						# Call printf.
	
	
	###########################################################################################################

   .finish:

    #return from printf:
    movq	   $0, %rax					# Return value is zero (just like in c - we tell the OS that this program finished seccessfully)
    movq	   %rbp, %rsp				# Restore the old stack pointer - release all used memory.
    popq	   %rbp						# Restore old frame pointer (the caller function frame)
    ret									# Return to caller function.
	