nop
# program for finding nth fibonacci number
ld r0 1
ld r1 1
# n
ld r2 8
loop:
move r3 r1
add r1 r0
move r0 r3
addi r2 -1
bz r2 next
b loop
next:
addi r1 0
halt
