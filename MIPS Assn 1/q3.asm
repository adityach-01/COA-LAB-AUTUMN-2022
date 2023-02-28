# This program takes in a number greater than or equal to 10 and tells whether the number is a prime number or a composite number

.globl main
.data

# defining the string output
prompt:
    .asciiz "Enter a positive integer greater than equal to 10 :"
error:
    .asciiz "Enter a number greater than 10."
prime:
    .asciiz "Entered number is a PRIME number."
comp:
    .asciiz "Entered number is a COMPOSITE number."
newline:
    .asciiz "\n"

    .text

# main section
# program variables
# $s0 : n
# $s1 : 10
# $t0 : contains value from 2 to n
# $t3 : 0
# $t4 : remainder of $s0 / $t0
# $t5 : $t0 * $t0

main:
    li $v0,4
    la $a0, prompt
    syscall

    li $v0,5
    syscall
    move $s0, $v0

    # comparator, branches to errorx if the entered number < 10
    li $s1, 10
    blt $s0,$s1,errorx

compute:
    li $t0, 2
    move $t1, $s0
    li $t3, 0
loop:
    beq $t0, $s0, prime_ans     # if $t5 > n, means no number divides n, hence it is a prime number
    div $t1, $t0                # divide n with $t0
    mfhi $t4                    # load the remainder in $t4
    beq $t4, $t3, comp_ans      # if remainder == 0, then the number is composite
    addi $t0, $t0, 1            # add 1 to $t0
    b loop                      # loop again

errorx:
    li $v0,4
    la $a0, error
    syscall

    li $v0,4
    la $a0, newline
    syscall
    b main

prime_ans:
    li $v0,4
    la $a0, prime              # prints the prime answer string
    syscall
    b endf

comp_ans:
    li $v0,4
    la $a0, comp               # prints the composite answer string
    syscall
    b endf

endf:
    # adds two line break
    li      $v0, 4         
    la      $a0, newline
    syscall
    li      $v0, 4
    la      $a0, newline
    syscall

    # terminates the program
    li      $v0, 10        
    syscall

