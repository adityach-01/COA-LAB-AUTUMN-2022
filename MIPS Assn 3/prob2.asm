.globl main
.data
array:
   .space 40
prompt1:
   .asciiz "Enter the 10 numbers : "
prompt2:
   .asciiz "Unsorted array is : "
prompt3:
   .asciiz "Sorted array is : "
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
   move $t0, $v0

   sw $t0, 0($t3)              # loading this value in $s1 at the appropriate menory address
   addi $t1, $t1, 1
   addi $t3, $t3, 4            # contains the address location of the next number loading location
   b loop

# we have loaded the numbers in the memory location heap
# now er have to load the register with the function arguments and then call sort subroutine

sort_begin:
   li $v0, 4
   la $a0, prompt2
   syscall

   # printing the unsorted array
   move $a0, $s0
   move $a1, $s1
   jal print_array

   # loading the arguments of the function call recursive_sort
   move $a0, $s0
   move $a1, $zero
   move $a2, $s1
   addi $a2, $a2, -1   

   jal recursive_sort

   # we have obtained the sorted array
   # we have to print it now
   li $v0, 4
   la $a0, prompt3
   syscall

   move $a0, $s0
   move $a1, $s1
   jal print_array

exit:
   li $v0, 4
   la $a0, newline
   syscall

   # terminating the program
   li $v0, 10
   syscall

# <-----------------------------------------------END OF MAIN SECTION-------------------------------------------->

# <-----------------------------START OF FUNCTION DEFINATIONS---------------------------------------------------->


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
initStack:
   la $sp, 0x7ffffffc       # initialising the stack and frame pointer to the maximum value
   la $fp, 0x7ffffffc
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