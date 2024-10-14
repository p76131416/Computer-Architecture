#include<stdio.h>
#include<stdlib.h>
#include<stdint.h>
#include<stdbool.h>

static inline int my_clz(uint32_t x) {
    int count = 0;
    for (int i = 31; i >= 0; --i) {
        if (x & (1U << i)){
            break;
        }
        count++;
    }
    return count;
}

bool is_prime(int a){
    if(a < 2){
        return false;
    }
    for(int i=2 ; i*i<=a ; i++){
        if(a%i == 0){
            return false;
        }
    }
    return true;
}

int main()
{
    int left = 10, right = 15, ans = 0, clz_cnt = 0;
    uint32_t num;
    for(int i=left ; i <= right ; i++){
        int set_bit_cnt = 0;
        num = (uint32_t)i;
        while((clz_cnt = my_clz(num)) != 32){     //if my_clz return 32, mean num == 0
            num = num << (clz_cnt+1);
            set_bit_cnt++;                        //count set bit
        }
        if(is_prime(set_bit_cnt)){
            ans++;
        }
    }
    printf("The total number of prime number of set bits is: %d ", ans);
    return 0;
}