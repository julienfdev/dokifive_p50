#define GPR1_ADDR ((volatile unsigned int*)0x30000000)

int main() {
    while (1) {
        unsigned int a = 0;
        unsigned int b = 1;
        for (int i = 0; i < 32; ++i) {
            unsigned int temp = a + b;
            a = b;
            b = temp;
            *GPR1_ADDR = b;
        }
        // After 20 iterations, reset and repeat
    }
    return 0;
}
