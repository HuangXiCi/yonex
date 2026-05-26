/* Find last set: position of highest set bit (0-31). x must be > 0. */
static int __fls(unsigned int x)
{
	int pos = 0;
	if (x & 0xFFFF0000u) { pos += 16; x >>= 16; }
	if (x & 0x0000FF00u) { pos += 8;  x >>= 8;  }
	if (x & 0x000000F0u) { pos += 4;  x >>= 4;  }
	if (x & 0x0000000Cu) { pos += 2;  x >>= 2;  }
	if (x & 0x00000002u) { pos += 1;  }
	return pos;
}

/* 32-bit unsigned divide: num / den */
unsigned int __udivsi3(unsigned int num, unsigned int den)
{
	if (den == 0)
		return 0xffffffffu;
	if (num < den)
		return 0;

	unsigned int q = 0;
	int dshift = __fls(num);
	int shift = __fls(den);

	for (int i = dshift - shift; i >= 0; i--) {
		if (num >= (den << i)) {
			num -= (den << i);
			q |= (1u << i);
		}
	}

	return q;
}

/* 32-bit unsigned modulo: num % den */
unsigned int __umodsi3(unsigned int num, unsigned int den)
{
	if (den == 0)
		return num;
	if (num < den)
		return num;

	int dshift = __fls(num);
	int shift = __fls(den);

	for (int i = dshift - shift; i >= 0; i--) {
		if (num >= (den << i))
			num -= (den << i);
	}

	return num;
}

/* 32-bit signed divide: num / den */
int __divsi3(int num, int den)
{
	unsigned int a;
	unsigned int b;
	unsigned int q;
	int neg = 0;

	if (den == 0)
		return 0x7fffffff;

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

	if (neg)
		return (int)(~q + 1u);

	return (int)q;
}

/* 32-bit signed modulo: num % den */
int __modsi3(int num, int den)
{
	unsigned int a;
	unsigned int b;
	unsigned int r;
	int neg = 0;

	if (den == 0)
		return num;

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

	if (neg)
		return (int)(~r + 1u);

	return (int)r;
}
