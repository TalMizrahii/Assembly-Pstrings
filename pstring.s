
    .section	.rodata	   # Read only data section	
rabak:			.string 	"|%d|\n"

invalid:		.string 	"invalid input!\n"
	########
	.text	#the beginnig of the code
	
#######################################################################################################################

	.globl	pstrlen
	.type	pstrlen, @function	
pstrlen:							# Given a pstring, returning it's length.
    pushq   %rbp					# Save the old frame pointer.
    movq    %rsp, %rbp 				# Set %rbp's to %rsp's value.
	
	xorq	%rax, %rax				# Clear %rax.
	movzbq	(%rdi), %rax			# Move the first byte of %rdi to %rax (where the length is located).
	
    movq	%rbp, %rsp				# Set the return value to zero.
    popq	%rbp					# Restore old frame pointer (the caller function frame).
    ret								# Return to caller function.
#######################################################################################################################


#######################################################################################################################

	.global replaceChar
    .type replaceChar, @function
	
# %rdi contains The pstring, %rsi and %rdx contains oldChar and newChar respectivley.
replaceChar: 						
	pushq   %rbp					# Save the old frame pointer.
    movq    %rsp, %rbp 				# Set %rbp's to %rsp's value.
	pushq	%rdi
		
	movq	%rdi, %rax				# Save the retun value to be the original *p to the pstring.
	movb	%sil, %r8b				# Save oldChar.	
	movb	%dl, %r9b				# Save newChar.
	
	xorq	%rcx, %rcx				# Clear %rcx.
	movb	(%rdi), %cl				# Set the length of the pstring to %rcx(will represent a counter).
	
	incq	%rdi					# Skip the length of the pstring.
	
   .loopStart:						# Start the loop.
    decq	%rcx					# decrease the counter (--i).
	js       .finish                # Checking if the loop counter in %rcx is negative. If so, exit the loop.
	cmpb	(%rdi), %r8b			# If its not, compare the current byte of the pstring to oldChar.
	je		.change					# If its a match, swap. otherwise, make another iteration.
	incq	%rdi					# Set the pointer to the next position (p++).
	jmp		.loopStart				# Go back to the start of the loop.
	
   .change:							# The swap lable.
    movb	%r9b, (%rdi)			# Set the newChar to the pointer's position on the string.
	incq	%rdi					# Increase the pointer's position (p++).
	jmp		.loopStart				# Go back to the start of the loop.
	
   .finish:    						# The finish label to exit the loop.
	popq	%rax					# Return the pinter to the pstring.
    movq	%rbp, %rsp				# Set the return value to zero.
    popq	%rbp					# Restore old frame pointer (the caller function frame).
    ret								# Return to caller function.

#######################################################################################################################


#######################################################################################################################
	.global pstrijcpy
    .type pstrijcpy, @function
	
