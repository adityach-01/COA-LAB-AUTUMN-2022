# 64, 34, 25, 12, 22, 11, 9
# loading the words in the memory, start address in r0
# n
ld r2 7
# stack pointer
ld r25 100

ld r1 600
sw r1 0(r0)
addi r0 1

ld r1 34
sw r1 0(r0)
addi r0 1

ld r1 25
sw r1 0(r0)
addi r0 1

ld r1 12
sw r1 0(r0)
addi r0 1

ld r1 22
sw r1 0(r0)
addi r0 1

ld r1 11
sw r1 0(r0)
addi r0 1

ld r1 9
sw r1 0(r0)
addi r0 1
xor r0 r0

bl sort_array

# printing array
nop
ld r2 7
loop:
lw r1 0(r0)
addi r0 1
addi r2 -1
addi r1 0
bz r2 exit
b loop

exit:
addi r1 0
halt

# START OF FUNCTION
sort_array:
nop
move r10 r0       
nop
nop      
move r11 r2            
ld r12 0                   
addi r11 -1           
loop_outer:
nop
nop
beq r12 r11 next         
ld r13 0   
# r11 = n-1  r14 = n-i-1  r12 = i  r13 = j r11 = n-1          
move r14 r11
comp r12 r12
add r14 r12
comp r12 r12

loop_inner:
nop
beq r13 r14 update_i   

# loading the registers with the address of numbers for comparison
move r15 r13               
addi r15 1            
# s2 = arr[j]
lw r16 0(r13)    
# s3 = arr[j+1]          
lw r17 0(r15)          

comp r16 r16
add r17 r16
# call swap if arr[j] > arr[j+1] (r16 > r17)
bltz r17 call_swap
   
continue_inner:
nop
nop
addi r13 1        
b loop_inner

update_i:
nop
nop
addi r12 1
b loop_outer

call_swap:
nop
# saving the current value of $ra in the stack
sw r31 0(r25)
# addi r25 1      
bl swap
# addi r25 -1   
nop
lw r31 0(r25)
b continue_inner

next:
nop
br r31
# END OF FUNCTION


# START OF FUNCTION
swap:
nop
nop
lw r18 0(r13)
move r20 r13
addi r20 1
# r20 = j+1
lw r19 0(r20)
# swapping
sw r18 0(r20)
sw r19 0(r13)

br r31
# END OF FUNCTION





