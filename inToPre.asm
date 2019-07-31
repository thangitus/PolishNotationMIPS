.macro inToPre(%addrLine, %addrDes)
.text
        revertString(%addrLine)

        move $t1, %addrLine
    loop_replace:
        lb $t2, 0($t1)
        beq $t2, 10, replace_end # $t2=='\n'
        beq $t2, '(', replace_close
		beq $t2, ')', replace_open
        addi $t1, $t1, 1
        j loop_replace
    replace_close:
        li $t2, 41
        sb $t2, 0($t1)
        addi $t1, $t1, 1
        j loop_replace
    replace_open:
        li $t2, 40
        sb $t2, 0($t1)
        addi $t1, $t1, 1
        j loop_replace
    replace_end:

        inToPos(%addrLine, %addrDes)
        revertString(%addrDes)
.end_macro

#------------------------------------------------#
#   $t1:    luu tmp

.macro revertString(%addrStr)
.data
        tmp: .space 1024
.text
        la $t1, tmp
        move $t3, $t1 #flag $t1
        move $t0, %addrStr #flag %addrStr

    #Vong lap nhay den cuoi Str
    loop_end:
        lb  $t2, 0(%addrStr)
        beq $t2, 10, end_str
        addi %addrStr,  %addrStr, 1
        j loop_end
    end_str:
        addi %addrStr,  %addrStr, -1
        j loop_copy
    
    loop_copy:
        lb  $t2, 0(%addrStr)
        sb $t2, 0($t1)
        addi $t1, $t1, 1
        subi %addrStr, %addrStr, 1
        slt $t4,  %addrStr, $t0
        bne $t4, $zero, end_copy
        j loop_copy
    end_copy:
        li $t2, 10
        sb $t2, 0($t1)
        move %addrStr, $t3       
.end_macro