# %rdi contains the dest pstring (PS1), %rsi contains the src pstring (PS2), %rdx contains i, %rcx contains j.
pstrijcpy:
	pushq   %rbp					# Save the old frame pointer.
    movq    %rsp, %rbp 				# Set %rbp's to %rsp's value.
	
	# Clear the indexes registers.
	xorq	%r8, %r8
	xorq	%r9, %r9
	pushq	%rdi					# Save the pointer's value in the stack.
	
	movb	%dl, %r8b				# Save i in %r8b.
	movb	%cl, %r9b				# Save j in %r9b.
	# In total, we check: 0 <= i <= j <= n1,n2
	cmpb	$0, %r8b				# Check if 0 <= i.
	js		.invalid				# If i < 0 return.
	
	cmpb	%r8b, %r9b				# Check if i <= j.
	js		.invalid				# If i < j return.
	
	xorq	%rax, %rax				# Clear %rax to store the len of PS1.
	movb	(%rdi), %al				# Move the len of PS1 to %rax.
	decq	%rax					# Decrease the len by 1 to match the array's indexes.
	
	cmpb	%r9b, %al				# Check if j <= n1 -1.
	js		.invalid				# If j > n1, return.
	
	xorq	%rax, %rax				# Clear %rax to store the len of PS2.
	movb	(%rsi), %al				# Move the len of PS2 to %rax.
	decq	%rax					# Decrease the length by 1 to match the array's indexes.
	
	cmpb	%r9b, %al				# Check if j <= n2 -1.
	js		.invalid				# If j > n2, return.
	jmp		.passTest				# If all tests passed, skip the "invalid" print and continue.
	
   .invalid:						# An "invalid" print label.
	movq	$invalid, %rdi			# Store the error message in %rdi.
	xorq	%rax, %rax				# Clear %rax.
	call	printf					# Call printf.
	jmp		.endFunc				# End the program.
	
   .passTest:						# Starting the swap.
    subb	%r8b, %r9b				# calculate %r9 to be the counetr, so calculate j - i.
	incq	%r9						# And add 1 the makeit the number of times the loop will run.
	incq	%rdi					# Increment %rdi (PS1 - dest, p++) to skip the length.
	incq	%rsi					# Increment %rsi (PS2 - src, p++) to skip the length.
	
	leaq	(%rdi, %r8), %rdi		# Set %rdi to %rdi + i.
	leaq	(%rsi, %r8), %rsi		# Set %rsi to %rsi + i.
	
   .loopL:							# The loop label.
    decq	%r9						# Decrease the counter (--i).
	js      .endFunc                # Checking if the loop counter in %rcx is negative. If so, exit the loop.
	xorq	%rax, %rax				# Clear %rax.
	movb	(%rsi), %al				# Put *p (dest) from in %al as temp. 
	movb	%al, (%rdi)				# Put %al as temp in *p (src).
	incq	%rdi					# Increment %rdi (PS1 - dest, p++).
	incq	%rsi					# Increment %rsi (PS2 - src, p++).
	jmp		.loopL
	
	.endFunc:						# End of function label.
	popq	%rax					# return the pointer to dest.
	movq	%rbp, %rsp				# Set the return value to zero.
    popq	%rbp					# Restore old frame pointer (the caller function frame).
    ret								# Return to caller function.
	
#######################################################################################################################


#######################################################################################################################
	.global swapCase
    .type swapCase, @function
	
# %rdi contains the pointer to the pstring.
swapCase:
	pushq   %rbp					# Save the old frame pointer.
    movq    %rsp, %rbp 				# Set %rbp's to %rsp's value.	
	pushq	%rdi					# Save the pointer's value in the stack.
	
	movq	%rdi, %r8				# Set %rdi to %r8.
	xorq	%r9, %r9				# Clear %r9.
	movb	(%r8), %r9b				# Set %r9 to the length of the pstring to use as a counter.
	incq	%r8						# Increment %r8 (p++) to skip the length.
	
   .startPoint:
    decq	%r9						# decrease the counter (--i).
	js      .finishFunc             # Checking if the loop counter in %r9 is negative. If so, exit the loop.
	
	cmpb	$122, (%r8)				# Check if *p > 122.
	ja		.rais					# If 122 < *p move to the next char.
	cmpb	$65, (%r8)				# Check if 65 > *P.
	jb		.rais					# If *p < 65 move to the next char.
	
	# Now, the char is in range of 65 - 122 (including).
	cmpb	$91, (%r8)				# Check if *p < 91.
	jb		.toLower				# If it is, it's an upper case char.
	cmpb	$96, (%r8)				# Check if *p > 97.
	ja		.toUpper				# If it is, it's a lower case char.
	#In this point, it's a char in between the lower and upper case letters.
	jmp		.rais					# If no match was found, go back to the iteration.
	
   .toLower:						# It's an upper case letter, so add 32 to make it lower case.
    addq	$32, (%r8)				# Add 32.
	jmp		.rais					# Go to raise.
	
   .toUpper:						# It's a lower case letter, so subtract 32 to make it uppeer case.
    subq	$32, (%r8)				# Subtract 32.
	jmp		.rais					# Go to rais.
	
   .rais:							# Increase the counter and return to the beginnig.
	incq	%r8						# Increment the pointer (p++).
	jmp		.startPoint				# Go back to the start of the loop.
	
   .finishFunc:						# The label of ending the function.
   
	popq	%rax					# Return the pointer of the pstring.
	movq	%rbp, %rsp				# Set the return value to zero.
    popq	%rbp					# Restore old frame pointer (the caller function frame).
    ret								# Return to caller function.

