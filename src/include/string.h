#ifndef __STRING_H_
#define __STRING_H_

void *memset(void *dest, int c, unsigned n)
{
	unsigned char *s = dest;
	for (; n; n--, s++) *s = c;
	return dest;
}

#endif