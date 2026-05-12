#include "uart.h"

int main() {
    while (1) {
        int ch = uart_getch();
        if (ch == 0x0D) {
            uart_putstr("\n");
        } else {uart_putch(ch);}
    }
    return 0;
}
