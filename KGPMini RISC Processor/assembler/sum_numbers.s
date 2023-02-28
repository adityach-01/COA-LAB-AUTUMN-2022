nop
# 64, 34, 25, 12, 22, 11, 9
# loading the words in the memory, start address in r0
# n
ld r2 7
# stack pointer
ld r25 100

ld r1 64
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

bl sum_nos
addi r20 0
halt

sum_nos:
ld r20 0
loop:
lw r1 0(r0)
addi r0 1
addi r2 -1
add r20 r1
bz r2 exit
b loop

exit:
br r31