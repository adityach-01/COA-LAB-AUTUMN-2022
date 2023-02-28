.globl main
.data
array:
   .space 40
prompt1:
   .asciiz "Enter the 10 numbers : "
prompt2:
   .asciiz "Enter the value of k : "
error:
   .asciiz "Value of k must satisfy 1 <= k <= n"
correct:
   .asciiz "th largest number in the array is : "
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
   move $s2, $v0

   sw $s2, 0($t3)              # loading this value in $s1 at the appropriate menory address
   addi $t1, $t1, 1
   addi $t3, $t3, 4            # contains the address location of the next number loading location
   b loop

# we have loaded the numbers in the memory location
# now er have to load the register with the function arguments and then call sort subroutine
   
sort_begin:
   move $a0, $s0               # passing the address of the array
   move $a1, $s1               # passing the value of n
   jal sort_array              # calling the sort function

   # printing appropriate string
   li $v0, 4
   la $a0, prompt3
   syscall

   # we now have the sorted array in the memory location
   la $a0, array
   move $a1, $s1
   jal print_array

k_input:
   # taking the value of k
   li $v0, 4
   la $a0, prompt2
   syscall

   # $s3 contains the value of k
   li $v0, 5
   syscall
   move $s3, $v0

   # performing sanity check on k
   li $t0, 1
   blt $s3, $t0, errorx
   bgt $s3, $s1, errorx

   # after sanity check, we call the find_k_largest
   move $a0, $s0
   move $a1, $s1
   move $a2, $s3
   jal find_k_largest

   # result is stored in $v0
   # displaying the result
display_result:
   move $t0, $v0
   li $v0, 4
   la $a0, newline
   syscall

   li $v0, 1
   move $a0, $s3
   syscall

   li $v0, 4
   la $a0, correct
   syscall

   li $v0, 1
   move $a0, $t0
   syscall

   li $v0, 4
   la $a0, newline
   syscall

end_program:
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
   b k_input

# START OF FUNCTION
initStack:
   la $sp, 0x7ffffffc       # initialising the stack and frame pointer to the maximum value
   la $fp, 0x7ffffffc
   jr $ra
# END OF FUNCTION

# START OF FUNCTION
print_array:
   move $t0, $a0
   move $t1, $a1

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
sort_array:
   move $t0, $a0               # taking the address of the array
   move $t1, $a1               # taking the value of n
   li $t2, 0                   # i
   addi $t4, $t1, -1           # $t4 = n-1

loop_outer:
   beq $t2, $t4, next          # run the loop until i < n-1, if i == n-1, return from the function
   li $t3, 0                   # j
   move $t5, $t4               # $t5 = n-1
   sub $t5, $t5, $t2           # $t5 = n-i-1

loop_inner:
   beq $t3, $t5, update_i      # keep looping until j < n-i-1

   # loading the registers with the address of numbers for comparison
   move $t6, $t3               # t6 -> j 
   move $t7, $t3               # t7 -> j
   addi $t7, $t7, 1            # t7 -> j+1
   mul $t6, $t6, 4             # t6 -> 4*j
   mul $t7, $t7, 4             # t7 -> 4*(j+1)
   add $t6, $t6, $t0           # t6 -> 4*j + addr
   add $t7, $t7, $t0           # t7 -> 4*(j+1) + addr

   lw $s2, 0($t6)              # s2 = arr[j]
   lw $s3, 0($t7)              # s3 = arr[j+1]

   bgt $s2, $s3, call_swap     # call swap if arr[j] > arr[j+1]
continue_inner:
   addi $t3, $t3, 1           # j++
   b loop_inner

update_i:
   addi $t2, $t2, 1
   b loop_outer

call_swap:
   move $a0, $t6
   move $a1, $t7

   # saving the current value of $ra in the stack
   sw $ra, 0($sp)
   sub $sp, $sp, 4              # pushing in the stack
   jal swap

   addi $sp, $sp, 4             # popping from the stack and loading in the $ra register
   lw $ra, 0($sp)

   b continue_inner

next:
   jr $ra
# END OF FUNCTION


# START OF FUNCTION
swap:
   # $a0 and $a1 contains the address of the locations to be swapped
   lw $s2, 0($a0)
   lw $s3, 0($a1)
   sw $s2, 0($a1)
   sw $s3, 0($a0)

   jr $ra
# END OF FUNCTION


# START OF FUNCTION
find_k_largest:
   move $t0, $a0           # addr
   move $t1, $a1           # n
   move $t2, $a2           # k
   # if k = 1, return arr[n-1]
   # if k = n, return arr[0]
   # for general k, return arr[n-k]
   sub $t1, $t1, $t2       # t1 = n-k
   mul $t1, $t1, 4 
   add $t1, $t1, $t0
   lw $v0, 0($t1)

   jr $ra
# END OF FUNCTION
