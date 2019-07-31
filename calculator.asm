.include "readNumber.asm"
.macro calculator(%addrPos, %addrDes)
.text
	#$t1: addrPos
	#$t2: result
	#$t3: ki tu doc $ra tu posfix
	#$t4, $t5: toan hang
	move $t1, %addrPos
loop:
	lb $t3, 0($t1) # $t3=s[0]
	beq $t3, 10, end_line # $t3=='\n'
	beq $t3, '+', calc_add
	beq $t3, '-', calc_sub
	beq $t3, '*', calc_mult
	beq $t3, '/', calc_div
	beq $t3, ' ', calc_space
	readNumber($t1, $t2)
	addi $sp, $sp, -4
	sw $t2, 0($sp)
	bne $t3, 10, loop # $t3!='\n'
calc_space:
	addi $t1, $t1, 1
	j loop
calc_mult:
	jal calc_pop_operand
	mult $t4, $t5
	mflo $t2
	j calc_push_stack
calc_div:
	jal calc_pop_operand
	div $t5, $t4
	mflo $t2
	j calc_push_stack
calc_add:
	jal calc_pop_operand
	add $t2, $t4, $t5
	j calc_push_stack
calc_sub:
	jal calc_pop_operand
	sub $t2, $t5, $t4
	j calc_push_stack
calc_pop_operand:
	lw $t4, 0($sp)
	addi $sp, $sp, 4
	lw $t5, 0($sp)
	addi $sp, $sp, 4
	jr $ra
calc_push_stack:
	addi $sp ,$sp, -4
	sw $t2, 0($sp)
	
	addi $t1, $t1, 1 #sau khi push vao stack thi tiep tuc lap
	j loop
end_line:
	lw $t2, 0($sp)
	addi $sp, $sp, 4
	move %addrDes, $t2
.end_macro