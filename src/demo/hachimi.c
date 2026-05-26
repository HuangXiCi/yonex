#include <uart.h>
#include <data.h>

int main()
{
  screen_reset();
  while (1) {
    screen_clear();
    uart_putstr(data1);
    uart_getch();
    screen_clear();
    uart_putstr(data2);
    volatile int i = 5000000;
    while(i--) {;}
  }
  return 0;
}
