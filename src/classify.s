.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero,
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 72
    # - If malloc fails, this function terminates the program with exit code 88
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
	li t0 5
	bne t0 a0 argc_error
	addi sp sp -48
    sw a1 0(sp)
    sw a2 4(sp)
    sw s0 8(sp)
    sw s1 12(sp)
    sw s2 16(sp)
    sw s3 20(sp)
    sw s4 24(sp)
    sw s5 28(sp)
    sw s6 32(sp)
    sw s7 36(sp)
    sw ra 40(sp)
    sw s8 44(sp)
	# =====================================
    # LOAD MATRICES
    # =====================================
	
    # Load pretrained m0
	li a0 8
    call malloc
    beqz a0 malloc_error
	mv s0 a0 #pointer to memory contains # of matrix m0's cols and rows
    lw t0 0(sp)
    lw a0 4(t0)
    mv a1 s0
    addi a2 a1 4
    call read_matrix
    mv s1 a0 # pointer to matrix m0	


    # Load pretrained m1
	li a0 8
    call malloc
    beqz a0 malloc_error
	mv s2 a0 #pointer to memory contains # of matrix m1's cols and rows
    lw t0 0(sp)
    lw a0 8(t0)
    mv a1 s2
    addi a2 a1 4
    call read_matrix
    mv s3 a0 # pointer to matrix m1	

    # Load input matrix
	li a0 8
    call malloc
    beqz a0 malloc_error
	mv s4 a0 #pointer to memory contains # of matrix input's cols and rows
    lw t0 0(sp)
    lw a0 12(t0)    
    mv a1 s4
    addi a2 a1 4
    call read_matrix
    mv s5 a0 # pointer to matrix input	
	
	

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
	
    # h=m0 * input
	lw t0 0(s0)
    lw t1 4(s4)
	mul a0 t0 t1
    slli a0 a0 2
	call malloc
	beqz a0 malloc_error
	mv s6 a0 #result matrix h's pointer 
	mv a0 s1
	lw a1 0(s0)
	lw a2 4(s0)
	mv a3 s5
	lw a4 0(s4)
	lw a5 4(s4)
    mv a6 s6
	call matmul
	
	
    
    #h=relu(h)
    mv a0 s6
	lw t0 0(s0)
    lw t1 4(s4)
	mul a1 t0 t1    
    call relu
	
	
    
    # o=m1*h
	lw t0 0(s2)
    lw t1 4(s4)
	mul a0 t0 t1
    slli a0 a0 2
	call malloc
	beqz a0 malloc_error 
    mv s7 a0 #result matrix o's pointer
	mv a0 s3
	lw a1 0(s2)
	lw a2 4(s2)
	mv a3 s6
	lw a4 0(s0)
	lw a5 4(s4)
    mv a6 s7
	call matmul

	
    
    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
	lw t0 0(sp)
    lw a0 16(t0)
	mv a1 s7
	lw a2 0(s2)
    lw a3 4(s4)
    call write_matrix
	
	    

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0 s7
	lw t0 0(s2)
    lw t1 4(s4)
	mul a1 t0 t1
	call argmax
	mv s8 a0 
    

	
    # Print classification
	lw t0 4(sp)
	bnez t0 end
	mv a1 s8
	call print_int

    # Print newline afterwards for clarity
	li a1 '\n'
	call print_char
end:	
    mv a0 s0
    call free
    mv a0 s1
    call free
    mv a0 s2
    call free
    mv a0 s3
    call free
    mv a0 s4
    call free
    mv a0 s5
    call free
    mv a0 s6
    call free
    mv a0 s7
    call free
    
	
    mv a0 s8
    lw s0 8(sp)
    lw s1 12(sp)
    lw s2 16(sp)
    lw s3 20(sp)
    lw s4 24(sp)
    lw s5 28(sp)
    lw s6 32(sp)
    lw s7 36(sp)
    lw ra 40(sp)
    lw s8 44(sp)
	addi sp sp 48
	

    ret
argc_error:
	li a1 72
    call exit2
malloc_error:
	li a1 88
    call exit2