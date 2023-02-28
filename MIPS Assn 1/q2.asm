# this program takes two numbers as input from the user and prints out the GCD of the two given numbers

.globl main
.data

# defining the string labels that the program will output
prompt1:
    .asciiz "Enter the first positive integer: "
prompt2:
    .asciiz "Enter the second positive integer: "
result:
    .asciiz "GCD of the two positive integer: "
error:
    .asciiz "Enter number greater than 0"
newline:
    .asciiz "\n"

    .text

# main program
# program variables
# $s0 : a
# $s1 : b
# $t1 : 0
# $s3 : final answer

main:
    li $v0,4            # print string 1
    la $a0, prompt1
    syscall

    li $v0,5            # get 1st variable
    syscall
    move $s0, $v0
    
    li $v0,4            # print string 2
    la $a0, prompt2
    syscall

    li $v0,5            # get 2nd variable
    syscall
    move $s1, $v0

    # comparator function, goes to errorx if any of the variable is not positve
    li $t1,0
    blt $s1,$t1,errorx
    blt $s0,$t1,errorx
    b next

errorx:
    li $v0,4            # print string error
    la $a0, error
    syscall
    
    li      $v0, 4         
    la      $a0, newline
    syscall
    b main              # goes back to main

next:
    # $s0 = a and $s1 = b contains the two numbers for GCD calculation
    beq $t1,$s0,ans1

loop:
    beq $t1,$s1,ans2        # if b == 0, go to ans2
    bgt $s0,$s1,aupdate     # if a > b, go to aupdate
    sub $s1,$s1,$s0         # else b = b-a
    b loop                  # again

aupdate:
    sub $s0,$s0,$s1         # do a = a-b
    b loop

    # answer stored in $s3 register
ans1:
    move $s3,$s1            # final ans in $s1, put it in $s3
    b print_ans

ans2:
    # get out $s0 that is a
    move $s3,$s0

print_ans:
    li      $v0, 4          # print the string
    la      $a0, result
    syscall

    li      $v0, 1          # print the answer stor4ed in $s3 register
    move    $a0, $s3
    syscall

    # print two new lines
    li      $v0, 4         
    la      $a0, newline
    syscall
    li      $v0, 4
    la      $a0, newline
    syscall

    # terminate the program
    li      $v0, 10        
    syscall