.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# =================================================================
argmax:
	addi sp sp -8
	sw s0 0(sp)
    sw s1 4(sp)
    # Prologue
	beq a0 x0 exit
    ble a1 x0 exit
	j loop_start
exit:
    li a1 57
    call exit2

loop_start:
	add t0 x0 x0
    lw t1 0(a0)
	li t2 0
loop_continue:
	addi t0 t0 1
	bge t0 a1 loop_end
    slli s0 t0 2 
	add s1 s0 a0
    lw s0 0(s1)
    ble s0 t1 loop_continue
    mv t1 s0
    mv t2 t0
	j loop_continue
loop_end:
	mv a0 t2

    # Epilogue
    lw s0 0(sp)
    lw s1 4(sp)
	addi sp sp 8
    ret
