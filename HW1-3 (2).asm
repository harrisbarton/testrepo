# This file must not be made publicly available anywhere.
# =================================================================
#
# HW1-3
# Student Name: Harris Barton
# Date: 09/02/2020
#
# This program computes the next integer in a given sequence of integers and
# writes it to memory location labeled Result.  The sequence might be an
# arithmetic or geometric sequence.

# NOTE:
# The program should work on multiple test cases, not just the one provided.
# For full credit, be sure to document your code.

.data
# DO NOT change the following labels (you may only change the initial values):
LAddr:    .word  4
Seq:      .word  3, 9, 27, 81
Result:   .alloc 1
	
.text
# $1: Seq
# $2: 4*i/offset into array
# $3: i + 1 (or 4 in our case)
# $4: Next
# $5: Seq[0]
# $6: Seq[1]
# $7: Difference between the two
# $10: Holds difference betweem elements
# 15: Stores address of LAddr
# 16: holds value of LAddr
# 17: holds product of 4 and LAddr
# 18: storing value of 4*(Value of LAddr - 1)
# 19: stores address of last element of sequence
# 20: holding value of Seq[i]
# 21: holding value of Seq[i+1]
# 23 loading value of last element of sequence


		addi $1, $0, Seq # load base address of Seq
		addi $2, $0, 0   # initialize i to 0
		addi $3, $0, 4   # initialize i+1 to 4
		addi $4, $0, 0   # initialize Next to 0
		lw $5, 0($1)     # initializing Seq[0]
		lw $6, 4($1)     # initializing Seq[1]
		sub $7, $6, $5   # initializing the difference between first two elements
		addi $10, $0, 0  # initializing result of seq[i+1] - seq[i] to 0
		div $6, $5	 # dividing contents of first and second element 
		mfhi $12         # storing remainder (which will be 0 in a geometric sequence)
		mflo $13         # storing quotient (which is our ratio)
		addi $15, $0, LAddr # storing base address of LAddr
		lw $16, 0($15)   # loading value of LAddr into $16
		addi $16, $16, -1 # subtracting 1 by the value of LAddr
		addi $17, $0, 4   # storing 4 into $17
		mult $17, $16     # multiplying 4 by the value of LAddr
		mflo $18          # storing that value here
		add $19, $18 , $1 # storing base address of last element
		lw $23, 0($19)    # now accessing the value of the last element
		
		# LOOP: iterating through elements of Seq and checking whether sequence is arithmetic or geometric

Loop: 		addi $2, $2, 4   # iterating through ith element
		addi $3, $3, 4   # iteraring through i + 1 element
		lw $20, Seq($2)  # loading corresponding value of Seq[i]
		lw $21, Seq($3)  # loading corresponding value of Seq[i+1]
		sub  $10, $21, $20 # finding difference of neighboring values
		bne $10, $7, geometric	# if Seq[i+1] - Seq[i] != first difference, then branch to geometric
		beq $21, $23, Leave     # if we have reached last element, go to Leave
		j Loop                  # if neither of those things happened, keep looping :)
		

Leave:		add $4, $23, $10        # storing Next into $4 provided that sequence is arithmetic
		j Done
geometric:	mult $13, $23
		mflo $4                 #storing Next into $4 provided that sequence is geometric
Done:                jr $31   # return to OS


