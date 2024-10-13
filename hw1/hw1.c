#include <stdio.h>
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
    for(int i=2 ; i*i<a ; i++){
        if(a%i){
            return false;
        }
    }
    return true;
}

int main()
{
    int left = 6, right = 10, set_bit_cnt = 0, ans = 0, clz_cnt = 0;
    uint32_t test;
    for(int i=left ; i <= right ; i++){
        set_bit_cnt = 0;
        printf("current i = %d\n", i);
        test = (uint32_t)i;
        while((clz_cnt = my_clz(test)) != 32){
            test = test << (clz_cnt+1);
            set_bit_cnt++;
        }
        printf("current cnt = %d\n",set_bit_cnt);
        if(is_prime(set_bit_cnt)){
            ans++;
        }
        printf("current ans = %d\n", ans);
    }
    printf("The total number of prime number of set bit is: %d ", ans);
    return 0;
}
