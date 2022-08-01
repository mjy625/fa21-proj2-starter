.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 89
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 90
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91
# ==============================================================================
read_matrix:

    # Prologue
	addi sp sp -32
    sw a0 0(sp)
    sw a1 4(sp)
    sw a2 8(sp)
    sw ra 12(sp)
    sw s0 16(sp)
    sw s1 20(sp)
    sw s2 24(sp)
	sw s3 28(sp)
    
    #open file
	mv a1 a0
    li a2 0	
    jal fopen
    li t0 -1
    beq a0 t0 fopen_error
    mv s0 a0 # file descriptor
    
	# read 2 intergers
    mv a1 s0
    lw a2 4(sp) #read row
    li a3 4
    jal fread
    li a3 4
	bne a0 a3 fread_error
    
	mv a1 s0
    lw a2 8(sp) #read col
    li a3 4
    jal fread
    li a3 4
	bne a0 a3 fread_error	

	#allocate space
    lw t0 4(sp)
    lw t1 8(sp)
	lw t0 0(t0)
	lw t1 0(t1)
    mul a0 t0 t1
	slli a0 a0 2
    jal malloc
	beqz a0 malloc_error
    mv s1 a0 #address of matrix
    
    #read numbers
    lw t0 4(sp)
    lw t1 8(sp)  
	lw t0 0(t0)
	lw t1 0(t1)
	mv a1 s0
    mv a2 s1
    mul a3 t0 t1
    slli a3 a3 2
    mv s3 a3

    jal fread
    bne a0 s3 fread_error
    
    #close file
    mv a1 s0
    jal fclose
    bnez a0 fclose_error

    # Epilogue
	

    mv a0 s1
    lw a1 4(sp)
    lw a2 8(sp)
    lw ra 12(sp)
    lw s0 16(sp)
    lw s1 20(sp)
    lw s2 24(sp)
	lw s3 28(sp)
	addi sp sp 32
    
    ret
fopen_error:
	li a1 89
    call exit2
malloc_error:
	li a1 88
    call exit2
fread_error:
	li a1 91
    call exit2
fclose_error:
	li a1 90
    call exit2    