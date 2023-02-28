.globl main
.data
array:
   .space 40
prompt1:
   .asciiz "Enter the 10 numbers : "
prompt2:
   .asciiz "Enter the key : "
display_corr:
    .asciiz " is FOUND in the array at index "
error_signal:
    .asciiz " NOT FOUND in the array."
display_arr:
    .asciiz "Sorted Array : "
white_space:
   .asciiz " "
newline:
   .asciiz "\n"

.text

main:
   la $s0, array              # contains starting address of the array
   li $s1, 10                 # value of n
   li $t1, 0                  # counter value
   move $t3, $s0
   jal initStack

   # printing the prompt
   li $v0, 4
   la $a0, prompt1
   syscall

loop:
   beq $t1, $s1, sort_begin

   li $v0, 5
   syscall
   move $t2, $v0

   sw $t2, 0($t3)              # loading this value in $s1 at the appropriate menory address
   addi $t1, $t1, 1
   addi $t3, $t3, 4            # contains the address location of the next number loading location
   b loop

# we have loaded the numbers in the memory location
# now er have to load the register with the function arguments and then call sort subroutine

sort_begin:

    # loading the arguments of the function call recursive_sort
    move $a0, $s0
    move $a1, $zero
    move $a2, $s1
    addi $a2, $a2, -1   
    jal recursive_sort

    # printing the sorted array
    # printing the label
    li $v0, 4
    la $a0, display_arr
    syscall

    # loading the arguments of the print_array function
    move $a0, $s0
    move $a1, $s1
    jal print_array

    # taking input of the key for searching
    li $v0, 4
    la $a0, prompt2
    syscall

    # value of key stored in $s2
    li $v0, 5
    syscall
    move $s2, $v0 

    # loading the arguments for the function search
    move $a0, $s0          # a0 <- address of the array
    move $a1, $zero        # a1 <- start = 0

    addi $t0, $s1, -1
    move $a2, $t0          # a2 <- end = 9

    move $a3, $s2          # a3 <- key
    jal recursive_search
    
    # answer is stored in $v0 register
    move $s5, $v0   

    # printing the answer on the console, as per the value of the answer
    li $v0, 1
    move $a0, $s2
    syscall

    li $t0, -1
    beq $s5, $t0, incorrect

    li $v0, 4
    la $a0, display_corr
    syscall

    li $v0, 1
    move $a0, $s5
    syscall

    b exit

incorrect:
    li $v0, 4
    la $a0, error_signal
    syscall

exit:
    li $v0, 4
    la $a0, newline
    syscall

    # terminating the program
    li $v0, 10
    syscall


# <-----------------------------END OF MAIN SECTION---------------------------------------------------->

# <------------------------FUNCTION DEFINATIONS START HERE--------------------------------------------->

# START OF FUNCTION
initStack:
    la $sp, 0x7ffffffc       # initialising the stack and frame pointer to the maximum value
    la $fp, 0x7ffffffc
    jr $ra
# END OF FUNCTION


# START OF FUNCTION
recursive_search:
    # setting up the stack
    sw $ra, 0($sp)
    addi $sp, $sp, -4

    sw $fp, 0($sp)
    addi $sp, $sp, -4

    sw $a0, 0($sp)
    addi $sp, $sp, -4

    sw $a1, 0($sp)
    addi $sp, $sp, -4

    sw $a2, 0($sp)
    addi $sp, $sp, -4

    move $fp, $sp

    sw $a3, 0($sp)
    addi $sp, $sp, -4

while_:
    lw $t0, 8($fp)   # t0 <- start
    lw $t1, 4($fp)   # t1 <- end

    bgt $t0, $t1, assign_val  # if start >  end, return -1

    # code after covering the base condition
compute:
    move $t2, $t0   # t2 = start, will store mid1
    move $t3, $t1   # t3 = end, will store mid2
    sub $t4, $t1, $t0   # t4 = end-start

    li $t5, 3
    div $t4, $t5         # (end-start)/3
    mflo $t4             # stores the integer value of the division

    add $t2, $t2, $t4    # t2 <- mid1
    sub $t3, $t3, $t4    # t3 <- mid2

    # $t4 will store A[mid1]
    # $t5 will store A[mid2]
    sll $t4, $t2, 2      # t4 <- mid1*4
    sll $t5, $t3, 2      # t5 <- mid2*4

    # loading the address of the array in $t6
    lw $t6, 12($fp)
    add $t4, $t4, $t6    # t4 <= &a[mid1]
    add $t5, $t5, $t6    # t5 <= &a[mid2]

    # loading the values
    lw $t4, 0($t4)
    lw $t5, 0($t5)

    # comparsion begins
    # $t6 contains the key
    lw $t6, 0($fp)

    beq $t6, $t4, return_mid1
    beq $t6, $t5, return_mid2

    blt $t6, $t4, funct1
    bgt $t6, $t5, funct2

    # loading the arguments of the last function call
    lw $t7, 12($fp)
    move $a0, $t7

    addi $t2, $t2, 1
    move $a1, $t2
    
    addi $t3, $t3, -1
    move $a2, $t3
    move $a3, $t6
    jal recursive_search

    b return_from_search

return_mid1:
    move $v0, $t2
    b return_from_search

return_mid2:
    move $v0, $t3
    b return_from_search

funct1:
    # loading the arguments of the function call
    lw $t7, 12($fp)
    move $a0, $t7

    move $a1, $t0
    
    addi $t2, $t2, -1
    move $a2, $t2

    move $a3, $t6
    jal recursive_search

    b return_from_search

