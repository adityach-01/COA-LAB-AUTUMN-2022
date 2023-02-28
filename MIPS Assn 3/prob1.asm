.globl main
.data
hello:
    .asciiz "HELLO\n"
prompt:
    .asciiz "Enter three positive integers (n, a, r and m) : "
matrix:
    .asciiz "The n x n matrix is : "
answer:
    .asciiz "Final determinant of the matrix A is : "
newline:
    .asciiz "\n"
space:
    .asciiz " "

.text
main:
    # $s0, $s1, $s2, $s3 contain the given 4 integers
    # printing the prompt string
    li $v0, 4
    la $a0, prompt
    syscall

    # n
    li $v0, 5
    syscall
    move $s0, $v0

    # a
    li $v0, 5
    syscall
    move $s1, $v0

    # r
    li $v0, 5
    syscall
    move $s2, $v0

    # m
    li $v0, 5
    syscall
    move $s3, $v0

sanity_check:
    jal initStack

    # loading the arguments of the function call form_matrix
    move $a0, $s0            
    move $a1, $s1
    move $a2, $s2
    move $a3, $s3
    jal form_matrix          # gives the start address of the array in $vo register
    move $s4, $v0            # $s4 is the starting address of the array

    # calling the printMatrix Function for printing the matrix

    move $a0, $s0            # n
    move $a1, $s4            # address of the array
    jal printMatrix

    # now computing the determinant of the matrix
    # loading the arguments
    move $a0, $s0   # contains the start address of the array
    move $a1, $s4   # contains the value of n


    jal determinant

    move $s5, $v0   # the value of the answer

    # printing the answer on the console
    li $v0, 4
    la $a0, answer
    syscall

    li $v0, 1
    move $a0, $s5
    syscall

exit:
    li $v0, 4
    la $a0, newline
    syscall

    # terminating the program
    li $v0, 10
    syscall

# <-------------------------------------------------------------------------------------------------->

# START OF FUNCTION
# overflow needs to be taken care of
form_matrix:
    # the start address of the array is the current value of the stack pointer
    # this function allocates the memory to the array in the stack
    # argument to the function are n,a,r,m
    # loading the arguments for mallocInStack
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    move $fp, $sp

    move $t0, $a0

    move $a0, $t0
    mul $a0, $a0, $a0
    jal mallocInStack

    move $t1, $a1            # $t1 = a
    move $t2, $a2            # $t2 = r
    move $a0, $t0
    mul $t0, $a0, $a0        # t0 = n*n
    li $t3, 0                # for loop counter
    move $t5, $v0
    
loop1_formMatrix:
    beq $t3, $t0, return_from_form
    # load $t1 in the memory location
    div $t1, $a3                # divide ar^n with m
    mfhi $t4                    # load the remainder in $t4, which is (ar^n)%m
    sw $t4, 0($t5)              # store the number at the approprite location
    addi $t5, $t5, 4            # increment the pointer to point to the next memory location
    mul $t1, $t1, $t2
    addi $t3, $t3, 1
    b loop1_formMatrix

return_from_form:
    lw $ra, 0($fp)
    jr $ra
    # start address of the matrix in $v0
# END OF FUNCTION


# START OF FUNCTION
printMatrix:
    # n (rows and columns) in $a0, n in $a1 (columns) and starting address of the array in $a1, we have to print the elements of the matrix in row major form
    li $t0, 0                # temp variables for running the loop for printing
    li $t1, 0   
    move $t2, $a0            # stores n
    move $t3, $a0            # stores n
    move $t4, $a1            # stores the address
loop1:
    beq $t0, $t2, return_from_fn   # if t0 == n, stop the outer loop
    li $t1, 0
    add $t0, $t0, 1                # increment the outer counter

    # add a line break
    li $v0, 4
    la $a0, newline
    syscall

loop2:
    beq $t1, $t3, loop1            # if t1 == n, stop the inner loop
    lw $s3, 0($t4)                 # load value in s3 to address pointer by $a2

    # print s3
    li $v0, 1
    move $a0, $s3
    syscall

    #print blank space
    li $v0, 4
    la $a0, space
    syscall

    addi $t4,$t4,4                  # point a2 to the next memory location
    add $t1,$t1,1                  # add 1 to the counter
    b loop2
return_from_fn:
    # print a blank line
    li $v0, 4
    la $a0, newline
    syscall

    jr $ra
# END OF FUNCTION


# START OF FUNCTION
initStack:
    la $sp, 0x7ffffffc       # initialising the stack and frame pointer to the maximum value
    la $fp, 0x7ffffffc
    jr $ra
# END OF FUNCTION


