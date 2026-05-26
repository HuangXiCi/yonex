unsigned int __mulsi3(unsigned int a, unsigned int b)
{
	unsigned int r = 0;

	while (a && b) {
		if (b & 0xFFu) {
			if (b &   1u) r += a;
			if (b &   2u) r += a << 1;
			if (b &   4u) r += a << 2;
			if (b &   8u) r += a << 3;
			if (b &  16u) r += a << 4;
			if (b &  32u) r += a << 5;
			if (b &  64u) r += a << 6;
			if (b & 128u) r += a << 7;
		}
		a <<= 8;
		b >>= 8;
	}

	return r;
}
