.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# ==============================================================================
relu:
    # Prologue
	li t0 1
    bge a1 t0 loop_start
	bne a0 x0 loop_start
	li a1 57
	call exit2
loop_start:
	add t0 x0 x0
    
loop_continue:
	bge t0 a1 loop_end
    slli t1 t0 2
    addi t0 t0 1
    add t1 a0 t1
    lw t3 0(t1)
    bge t3 x0 loop_continue
	sw x0 0(t1)
	j loop_continue
loop_end:


    # Epilogue


	ret
