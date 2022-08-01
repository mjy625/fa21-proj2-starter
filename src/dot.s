.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 58
# =======================================================
dot:
	addi sp sp -8
    sw s0 0(sp)
    sw s1 4(sp)
    # Prologue
	ble a2 x0 exit_length
    ble a3 x0 exit_stride
    ble a4 x0 exit_stride

loop_start:
	li t0 0
    li t2 0



loop_continue:
	bge t0 a2 loop_end
	mul t1 t0 a3
    slli t1 t1 2
    add t1 t1 a0
    lw s0 0(t1)
    mul t1 t0 a4
    slli t1 t1 2
    add t1 t1 a1
    lw s1 0(t1)
    mul s0 s0 s1
	add t2 t2 s0
    addi t0 t0 1
    j loop_continue
loop_end:
	lw s1 4(sp)
	lw s0 0(sp)
    addi sp sp 8
    # Epilogue
	mv a0 t2

    ret
exit_length:
	li a1 57
    call exit2
exit_stride:
	li a1 58
    call exit2
    
