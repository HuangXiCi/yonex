#include "uart.h"
// #include "data.h"

void game_2048(void);

int main()
{
  game_2048();
  while(1) {;}
  return 0;
}

// int main()
// {
//   while (1) {
//     uart_putstr("\033[2J");
//     uart_putstr(data1);
//     uart_getch();
//     uart_putstr("\033[2J");
//     uart_putstr(data2);
//     volatile int i = 5000000;
//     while(i--) {;}
//   }
//   return 0;
// }
