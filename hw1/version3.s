.data
left0:  .word 6
right0: .word 10
left1:  .word 10
right1: .word 15
left2:  .word 20
right2: .word 100
prime:  .word 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 33
str0:   .string "The total number of prime number of set bits is: "
str1:   .string "\n"
.text
main:
    lw s0, left0        # s0 = left0
    lw s1, right0       # s1 = right0
    li s2, 0            # s2 = ans = 0     
    li s4, 32           # s4 = 32
    jal ra, loop_main
    lw s0, left1
    lw s1, right1
    jal ra, loop_main
    lw s0, left2
    lw s1, right2
    jal ra loop_main
    li a7, 10           # exit
    ecall
true:
    addi s2, s2, 1      # ans++
    addi s0, s0, 1
loop_main:
    li s3, 0            # s3 = set_bit_cnt = 0
    la a1, prime
    li a2, 12
    bgt s0, s1, print   # left > right , print ans
    mv t0, s0           # input left to my_clz
while:
    #my_clz
    srli t1, t0, 1      #x |= (x >> 1);
    or t2, t0, t1
    srli t1, t2, 2      #x |= (x >> 2);
    or t2, t2, t1
    srli t1, t2, 4      #x |= (x >> 4);
    or t2, t2, t1
    srli t1, t2, 8      #x |= (x >> 8);
    or t2, t2, t1
    srli t1, t2, 16     #x |= (x >> 16);
    or t2, t2, t1
    srli t1, t2, 1      #x -= ((x >> 1) & 0x55555555);
    li t3, 0x55555555
    and t1, t1, t3
    sub t2, t2, t1
    srli t1, t2, 2      #x = ((x >> 2) & 0x33333333) + (x & 0x33333333);
    li t3, 0x33333333
    and t1, t1, t3
    and t2, t2, t3
    add t2, t2, t1
    li t3, 0x0f0f0f0f   #x = ((x >> 4) + x) & 0x0f0f0f0f;
    srli t1, t2, 4
    add t2, t1, t2
    and t2, t2, t3
    srli t1, t2, 8      #x += (x >> 8);
    add t2, t2, t1
    srli t1, t2, 16     #x += (x >> 16);
    add t2, t2, t1
    li t3, 0x0000007f   #(32 - (x & 0x7f))
    and t2, t2, t3
    sub a0, s4, t2
    beq a0, s4, is_prime    #if clz_cnt == 32, check s3 is prime
    addi s3, s3, 1      #set_bit_cnt++
    addi a0, a0, 1      #clz_cnt++
    sll t0, t0, a0      #num = num << (clz_cnt+1);
    j while
is_prime:
    lw a3, 0(a1)
    addi a1, a1, 4
    addi a2, a2, -1
    beq s3, a3, true
    bgt s3, a3, is_prime
    #bge a2, x0, is_prime
    addi s0, s0, 1      # left++
    j loop_main         # another data
print:
    la a0, str0
    li a7, 4            # print str0
    ecall
    mv a0, s2
    li a7, 1            #print ans
    ecall
    la a0, str1
    li a7, 4            # print \n
    ecall
    li s2, 0            # s2 = ans = 0
    ret 