determinant:
    move    $t0, $ra    # store $ra temporarily
    jal     initStack   # initialise sp and fp
    move    $t1, $a0    # store n temporarily
    
    move    $a0, $t0    # push old ra to stack (fp-4)
    jal     pushToStack
    move    $a0, $s0    # push old s0 to stack (fp-8)
    jal     pushToStack
    move    $a0, $s1    # push old s1 to stack (fp-12)
    jal     pushToStack
    move    $a0, $s2    # push old s2 to stack (fp-16)
    jal     pushToStack
    move    $a0, $s3    # push old s3 to stack (fp-20)
    jal     pushToStack
    move    $a0, $s4    # push old s4 to stack (fp-24)
    jal     pushToStack
    move    $a0, $s5    # push old s5 to stack (fp-28)
    jal     pushToStack

    move    $s1, $a1    # store n in $s0
    move    $s0, $t1    # store A base address in $s1
    li      $s2, 0      # initial column index = 0

    # allocate memory for A'
    addi    $t0, $s0, -1    # $t0 = n - 1
    mul     $a0, $t0, $t0   # $a0 = (n-1)*(n-1)
    jal     mallocInStack   # call mallocInStack with argument (n-1)*(n-1)
    move    $s3, $v0        # store return value, i.e. base address of A' in $s3

    li      $s4, 0      # initialise current sum to 0
    li      $s5, 1      # initialise current sign to +1

    beq     $s0, 1 recursive_det_base_case

recursive_det_outer_loop:
    beq     $s2, $s0, recursive_det_return      # if column index == n then return

    move    $t0, $s3        # offset (for intermediate matrix A') = base address of A'
    li      $t1, 0          # current column = 0
    li      $t2, 1          # current row = 1

recursive_det_fill_loop:
    beq     $t1, $s2, recursive_det_fill_loop_next_col  # if current column == column index then move to next column
    
    mul     $t3, $t2, $s0   # $t3 = current row * n
    add     $t3, $t3, $t1   # $t3 = current row * n + current column
    mul     $t3, $t3, 4     # $t3 = 4*(current row * n + current column)
    add     $t3, $t3, $s1   # $t3 = A + 4*(current row * n + current column)
    lw      $t3, 0($t3)     # $t3 = A[current row][current column]
    
    sw      $t3, 0($t0)     # store it in A'

    addi    $t0, $t0, 4     # offset += 4

recursive_det_fill_loop_next_col:
    addi    $t1, $t1, 1                         # current column ++
    blt     $t1, $s0, recursive_det_fill_loop   # if current column < n then loop else move to next row

    li      $t1, 0                              # reset current column
    addi    $t2, $t2, 1                         # current row ++
    blt     $t2, $s0, recursive_det_fill_loop   # if current row < n then loop else calculate determinant of the generated intermediate matrix

    addi    $a0, $s0, -1                        # $a0 = n - 1
    move    $a1, $s3                            # $a1 = A' base address
    jal     determinant                       # call recursive_det with parameters n-1, A'

    mul     $t0, $s2, 4                         # $t0 = column index * 4
    add     $t0, $t0, $s1                       # $t0 = A + column index * 4
    lw      $t0, 0($t0)                         # $t0 = A[0][column index]
    mul     $t0, $t0, $v0                       # $t0 = Minor(0, column index) * A[0][column index]
    mul     $t0, $t0, $s5                       # $t0 = sign * Minor(0, column index) * A[0][column index]
    add     $s4, $s4, $t0                       # current sum += Cofactor(0, column index) * A[0][column index]
    mul     $s5, $s5, -1                        # sign = -sign

    addi    $s2, $s2, 1                         # column index ++
    b       recursive_det_outer_loop

recursive_det_base_case:
    lw      $s4, 0($s1)     # for n=1 answer is the single matrix element itself

recursive_det_return:
    addi    $t0, $s0, -1    # $t0 = n - 1
    mul     $t0, $t0, $t0   # $t0 = (n-1)*(n-1)
    mul     $t0, $t0, 4     # $t0 = 4*(n-1)*(n-1)
    add     $sp, $sp, $t0   # deallocate A'

    move    $t0, $s4        # temporarily store the sum to return

    jal     popFromStack
    move    $s5, $v0        # restore $s5
    jal     popFromStack
    move    $s4, $v0        # restore $s4
    jal     popFromStack
    move    $s3, $v0        # restore $s3
    jal     popFromStack
    move    $s2, $v0        # restore $s2
    jal     popFromStack
    move    $s1, $v0        # restore $s1
    jal     popFromStack
    move    $s0, $v0        # restore $s0
    jal     popFromStack
    move    $ra, $v0        # restore $ra

    move    $v0, $t0        # store the sum to return in $v0

    lw      $fp, 0($sp)     # restore frame pointer
    addi    $sp, $sp, 4     # restore stack pointer

    jr      $ra             # return


# malloc function
#
# function variables
#
# size: $a0
# return base address: $v0

mallocInStack:
    mul     $a0, $a0, 4
    sub		$sp, $sp, $a0   # sp = sp - (4*size), reserve space in stack
    move    $v0, $sp        # store the base address in $v0
    # addi $v0, $v0, 4
    jr      $ra
    
# push function
#
# function variables
#
# n: $a0

pushToStack:
    addi    $sp, $sp, -4    # make space for storing the new element
    sw      $a0, 0($sp)     # save the new element to stack
    jr      $ra

# pop function (returns the first element in stack and shifts the stack pointer)
#
# function variables
#
# -

popFromStack:
    lw      $v0, 0($sp)     # store the first element of stack as return value
    addi    $sp, $sp, 4     # pop it from the stack
    jr      $ra