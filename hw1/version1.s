.data
left0:  .word 6
right0: .word 10
left1:  .word 10 
right1: .word 15
left2:  .word 20
right2: .word 100
str0:   .string "The total number of prime number of set bits is: "
str1:   .string "\n"
.text
main:
    lw s0, left0        # s0 = left0
    lw s1, right0       # s1 = right0
    li s2, 0            # s2 = ans = 0
    li s3, 0            # s3 = set_bit_cnt = 0
    li s4, 32           # s4 = 32
    jal ra, store_ra
    lw s0, left1
    lw s1, right1
    jal ra, store_ra
    lw s0, left2
    lw s1, right2
    jal ra store_ra
    j exit
store_ra:
    mv s11, ra          #store ra
loop_main:
    bgt s0, s1, print   #left > right , print ans
    mv t0, s0           # input left to my_clz
while:
    jal ra, my_clz
    beq a0, s4, is_prime    #clz_cnt == 32, check s3 is prime
    addi s3, s3, 1      #set_bit_cnt++
    addi a0, a0, 1      #clz_cnt++
    sll t0, t0, a0      #num = num << (clz_cnt+1);
    j while
        
my_clz:
    li t1, 0            # count = 0
    li t2, 31           # i = 31
clz_for:
    li t3, 1
    sll t3, t3, t2      # 1U << i
    and t4, t0, t3      # x & (1U << i)
    bne t4, x0, clz_done    # if (x == 0), exit loop
    addi t1, t1, 1      # count += 1
    addi t2, t2, -1     # --i
    bge t2, x0, clz_for # Repeat while i >= 0
clz_done:
    mv a0, t1
    jr ra

is_prime:
    li t0, 2            # t0 = 2
    blt s3, t0, false   # set_bit_cnt < 2, not a prime
prime_loop:
    li t1, 0            #count i*i
    li t3, 0            #counter for 0-i
mul:
    add t1, t1, t0      # t2 = t2 + i
    addi t3, t3, 1      # t3++
    bge t3,t0 , check_prime  #t3 = t0, finish i*i
    j mul
check_prime:
    bgt t1, s3, true    # i*i > a, return true
    mv t1, s3
mod:
    sub t1, t1, t0      # a = a - i
    bge t1, t0, mod     # a >= i, keep sub
    beqz t1, false      # a == 0, not prime
    addi t0, t0, 1      # i++
    j prime_loop
false:
    li s3, 0            # reset set_bit_cnt
    addi s0, s0, 1      # left++
    j loop_main         # another data
true:
    li s3, 0
    addi s2, s2, 1      # ans++
    addi s0, s0, 1
    j loop_main

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
    mv ra, s11          #back to main
    jr ra
exit:
    li a7, 10           # exit
    ecall