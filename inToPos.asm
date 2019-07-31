.macro inToPos(%addrLine, %addrDes)
.text
		# $t0: luu dia chi dong truyen vao
		# $t1: co(flag) danh dau stack
		# $t2: ki tu doc duoc
		# $t3: dinh stack
		move $t0, %addrLine
		move $t1, $sp
		move $s5, %addrDes
	inToPos: 
		lb $t2, 0($t0) # $t2=s[0]
		beq $t2, 10, end_inToPos # $t2=='\n'
		beq $t2, '(', push_stack
		beq $t2, ')',close 
		beq $t2, '+',compare
		beq $t2, '-',compare
		beq $t2, '*',compare
		beq $t2, '/',compare
		jal is_Number
		beq $t2, 10, end_inToPos # $t2=='\n'
		bne $t2, 10, inToPos
		
	is_Number:
		sb $t2, 0($s5)
		addi $s5, $s5, 1

		addi $t0, $t0, 1 #s[i++]
		lb $t2, 0($t0)

		li $t6, 48
		li $t7, 57
		slt $t8, $t2, $t6
		bne $t8, $zero, end_Number
		slt $t8, $t7, $t2
		bne $t8, $zero, end_Number
		j is_Number

	end_Number:		
		li $t9, 32
		sb $t9, 0($s5)
		addi $s5, $s5, 1
		jr $ra

	push_stack:
		addi $sp, $sp, -1
		sb $t2, 0($sp)
		addi $t0, $t0, 1
		j inToPos
	compare:
		O($t2,$t4)
		beq $t1, $sp, stack_empty #neu stack rong ($sp=flag)
		lb $t3, 0($sp) #$t3 - dinh stack
		O($t3,$t5)
		slt $t6, $t4, $t5
		bne $t6, $zero, pop_stack
		beq $t4, $t5, pop_stack

		#neu do uu tien cua dinh stack nho hon ki tu dang doc thi push ki tu do vao stack
		slt $t6, $t5, $t4
		bne $t6, $zero, push_stack

	pop_stack:
		push_res($s5,$t3)
		addi $sp, $sp, 1
		beq $t1, $sp, stack_empty
	stack_empty:
		j push_stack

	close:
		lb $t3, 0($sp) #$t3 - pop dinh stack
		addi $sp, $sp, 1
		beq $t3,'(', continous
		push_res($s5,$t3)
		bne $t3,'(', close
		
	continous:
		addi $t0, $t0, 1
		j inToPos

	end_inToPos:
		beq $t1, $sp, end
		lb $t3, 0($sp) #$t3 - dinh stack
		push_res($s5,$t3)
		addi $sp, $sp, 1
		bne $t1, $sp, end_inToPos
		addi $s5, $s5, -1
		li $t3, 10
		sb $t3, 0($s5)
	end:
		delete_space()
		li $t3, 10
		sb $t3, 0($s5)
.end_macro
		
#------------------------------------------------#
.macro push_res(%addrRes, %addrCharacter)
.text
	sb %addrCharacter, 0(%addrRes)
	addi %addrRes, %addrRes, 1
	li $t9, 32
	sb $t9, 0(%addrRes)
	addi %addrRes, %addrRes, 1
.end_macro

#------------------------------------------------#
.macro O(%addr, %addrDes)
.text
		beq %addr, '+',o1 
		beq %addr, '-',o1 
		beq %addr, '*',o2 
		beq %addr, '/',o2
		beq %addr, '(',o3
	o1: 
		li %addrDes, 0 
		j end
	o2: 
		li %addrDes, 1
		j end
	o3: 
		li %addrDes, -1
		j end
	end:
.end_macro

#------------------------------------------------#
#xoa khoang trang thua
.macro delete_space()
.text
	addi $s3, $s5, -1
	lb $t3, 0($s3)
	bne $t3, 32, end
	addi $s5, $s5, -1
	end:
.end_macro