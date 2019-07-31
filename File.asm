.macro read_file (%addr, %inf)
.data 
	file: .asciiz %inf	# file = %inf
.text
# open file
	li $v0, 13
	la $a0, file
	li $a1, 0
	li $a2, 0
	syscall
	move $t0, $v0  
# read file
	move $a0, $v0   
	li $v0, 14          
	la $a1, (%addr)       
	li $a2, 1024         
	syscall     
# close file
	li   $v0, 16       
	move $a0, $s0      
	syscall
.end_macro

#------------------------------------------------#
#Get one line, return:
#	$s1: one line
#	endFile: $v0=0 else $v0=1	

.macro getOneLine(%buffer, %oneLine, %offsetBuffer)
.text
	add $t0, %offsetBuffer, %buffer #Nhay den doan can lay
	la $t1, (%oneLine)
	li $t3, 0 #temp
get.loop:
	lb $t3, 0($t0) #tmp= buffer[i]
	beq $t3, 13, get.exit #neu xuong dong thi thoat
	beq $t3, 0, get.endFile #doc het (so sanh voi '\0')
	
	sb $t3, 0($t1) #str1[i] = tmp
	addi $t1, $t1, 1
 	addi $t0, $t0, 1 #Buffer[i++]
 	addi %offsetBuffer, %offsetBuffer, 1 #length one line ++
 	bne $t3, 0 get.loop
get.endFile:
	li $t3, 10
	sb $t3, 0($t1)
	li $v0, 0
	j end
get.exit:
	li $t3, 10
	sb $t3, 0($t1)
	addi %offsetBuffer, %offsetBuffer, 2
	li $v0, 1
	j end
end:

.end_macro

#------------------------------------------------#
.macro openWrite(%addr, %filename)
.data
	file: .asciiz %filename
.text
	#open file
	li $v0, 13
	la $a0, file
	li $a1, 1 #write
	li $a2, 0
	syscall	
	move %addr, $v0
.end_macro

#------------------------------------------------#
.macro closeFile(%addr)
.text
	li $v0, 16
	move $a0, %addr
	syscall
.end_macro

#------------------------------------------------#
.macro writeOneLine(%addrFileOut, %outputBuffer, %length)
.text
	li $v0, 15
	move $a0, %addrFileOut
	move $a1, %outputBuffer
	move $a2, %length
	syscall
.end_macro

#------------------------------------------------#
.macro strLength(%addr, %addrDes)
.text
	move $a0, %addr  
	li $t2, 0 
	loop:
		lb $t1, 0($a0) 
		beq $t1, 10, exit 
		addi $a0, $a0, 1
		addi $t2, $t2, 1 
		j loop
	exit:
	addi $t2, $t2, 1  #Them ki tu \n
	move %addrDes, $t2
.end_macro

#------------------------------------------------#
.macro store_register(%regeister)
.text
	addi $sp, $sp, -4
	sw %regeister, 0($sp)
.end_macro

.macro load_register(%regeister)
.text

	lw %regeister, 0($sp)
	addi $sp, $sp, 4
	
.end_macro