#######################################################################################################################


#######################################################################################################################
	.global pstrijcmp
    .type pstrijcmp, @function
		
# %rdi contains the first pstring (PS1), %rsi contains the second pstring (PS2), %rdx contains i, %rcx contains j.
pstrijcmp:
	pushq   %rbp					# Save the old frame pointer.
    movq    %rsp, %rbp 				# Set %rbp's to %rsp's value.
	
	# Clear the indexes registers.
	xorq	%r8, %r8
	xorq	%r9, %r9
	
	movb	%dl, %r8b				# Save i in %r8b.
	movb	%cl, %r9b				# Save j in %r9b.
	# In total, we check: 0 <= i <= j <= n1 - 1, n2 - 1.
	cmpb	$0, %r8b				# Check if 0 <= i.
	js		.invaliOption			# If i < 0 return.
	
	cmpb	%r8b, %r9b				# Check if i <= j.
	js		.invalid				# If i < j return.
	
	xorq	%rax, %rax				# Clear %rax to store the len of PS1.
	movb	(%rdi), %al				# Move the len of PS1 to %rax.
	cmpb	%r9b, %al				# Check if j <= n1.
	js		.invaliOption			# If j > n1, return.
	
	xorq	%rax, %rax				# Clear %rax to store the len of PS2.
	movb	(%rsi), %al				# Move the len of PS2 to %rax.
	cmpb	%r9b, %al				# Check if j <= n2.
	js		.invalid				# If j > n2, return.
	jmp		.passAll				# If all tests passed, skip the "invalid" print and continue.
	
   .invaliOption:					# An "invaliOption" print label.
	movq	$invalid, %rdi		# Store the error message in %rdi.
	xorq	%rax, %rax				# Clear %rax.
	call	printf					# Call printf.
	xorq	%rax, %rax				# Clear %rax.
	movq	$-2, %rax				# Put the invalid output (-2) to the return register (%rax). 
	jmp		.endFunction			# End the program.
	
   .passAll:
    subb	%r8b, %r9b				# calculate %r9 to be the counetr, so calculate j - i.
	incq	%r9						# And add 1 the makeit the number of times the loop will run. 
	# In total %r9 holds j - i + 1.
	incq	%rdi					# Increment %rdi (PS1 - first ps, p++) to skip the length.
	incq	%rsi					# Increment %rsi (PS2 - second ps, p++) to skip the length.
	
	leaq	(%rdi, %r8), %rdi		# Set %rdi to %rdi + i.
	leaq	(%rsi, %r8), %rsi		# Set %rsi to %rsi + i.
	xorq	%rax, %rax				# Clear %rax.
	
	
	.loopCmp:						# The loop label.
    decq	%r9						# Decrease the counter (--i).
	js      .resultSet              # Checking if the loop counter in %rcx is negative. If so, exit the loop.
	
	xorq	%rcx, %rcx				# Clear %rcx.
	addb	(%rdi), %cl				# Add the value of *p to %cl as temp.
	addq	%rcx, %rax				# Add the current char's value of PS1 to %rax.

	xorq	%rcx, %rcx				# Clear %rcx.
	addb	(%rsi), %cl				# Add the value of *p to %cl as temp.
	subq	%rcx, %rax				# subtract the current char's value of PS2 from %rax.
	
	incq	%rdi					# Increment %rdi (PS1 - dest, p++).
	incq	%rsi					# Increment %rsi (PS2 - src, p++).
	jmp		.loopCmp				# Go back to another iteration.
	
   .resultSet:
    cmpq	$0, %rax				# Check the result of the loop.
	je		.zero					# If the result is 0, return 0.
	js		.negative				# If the result is negative, return -1.
	
	movq	$1, %rax				# Else, it must be positive, return 1.
	jmp		.endFunction			# End the program.

   .negative:
    movq	$-1, %rax				# Put -1 in the return register.
	jmp		.endFunction			# End the program.
	
   .zero:							# Set the return register to 0.
    xorq	%rax, %rax
	
   .endFunction:					# End of function label.
	movq	%rbp, %rsp				# Set the return value to zero.
    popq	%rbp					# Restore old frame pointer (the caller function frame).
    ret								# Return to caller function.
	
	
