# This program takes in a number > 0 and tell whether the number is a PERFECT number or not.

.globl main
.data

# defining the stings to output in the program
prompt:
    .asciiz "Enter a positive number: "
yes:
    .asciiz "Entered number is a PERFECT number"
no:
    .asciiz "Entered number is not a PERFECT number"
error:
    .asciiz "Please enter a positive number"
newline:
    .asciiz "\n"

    .text

# main section of the program
# program variables
# $s0 : n
# $t0 : contains value from 1 to n
# $t1 : sum of the perfect divisors
# $t3 : 0
# $t2 : contains the remainder of the division
# $t3 : $t0*$t0

main:
    li $v0, 4
    la $a0, prompt
    syscall

    li $v0, 5                     # take input of the number
    syscall
    move $s0, $v0

    li $t0, 0                     # comparotor
    ble $s0, $t0, errorx          # if $s0 < 0, then go to the errorx section
    b compute

errorx:
    li $v0, 4
    la $a0, error
    syscall

    li $v0, 4
    la $a0, newline
    syscall
    b main

compute:
    li $t0, 0    # contains current number to check whether it a factor or not
    li $t1, 0    # this is the sum
    li $t3, 0    # constant
loop:
    addi $t0, $t0, 1               # increment current check number by 1          
    beq $t0, $s0, compare          # if $t3 >, means we need to compare the sum of divisors with n
    div $s0, $t0                   # divide n with the current number
    mfhi $t2                       # load the remainder in $t2
    beq $t2, $t3, add_num          # if remainder == 0, add the number to the sum $t1
    b loop                         # again

add_num:
    add $t1, $t1, $t0              # adds current factor to the factor sum
    b loop

compare:
    beq $s0, $t1, perfect          # comapre section
    li $v0, 4                      # if sum == the number, go to prefect section
    la $a0, no                     # else print, the number is not a prerfect number
    syscall
    b endf

perfect:                           # prints that the number is a perfect number
    li $v0, 4
    la $a0, yes
    syscall
    b endf

endf:
    li      $v0, 4          # print two newlines
    la      $a0, newline
    syscall
    li      $v0, 4
    la      $a0, newline
    syscall

    li      $v0, 10         # terminate the program
    syscall