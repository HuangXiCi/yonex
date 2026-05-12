#ifndef __UART_H_
#define __UART_H_

#define UART_BASE       0x10000000
#define UART_TX_DATA    (UART_BASE + 0x00)
#define UART_RX_DATA    (UART_BASE + 0x04)

void uart_putch(int ch);
int uart_getch();
void uart_putstr(char *s);

#endif
