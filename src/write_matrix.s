.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 89
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 90
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 92
# ==============================================================================
write_matrix:
	addi sp sp -32
    sw ra 0(sp)
    sw a0 4(sp)
    sw a1 8(sp)
    sw a2 12(sp)
    sw a3 16(sp)
    sw s0 20(sp)
    sw s1 24(sp)
    sw s2 28(sp)
    # Prologue
    
    #open file
    mv a1 a0
    li a2 1
    call fopen
	li t0 -1
    beq t0 a0 fopen_error
    mv s0 a0 #file descriptor
    
    #write # of rows and cols to memory
    li a0 8
    call malloc
    beqz a0 malloc_error
    mv s1 a0 # pointer to the memory
    lw t0 12(sp)
    sw t0 0(a0)
    lw t0 16(sp)
    sw t0 4(a0) #write to memory
    
    #write # of rows and cols to memory
    mv a1 s0
    mv a2 s1
	li a3 2
	li a4 4
	call fwrite
	li t0 2
	bne a0 t0 fwrite_error
    
    #write data to file
    mv a1 s0
	lw a2 8(sp)
    lw t0 12(sp)
    lw t1 16(sp)
    mul a3 t0 t1
    mv s2 a3
    li a4 4
	call fwrite
    bne s2 a0 fwrite_error
    
    #close file
    mv a1 s0
    call fclose
    bnez a0 fclose_error

    # Epilogue
    lw ra 0(sp)
    lw s0 20(sp)
    lw s1 24(sp)
    lw s2 28(sp)
	addi sp sp 32

    ret
fopen_error:
	li a1 89
    call exit2
malloc_error:
	li a1 88
    call exit2
fwrite_error:
	li a1 92
    call exit2
fclose_error:
	li a1 90
    call exit2    