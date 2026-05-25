/* 32-bit unsigned divide: num / den */
unsigned int __udivsi3(unsigned int num, unsigned int den)
{
    unsigned int q = 0;
    unsigned int r = 0;

    if (den == 0) {
        return 0xffffffffu;
    }

    for (int i = 31; i >= 0; i--) {
        r = (r << 1) | ((num >> i) & 1u);

        if (r >= den) {
            r -= den;
            q |= (1u << i);
        }
    }

    return q;
}

/* 32-bit unsigned modulo: num % den */
unsigned int __umodsi3(unsigned int num, unsigned int den)
{
    unsigned int r = 0;

    if (den == 0) {
        return num;
    }

    for (int i = 31; i >= 0; i--) {
        r = (r << 1) | ((num >> i) & 1u);

        if (r >= den) {
            r -= den;
        }
    }

    return r;
}

/* 32-bit signed divide: num / den */
int __divsi3(int num, int den)
{
    unsigned int a;
    unsigned int b;
    unsigned int q;
    int neg = 0;

    if (den == 0) {
        return 0x7fffffff;
    }

    if (num < 0) {
        a = (unsigned int)(~((unsigned int)num) + 1u);
        neg = !neg;
    } else {
        a = (unsigned int)num;
    }

    if (den < 0) {
        b = (unsigned int)(~((unsigned int)den) + 1u);
        neg = !neg;
    } else {
        b = (unsigned int)den;
    }

    q = __udivsi3(a, b);

    if (neg) {
        return (int)(~q + 1u);
    }

    return (int)q;
}

/* 32-bit signed modulo: num % den */
int __modsi3(int num, int den)
{
    unsigned int a;
    unsigned int b;
    unsigned int r;
    int neg = 0;

    if (den == 0) {
        return num;
    }

    if (num < 0) {
        a = (unsigned int)(~((unsigned int)num) + 1u);
        neg = 1;
    } else {
        a = (unsigned int)num;
    }

    if (den < 0) {
        b = (unsigned int)(~((unsigned int)den) + 1u);
    } else {
        b = (unsigned int)den;
    }

    r = __umodsi3(a, b);

    if (neg) {
        return (int)(~r + 1u);
    }

    return (int)r;
}
