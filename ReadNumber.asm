
.macro readNumber(%addr,%addrDes)
.data
	tmp: .space 1024
.text
	la $t5, tmp
	li $t6, 48
	li $t7, 57
loop:
	lb $t2, 0(%addr)
	slt $t8, $t2, $t6
	bne $t8, $zero, exit 
	slt $t8, $t7, $t2
	bne $t8, $zero, exit 
	
	sb  $t2, 0($t5)
	addi $t5, $t5, 1
	addi %addr, %addr, 1
	j loop
exit:
	li $t2, 10
	sb  $t2, 0($t5)
	#addi $t5, $t5, -1 #Lui $t5 lai vi gap khoang trang
	la $t5, tmp
	stringToNum($t5,%addrDes)
.end_macro

#------------------------------------------------#
#input: dia chi cua chuoi can chuyen, dia chi cua dich
.macro stringToNum(%addrText, %addrDes)
.text
	li $t6, 0 #res=0
	li $t4, 10
	
convert.loop:
	lb $t3, 0(%addrText)
	beq $t3, 10, convert.exit
	mult $t4, $t6 #res*10
	mflo $t6
	subi $t3, $t3, 48 #Digit
	add $t6, $t6, $t3 #Sum=Sum*10 + digit
	
	#str[i++]
	addi %addrText, %addrText, 1
	#Condition loop
	bne $t3, 10, convert.loop
convert.exit:
	move %addrDes, $t6
.end_macro

#------------------------------------------------#
.macro numToString(%addrNum, %addrDes)
.data 
		tmp: .space 1024
.text
		la %addrDes, tmp
		move $t3, %addrDes
		li $t8, 10

		move $t6, %addrNum #Dung $t6 de luu addrNum lai -> kiem tra no co phai so am hay ko
		slt $t4, %addrNum, $zero
		bne $t4, $zero, abs_addrNum
	loop_num:
		div %addrNum, $t8 
		mflo %addrNum
		mfhi $t9
		addi $t9, $t9, 48
		sb $t9, 0(%addrDes)
		addi %addrDes, %addrDes, 1
		beq %addrNum, $zero, end_num
		j loop_num
	end_num:
		#Neu so truyen vao la so am
		slt $t4, $t6, $zero
		bne $t4, $zero, negative
	positive:
		li $t9, 10
		sb $t9, 0(%addrDes)
		move %addrDes, $t3
		revertString(%addrDes)
		j end
	negative:
		jal add_45
		li $t9, 10
		sb $t9, 0(%addrDes)
		move %addrDes, $t3
		revertString(%addrDes)
		j end
	
	add_45: #Them dau tru sau chuoi roi revertString
		li $t9, '-'
		sb $t9, 0(%addrDes)
		addi %addrDes, %addrDes, 1
		jr $ra
	abs_addrNum:
		sub %addrNum, $0, %addrNum
		j loop_num
	end:

.end_macro
