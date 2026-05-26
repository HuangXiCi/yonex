unsigned int __mulsi3(unsigned int a, unsigned int b)
{
	unsigned int r = 0;

	if (a == 0 || b == 0)
		return 0;

	do {
		if (b & 1u)
			r += a;
		if (b & 2u)
			r += a << 1;
		if (b & 4u)
			r += a << 2;
		if (b & 8u)
			r += a << 3;
		a <<= 4;
	} while (b >>= 4);

	return r;
}
