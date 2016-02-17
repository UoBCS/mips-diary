# Binary search exercise
# Computer Systems Architecture - University of Birmingham
# ID: 1466610, username: oxe410

	.data
	.align 2
	
n1_msg: .asciiz "\nEnter a number: "
n2_msg:	.asciiz "\nEnter a number to search: "
y_msg:	.asciiz "\nYES"
n_msg:	.asciiz "\nNO"	
e_msg:	.asciiz "\nFinished successfully"	
cr:		.asciiz "\n"

	.text
	.globl main
	
main:
	# Counter
	li		$t0,0;
	
L1:	# Prompt for items
	li		$v0,4;
	la		$a0,n1_msg;
	syscall;
	
	# Read items
	# ----------------------
	li		$v0,5;
	syscall;
	add		$t1,$v0,$zero;
	beqz	$t1,L2;
	# ----------------------
	
	# Allocate memory and store item
	# ------------------------------
	li		$a0,4;
	li		$v0,9;
	syscall;
	sw		$t1,($v0);
	# ------------------------------
	
	bnez	$t0,STEND;
	add		$s0,$v0,$zero; # $s0 -> begin
	
STEND:
	addi	$t0,$t0,1;
	add		$s1,$v0,$zero; # $s1 -> end
	
EL1:	j L1;

	
L2:	# Prompt for search items
	li		$v0,4;
	la		$a0,n2_msg;
	syscall;
	
	# Read search items
	li		$v0,5;
	syscall;
	add		$t0,$v0,$zero;
	beqz	$t0,EXIT;
	
	# Call binarysearch using
	# a0 -> search item
	# a1 -> base address
	# a2 -> end address
	add 	$a0,$v0,$zero;
	add 	$a1,$s0,$zero;
	add		$a2,$s1,$zero;
	
	jal 	binarysearch;
	
	beqz	$v0,ELSE1;
	
	# Success
	li		$v0,4;
	la		$a0,y_msg;
	syscall;
	j 		EIF1;

# Failure
ELSE1:
	li		$v0,4;
	la		$a0,n_msg;
	syscall;
	
EIF1:
	li		$v0,4;
	la		$a0,cr;
	syscall;
	j L2;

EXIT:
	li		$v0,4;
	la		$a0,e_msg;
	syscall;
	
	li		$v0,10;
	syscall;

binarysearch:
	# Save to stack
	addi	$sp,$sp,-24;
	sw		$a0,20($sp);
	sw		$a1,16($sp);
	sw		$a2,12($sp);
	sw		$s0,8($sp);
	sw		$s1,4($sp);
	sw		$ra,0($sp);
	
	sub		$t0,$a2,$a1; # t0 <- Size of array
	bnez	$t0,REC;
	
	# Check if the only element in the array is in the array
	li 		$v0,1;		# Found
	lw 		$t0,($a1);
	beq 	$a0,$t0,RET;
	li 		$v0,0;		# Not found
	j	RET;
REC:	
	# Calculate midpoint
	div 	$t1,$t0,8;
	mul 	$t0,$t1,4;
	add		$t1, $a1, $t0;
	lw      $t2, ($t1);
	
	beq		$a0,$t2,RET;
	blt		$a0,$t2,LEFT;
	
RIGHT:
	addi	$a1,$t1,4;
	jal		binarysearch;
	j		RET;

LEFT:
	add		$a2,$t1,$zero;
	jal		binarysearch;

RET:
	lw		$a0,20($sp);
	lw		$a1,16($sp);
	lw		$a2,12($sp);
	lw		$s0,8($sp);
	lw		$s1,4($sp);
	lw		$ra,0($sp);
	addi 	$sp,$sp,24;
	jr 		$ra;
