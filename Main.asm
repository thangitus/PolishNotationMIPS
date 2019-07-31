.include "File.asm"
.include "inToPos.asm"
.include "calculator.asm"
.include "inToPre.asm"

#	$s0: buffer
#	$s1: one line
#	$s2: offset buffer
#	$s5: prefix.txt
#	$s6: postfix.txt 
#	$s7: result.txt
.data
	welcome: .asciiz "Polish Notation MIPS 1712758_1712682_1712677\n"
	start: .asciiz "PRESS OKE TO START"
	end_str: .asciiz "PRESS OKE TO EXIT"
	done: .asciiz "DONE!!!\n"
	buffer: .space 1024
	line: .space 1024
	result_line: .space 1024
.text
	la $s0, buffer
	la $s1, line
	la $s4, result_line
	read_file($s0,"input.txt")
	
.globl main
main:
		la $a0, welcome
		la $a1, start
		li $v0, 59
		syscall
		
		openWrite($s5,"prefix.txt")
		openWrite($s6,"posfix.txt")
		openWrite($s7,"result.txt")
		li $s2,0 #Do doi ban dau bang 0
	loop:
		getOneLine($s0,$s1,$s2)
		store_register($v0)
		store_register($s2)
		store_register($s1)#Luu tru dong vua doc
		store_register($s5)

		inToPos($s1,$s4)
		strLength($s4,$t1)
		writeOneLine($s6,$s4,$t1)
		
		calculator($s4,$t1)
		numToString($t1,$s4)
		strLength($s4,$t1)
		writeOneLine($s7,$s4,$t1)
		
		inToPre($s1,$s4)
		strLength($s4,$t1)
		load_register($s5)
		writeOneLine($s5,$s4,$t1)
		load_register($s1)
		load_register($s2)
		load_register($v0)
		bne $v0, $zero, loop
		beq $v0, $zero, end
	end:
		closeFile($s5)
		closeFile($s6)
		closeFile($s7)

		la $a0, done
		la $a1, end_str
		li $v0, 59
		syscall
		‭1111 1111 1111 1111 1111 1111 1111 1111‬