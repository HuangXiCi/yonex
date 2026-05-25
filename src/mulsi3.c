unsigned int __mulsi3(unsigned int a, unsigned int b)
{
    unsigned int r = 0;

    while (b) {
        if (b & 1u) {
            r += a;
        }

        a <<= 1;
        b >>= 1;
    }

    return r;
}
