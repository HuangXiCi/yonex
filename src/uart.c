#include <io.h>
#include <uart.h>

void uart_putch(int ch) {
    while (inb(UART_TX_DATA) != 0) {;}
    outb(UART_TX_DATA, ch);
}

int uart_getch() {
    int ch = 0;
    while ((ch = inb(UART_RX_DATA)) == 0) {;}
    return ch;
}

void uart_putstr(const char *s) {
    for (;*s;s++) {
        if (*s == '\n') { uart_putch('\r'); }
        uart_putch(*s);
    }
}
