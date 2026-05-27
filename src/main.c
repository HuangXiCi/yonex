#include <uart.h>

int __attribute__((weak)) main()
{
  uart_putstr("Hello SUAT!\n\n");

  while (1) {
    int ch = uart_getch();
    uart_putch(ch);
  }
  return 0;
}
