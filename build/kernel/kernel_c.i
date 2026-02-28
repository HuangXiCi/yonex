# 0 "kernel/kernel.c"
# 1 "/home/hxc/yonex//"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "kernel/kernel.c"
# 1 "kernel/device/include/uart.h" 1



void uart_init ( void );
char uart_recv ( void );
void uart_send ( char c );
void uart_send_string(char* str);
# 2 "kernel/kernel.c" 2

void kernel_main(void)
{
 uart_init();
 uart_send_string("Welcome RISC-V!\r\n");

 while (1) {
  ;
 }
}
