# Group - 17
# Semester - 5
# Members :-
# Aditya Choudhary (20CS10005)
# Rishi Raj (20CS30040)

.globl main
.data
prompt1:
    .asciiz "Enter first number: "
prompt2:
    .asciiz "Enter second number: "
error:
    .asciiz "Please enter 16 bit numbers"
correct:
    .asciiz "The product of the numbers are : "
newline:
    .asciiz "\n"
.text

main:
    
    li $v0, 4
    la $a0, prompt1
    syscall
    # $s0 contains the first number (multiplicand) and $s1 contains the second number (multiplier)

    li $v0, 5
    syscall
    move $s0, $v0               # loading multiplicand

    li $v0 4
    la $a0, prompt2
    syscall

    li $v0, 5
    syscall
    move $s1, $v0               # loading multiplier


    # performing sanity check as number can only be 16 bit
    li $t0, 32767                # if the number entered is greater than this throw error
    li $t1, -32768               # if the number entered is smaller than this throw error
    bgt $s0, $t0, errorx         # if num1 > 32767, throw error
    bgt $s1, $t0, errorx         # if num2 > 32767, throw error
    blt $s0, $t1, errorx         # if num1 < -32768, throw error
    blt $s1, $t1, errorx         # if num2 < -32768, throw error

# performing a sign check, we are ensuring that the multiplier remains positive
# If the multiplier is negative, we flip the sign of both the multiplier and the multiplicand as that would not alter the answer
# else we go to the solve section
sign_check:
    li $t0,0
    blt $s1, $t0, flip_sign     # if multiplier is negative, flip sign
    b solve

flip_sign:
    not $s0,$s0                 # flipping the sign in 2s compliment of $s0 (multiplicand)
    addi $s0, $s0, 1

    not $s1, $s1                # flipping the sign in 2s compliment of $s1 (multiplier)
    addi $s1, $s1, 1

solve:
    # loading the registers with function arguments
    move $a0, $s0               # loading $a0 with multiplicand
    move $a1, $s1               # loading $a1 with multiplier
    jal multiply_booth          # calling the function
    move $t1, $v0               # storing the answer in $t1

# printing the answer
print_ans:     
    
    # printing the string line
    li $v0, 4
    la $a0, correct
    syscall

    # printing the answer as an integer
    li $v0, 1
    move $a0, $t1
    syscall

    # printing the newline character
    li $v0, 4
    la $a0, newline
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    # terminating the program
    li $v0, 10
    syscall


# program registers
# $s0 : M Multiplicand
# $s1 : Q Multiplier
# $t0 : Q-1 flag
# $t1 : final answer
# $t2 : Q0 flag
# $s2 : counter value
# $s3 : 0 constant value
# $s4 : 1 constant value

multiply_booth:
    move $s0, $a0                 # This is the multiplicand (M)
    move $s1, $a1                 # This is the multiplier   (Q)
    
find_ans:
    li $t1, 32767                 # $t1 = 0000000000000000 1111111111111111
    and $t1, $t1, $s1             # AQ is ready  $t1 = 0000000000000000 Q
    sll $s0, $s0, 16              # shifting M left by 16 to ensure addition and subtraction to A
    li $s2, 16                    # loading the counter by 16

    li $s3, 0                     # loading the temp registers for constant values
    li $s4, 1

    # loading the flags to decide the operation
    li $t0, 0                     # loading q-1 flag
    andi $t2, $t1, 1              # loading q0 flag (last digit of AQ)
    # $t0 (Q-1) and $t2 (Q0) decide the operation to be done

loop:
    beq $s2, $s3, compute         # if counter == 0, jump to compute
    addi $s2, $s2, -1             # decrementing the counter

    # deciding the operation to be done
    xor $t0, $t0, $t2              # loading the value in $t0, if this value is 0, then we shift right, else we add/ substract
    # Here we are xoring Q0 and Q-1, if xor is zero (11 or 00), we just shift right and update the flags, else we have to add substract
    beq $t0, $s3, shift_right      # if xor is zero, we shift right
    beq $t2, $s4, subtract         # else if, if Q0 == 1, we subtract A - M
    
    # here we add the Multiplicand
    add $t1, $t1, $s0              # else we add A + M
    b shift_right

subtract:
    sub $t1, $t1, $s0

shift_right:
    andi $t0, $t1, 1               # assigning the Q-1 flag
    sra $t1, $t1, 1                # arithmetic shifting the answer 
    andi $t2, $t1, 1               # loading the Q0 value
    b loop

# final label to print the answer, the answer is contained in the $t1 register in signed binary format
compute:
    move $v0, $t1
    jr $ra
  
# error function to display output in case an invalid number is entered
errorx:
    li $v0, 4
    la $a0, newline                # print a new line
    syscall
    
    li $v0, 4
    la $a0, error                  # display the error message
    syscall

    li $v0, 4
    la $a0, newline                 
    syscall
    b main



