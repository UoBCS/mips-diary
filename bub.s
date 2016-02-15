# Bubble sort exercise
# Computer Systems Architecture - University of Birmingham
# ID: 1466610, username: oxe410

	.data
	.align 2
	
nm_msg:	.asciiz "\nEnter the number of items to sort: "
it_msg:	.asciiz "\nEnter a number: "
dn_msg:	.asciiz "\nFinished. Sorted list:\n"
space:	.asciiz	"  "
cr:	.asciiz "\n"
	
	.text
	.globl main

main:
	# Prompt for number of items
	li 	$v0,4;
	la 	$a0,nm_msg;
	syscall;
	
	# Read number of items ($s0 = n)
	li 	$v0,5;
	syscall;
	move 	$s0,$v0;
	
	# Create space in heap (address stored in $s1)
	mul 	$a0,$s0,4;
	li 	$v0,9;
	syscall;
	move 	$s1,$v0;
	
	li 	$t0,0;
L1:	sub 	$t1,$t0,$s0;
	bgez 	$t1,EL1;
	
	# Prompt for item
	li 	$v0,4;
	la 	$a0,it_msg;
	syscall;
	
	# Read item
	li 	$v0,5;
	syscall;
	
	# Store item
	li 	$t2,4;
	mul 	$t2,$t0,$t2;
	add 	$t3,$s1,$t2;
	sw 	$v0,($t3);
	addi 	$t0,$t0,1;
	j 	L1;
EL1:	nop;

	# Load arguments (n and array)
	move 	$a0,$s0;
	move 	$a1,$s1;
	jal 	BUB; # Perform bubble sort
	
	# Done message + print result
	li	$v0,4;
	la	$a0,dn_msg;
	syscall;

	li 	$t0,0;
L2:	sub	$t1,$t0,$s0;
	bgez	$t1,EL2;
	
	li 	$t2,4;
	mul 	$t2,$t0,$t2;
	add 	$t3,$s1,$t2;
	lw 	$t4,($t3);
	
	li	$v0,1;
	move	$a0,$t4;
	syscall;
	
	li	$v0,4;
	la	$a0,space;
	syscall;
	
	addi 	$t0,$t0,1;
	j 	L2;
	
EL2: 	nop;

	# Clean exit
	li 	$v0,10;
	syscall;

BUB:	# Saving registers to stack
	# I'm not saving $ra since I don't call any functions
	# I'm not saving $a0 and $a1 since this is not a recursive function
	addi 	$sp,$sp,-28;	
	sw 	$s0,24($sp);
	sw 	$s1,20($sp);
	sw 	$s2,16($sp);
	sw 	$s3,12($sp);
	sw 	$s4,8($sp);
	sw 	$s5,4($sp);
	sw 	$s6,0($sp);
	
	#li	$s0,0; # swapped = false
BL1:	addi	$t0,$a0,-1; # n - 1
	beqz	$s0,EBUB;
	li 	$s0,0;		# swapped = false
	
	li	$s1,1;	# i = 1
BL2:	sub 	$t2,$s1,$t0;
	bgtz	$t2,BEL1;
	
	# Load a[i - 1] in $s5
	li	$s2,4;
	addi	$s3,$s1,-1;
	mul	$s2,$s3,$s2;
	add	$s4,$a1,$s2;
	lw	$s5,($s4);
	
	# Load a[i] in $s6
	li	$s2,4;
	mul	$s2,$s1,$s2;
	add	$s3,$a1,$s2;
	lw	$s6,($s3);
	
	ble	$s5,$s6,BEL2;
	
	# Swap
	sw	$s5,($s3);
	sw	$s6,($s4);
	
	li	$s0,1; # swapped = true

BEL2:	addi	$s1,$s1,1;
	j	BL2;

BEL1:	addi	$a0,$a0,-1;
	j	BL1;

EBUB:	lw 	$s0,24($sp);
	lw 	$s1,20($sp);
	lw 	$s2,16($sp);
	lw 	$s3,12($sp);
	lw 	$s4,8($sp);
	lw 	$s5,4($sp);
	lw 	$s6,0($sp);
	addi	$sp,$sp,28;
	jr 	$ra;
