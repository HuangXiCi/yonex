#ifndef __IO_H_
#define __IO_H_

static inline volatile char inb(unsigned addr) { return *(volatile char *)addr; }
static inline void outb(unsigned addr, char val) { *(volatile char *)addr = val; }

static inline volatile int inw(unsigned addr) { return *(volatile int *)addr; }
static inline void outw(unsigned addr, int val) { *(volatile int *)addr = val; }

#endif
