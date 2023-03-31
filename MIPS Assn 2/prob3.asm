# Group - 17
# Semester - 5
# Members :-
# Aditya Rishi Choudhary (20CS10005)
# Rishi Raj (20CS30040)

.globl main
.data
prompt1:
    .asciiz "Enter four positive integers m, n, a, r : "
error:
    .asciiz "Please enter numbers greater than zero"
newline:
    .asciiz "\n"
space:
    .asciiz " "
matrixA:
    .asciiz "The matrix A is : "
matrixB:
    .asciiz "The transpose of matrix A is : "
.text

main:
    # registers $t0, $t1, $t2, $t3 contain the given integers
    # taking the input from the user

    # printing the string
    li $v0, 4
    la $a0, prompt1
    syscall

    # m
    li $v0, 5
    syscall
    move $s0, $v0

    # n
    li $v0, 5
    syscall
    move $s1, $v0

    # a
    li $v0, 5
    syscall
    move $s2, $v0

    # r
    li $v0, 5
    syscall
    move $s3, $v0

    # performing sanity check on the numbers, if numbers are less than 1, then throw error as the numbers are supposed to be positive
sanity_check:
    li $t0, 1
    blt $s0, $t0, errorx
    blt $s1, $t0, errorx
    blt $s2, $t0, errorx
    blt $s3, $t0, errorx

# solution section of the problem
solution:
    jal initStack            # calling init stack
    mul $s4, $s0, $s1        # $s4 = m*n, the number of memory locations needed
    move $a0, $s4
    jal mallocInStack        # address of the starting location of the array is now stored in $v0
    move $s5, $v0            # address of the A array stored in $s5
    li $t0, 0                # counter for looping in the assign value section
    move $t1, $s2            # $t1 = a

assignValues:
    beq $s4, $t0, nextSection    # if t0 == mn, go the nextsection
    add $t0, $t0, 1          # increment counter
    sw $t1, 0($v0)           # move t1 to the memory pointed to by v0
    sub $v0, $v0, 4          # point to next memory in the stack
    mul $t1, $t1, $s3        # $t1 = $t1*r, that is the next term of the GP
    b assignValues

nextSection:
    move $a0, $s4            # a0 = mn, memory for B array
    jal mallocInStack
    move $s6, $v0            # starting address of the B array

    li $v0, 4
    la $a0, matrixA
    syscall

    move $a0, $s0            # $a0 = m
    move $a1, $s1            # $a1 = n
    move $a2, $s5            # $a2 = address of matrix A
    jal printMatrix

    move $a0, $s0            # $a0 = m
    move $a1, $s1            # $a1 = n
    move $a2, $s5            # $a2 = address of matrix A
    move $a3, $s6            # $a3 = address of matrix B
    jal transposeMatrix

    li $v0, 4
    la $a0, newline
    syscall

    li $v0, 4
    la $a0, matrixB
    syscall

    move $a0, $s1            # $a0 = n  , as it is transpose of A matrix hence n adn m are interchanged
    move $a1, $s0            # $a1 = m
    move $a2, $s6            # a2 = address of B matrix
    jal printMatrix

    # ending the program
exit:
    li $v0, 4
    la $a0, newline
    syscall

    # terminating the program
    li $v0, 10
    syscall
    
# for error handling
errorx:
    li $v0, 4
    la $a0, newline
    syscall
    
    li $v0, 4
    la $a0, error
    syscall

    li $v0, 4
    la $a0, newline
    syscall
    b main

initStack:
    la $sp, 0x7ffffffc       # initialising the stack and frame pointer to the maximum value
    la $fp, 0x7ffffffc
    jr $ra

pushToStack:
    sub $sp, $sp, 4          # decrement the stack pointer and move the value to it
    sw $a0, 0($sp)           # stack pointer points to the top value of the stack
    jr $ra

mallocInStack:
    move $t0, $sp            # moving the first address to $t0 register
    sub $t0, $t0, 4          # $t0 now points to the first empty memory location allocated for the array
    mul $a0, $a0, 4          # multiplying $a0 by 4 to get the number of bytes needed
    sub $sp, $sp, $a0        # decrementing the stack pointer by that value
    move $v0, $t0            # copying the first empty location address to $v0
    jr $ra

printMatrix:
    # m (rows) in $a0, n in $a1 (columns) and starting address of the array in $a2, we have to print the elements of the matrix in row major form
    li $t0, 0                # temp variables for running the loop for printing
    li $t1, 0   
    move $t2, $a0            # stores m
    move $t3, $a1            # stores n
loop1:
    beq $t0, $t2, return_from_fn   # if t0 == m, stop the outer loop
    li $t1, 0
    add $t0, $t0, 1                # increment the outer counter

    # add a line break
    li $v0, 4
    la $a0, newline
    syscall

loop2:
    beq $t1, $t3, loop1            # if t1 == n, stop the inner loop
    lw $s3, 0($a2)                 # load value in s3 to address pointer by $a2

    # print s3
    li $v0, 1
    move $a0, $s3
    syscall

    #print blank space
    li $v0, 4
    la $a0, space
    syscall

    sub $a2,$a2,4                  # point a2 to the next memory location
    add $t1,$t1,1                  # add 1 to the counter
    b loop2
return_from_fn:
    # print a blank line
    li $v0, 4
    la $a0, newline
    syscall
    jr $ra

# transposes the matrix
transposeMatrix:
    # $a0 for m, $a1 for n, $a2 for Address of matrix A and $a3 for address of Matrix B
    li $t0, 0        # temp registers for running the loops
    li $t1, 0

    move $t2, $a2    # address of A matrix
    move $t3, $a3    # address of B matrix

loop1_transpose:
    beq $t0, $a1, return_from_transpose     # if t0 == n, return from outer loop
    li $t1, 0
    add $t0, $t0, 1                         # increment the outer loop counter
    move $t4, $t2                           # copy the address from t2 to t4, address of the column
loop2_transpose:
    beq $t1, $a0, increment_addr            # if t1 == m, exit the outr loop
    lw $t5, 0($t4)                          # t5 = value contained by the address pointed to by t4
    sw $t5, 0($t3)                          # store the value in address pointed by t3
    sub $t3, $t3, 4                         # next memory of the B matrix
    mul $t6, $a1, 4                         # t6 contains number of bytes to skip to reach the next row in the same column
    sub $t4, $t4, $t6                       # next row of A matrix
    add $t1, $t1, 1                         # increment counter
    b loop2_transpose

increment_addr:
    sub $t2, $t2, 4                         # next column of A matrix
    b loop1_transpose

return_from_transpose:
    jr $ra