funct2:
    # loading the arguments of the function call
    lw $t7, 12($fp)
    move $a0, $t7

    addi $t3, $t3, 1
    move $a1, $t3
    
    move $a2, $t1

    move $a3, $t6
    jal recursive_search

    b return_from_search

assign_val:
    li $v0, -1

return_from_search:
    lw $ra, 20($fp)
    lw $t0, 16($fp)
    move $fp, $t0
    # answer stored in $v0 already

    addi $sp, $sp, 24
    jr $ra

# END OF FUNCTION


# START OF FUNCTION
recursive_sort:
   # setting up the stack
   sw $ra, 0($sp)
   addi $sp, $sp, -4

   sw $fp, 0($sp)
   addi $sp, $sp, -4

   sw $a0, 0($sp)
   addi $sp, $sp, -4

   sw $a1, 0($sp)
   addi $sp, $sp, -4

   move $fp, $sp

   sw $a2, 0($sp)
   addi $sp, $sp, -4

begin:
   # setting up l,r and p variables
   # t0 <- l, t1 <- r, t2 <- p
   lw $t5, 4($fp)
   move $t0, $t5     # t0 <- left
   move $t2, $t5     # t2 <- left

   lw $t5, 0($fp)
   move $t1, $t5     # t1 <- right

   sw $t0, 0($sp)
   addi $sp, $sp, -4

   sw $t1, 0($sp)
   addi $sp, $sp, -4

   sw $t2, 0($sp)
   addi $sp, $sp, -4

while:
   bge $t0, $t1, return_from_sort  # if l >= r, return from function
loop1:
   # $t3 will store A[l] and $t4 will store A[p]
   # $t5 will store right, $t6 will store address of A
   lw $t5, 8($fp)
   move $t6, $t5

   lw $t5, 0($fp)   # t5 <- right

   move $t3, $t6
   move $t4, $t6

   sll $t7, $t0, 2
   add $t3, $t3, $t7   # t3 = &a[l]

   sll $t7, $t2, 2
   add $t4, $t4, $t7   # t4 = &a[p]

   # storing the values
   lw $t3, 0($t3)
   lw $t4, 0($t4)

   # stopping conditions
   bgt $t3, $t4, loop2
   bge $t0, $t5, loop2
   addi $t0, $t0, 1
   b loop1

loop2:
   # $t3 will store A[r] and $t4 will store A[p]
   # $t5 will store left, $t6 will store address of A
   lw $t5, 8($fp)
   move $t6, $t5    # address of the array

   lw $t5, 4($fp)   # t5 <- left

   move $t3, $t6
   move $t4, $t6

   sll $t7, $t1, 2
   add $t3, $t3, $t7   # t3 = &a[r]

   sll $t7, $t2, 2
   add $t4, $t4, $t7   # t4 = &a[p]

   # storing the values
   lw $t3, 0($t3)      # t3 = a[r]
   lw $t4, 0($t4)      # t4 = a[p]

   # stopping conditions
   bgt $t4, $t3, next_part   # if a[p] > a[r], break
   bge $t5, $t1, next_part   # if left >= r, break
   addi $t1, $t1, -1
   b loop2

next_part:
   blt $t0, $t1, last_part   # if l < r, go to last_aprt

   # updaing the values on the stack
   sw $t0, -4($fp)
   sw $t1, -8($fp)
   sw $t2, -12($fp)

   # call swap and recursive calls of the function
   lw $a0, 8($fp)
   move $a1, $t2
   move $a2, $t1
   jal swap

   # setting up arguments for recursive call 1
   lw $a0, 8($fp)
   lw $a1, 4($fp)

   lw $t1, -8($fp)
   addi $t1, $t1, -1
   move $a2, $t1
   jal recursive_sort

   # setting up argument for recursive call 2
   lw $a0, 8($fp)

   lw $t1, -8($fp)
   addi $t1, $t1, 1
   move $a1, $t1

   lw $a2, 0($fp)
   jal recursive_sort

   # returning from function
   b return_from_sort

last_part:
   lw $a0, 8($fp)
   move $a1, $t0
   move $a2, $t1
   jal swap
   b while

return_from_sort:
   lw $ra, 16($fp)
   lw $t0, 12($fp)
   move $fp, $t0

   addi $sp, $sp, 32
   jr $ra

# END OF FUNCTION


# START OF FUNCTION
print_array:
   move $t0, $a0       # t0 is the address of the array
   move $t1, $a1       # number of elements of the array

   # li $v0, 4
   # la $a0, newline
   # syscall

   li $t3, 0                  # counter for running the loop

print_loop:
   beq $t3, $t1, return_from_fn

   # print the number at the memory location
   lw $t2, 0($t0)
   li $v0, 1
   move $a0, $t2
   syscall

   # printing a white space
   li $v0, 4
   la $a0, white_space
   syscall

   # moving to the next memory location
   addi $t0, $t0, 4
   addi $t3, $t3, 1
   b print_loop

return_from_fn:
   li $v0, 4
   la $a0, newline
   syscall

   jr $ra

# END OF FUNCTION

# START OF FUNCTION
swap:
   # do not use $t0, $t1, $t2 registers
   move $t3, $a0    # address of the array
   move $t4, $a1    # 1st index
   move $t5, $a2    # 2nd index

   sll $t4, $t4, 2
   sll $t5, $t5, 2

   add $t6, $t3, $t4   # address of location 1
   add $t7, $t3, $t5   # address of location 2

   lw $t4, 0($t6)      # loading the values
   lw $t5, 0($t7)      # loading the values

   # storing the values at the other memory address
   sw $t4, 0($t7)
   sw $t5, 0($t6)

   jr $ra
# END OF FUNCTION
