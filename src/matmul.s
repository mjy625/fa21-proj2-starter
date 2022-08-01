.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 59
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 59
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 59
# =======================================================
matmul:
	ble a1 x0 exit
    ble a2 x0 exit
    ble a4 x0 exit
    ble a5 x0 exit
    bne a2 a4 exit
    # Error checks
	addi sp sp -32
	sw s0 0(sp)
    sw s1 4(sp)
	sw s2 8(sp)
    sw s3 12(sp)
	sw s4 16(sp)
    sw s5 20(sp)
	sw s6 24(sp)
    sw ra 28(sp)
    # Prologue
    mv s0 a0
    mv s1 a1
    mv s2 a2
    mv s3 a3
	mv s4 a4
    mv s5 a5
	mv s6 a6
#t0 : i
#t1 : j
#s0 : base_A, offset=i*col_A*4, stripe=1
#t2 : col_A*4
#s3 : base_b, offset=j*4, stripe=col_B
#col_B s5
	li t0 0
outer_loop_start:
	bge t0 s1 outer_loop_end
	li t1 0
inner_loop_start:
	bge t1 s5 inner_loop_end
	slli t2 s2 2
	mul t3 t2 t0
	add a0 s0 t3
	slli t3 t1 2
	add a1 s3 t3
	mv a2 s2
	li a3 1
	mv a4 s5
	addi sp sp -12
	sw t0 0(sp)
	sw t1 4(sp)
	sw t2 8(sp)
	jal dot
	lw t2 8(sp)
	lw t1 4(sp)
	lw t0 0(sp)
	addi sp sp 12
	mul t3 t0 s5
	add t3 t3 t1
	slli t3 t3 2
	add t3 t3 s6
	sw a0 0(t3)
	addi t1 t1 1
	j inner_loop_start
inner_loop_end:
	addi t0 t0 1
	j outer_loop_start
outer_loop_end:


    # Epilogue
	lw s0 0(sp)
    lw s1 4(sp)
	lw s2 8(sp)
    lw s3 12(sp)
	lw s4 16(sp)
    lw s5 20(sp)
	lw s6 24(sp)
    lw ra 28(sp)
    addi sp sp 32
    
    ret
exit:
	li a1 59
    call exit2