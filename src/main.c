#include <uart.h>

int __attribute__((weak)) main()
{
  uart_putstr("Hello SUAT!\n");
  return 0;
}
