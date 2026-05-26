#include <uart.h>

typedef unsigned int    uint32_t;

/* ================= UART print helpers ================= */

static void uart_put_uint(uint32_t x)
{
    char buf[11];
    int i = 0;

    if (x == 0) {
        uart_putch('0');
        return;
    }

    while (x > 0) {
        buf[i++] = (char)('0' + (x % 10));
        x /= 10;
    }

    while (i > 0) {
        i--;
        uart_putch(buf[i]);
    }
}

static int dec_len(uint32_t x)
{
    int len = 1;

    while (x >= 10) {
        x /= 10;
        len++;
    }

    return len;
}

static void put_spaces(int n)
{
    while (n > 0) {
        uart_putch(' ');
        n--;
    }
}

/* ================= random ================= */

static uint32_t rand32(uint32_t *rng_state)
{
    *rng_state = *rng_state * 1103515245u + 12345u;
    return *rng_state;
}

static void rand_seed(uint32_t seed, uint32_t *rng_state)
{
    *rng_state ^= seed + 0x9E3779B9u + (*rng_state << 6) + (*rng_state >> 2);
}

/* ================= 2048 game ================= */

#define N 4
#define CELL_WIDTH 6

static void board_clear(uint32_t board[4][4], uint32_t *score)
{
    for (int y = 0; y < N; y++) {
        for (int x = 0; x < N; x++) {
            board[y][x] = 0;
        }
    }

    *score = 0;
}

static int count_empty(uint32_t board[4][4])
{
    int count = 0;

    for (int y = 0; y < N; y++) {
        for (int x = 0; x < N; x++) {
            if (board[y][x] == 0) {
                count++;
            }
        }
    }

    return count;
}

static int spawn_tile(uint32_t board[4][4], uint32_t *rng_state)
{
    int empty = count_empty(board);

    if (empty == 0) {
        return 0;
    }

    int target = (int)(rand32(rng_state) % (uint32_t)empty);
    int index = 0;

    for (int y = 0; y < N; y++) {
        for (int x = 0; x < N; x++) {
            if (board[y][x] == 0) {
                if (index == target) {
                    board[y][x] = ((rand32(rng_state) % 10u) == 0u) ? 4u : 2u;
                    return 1;
                }

                index++;
            }
        }
    }

    return 0;
}

static void draw_cell(uint32_t v)
{
    if (v == 0) {
        put_spaces(CELL_WIDTH - 1);
        uart_putch('.');
    } else {
        int len = dec_len(v);

        if (len < CELL_WIDTH) {
            put_spaces(CELL_WIDTH - len);
        }

        uart_put_uint(v);
    }
}

static void draw_border(void)
{
    uart_putstr("+------+------+------+------+\n");
}

static void draw_board(uint32_t board[4][4], uint32_t score, uint32_t best_score)
{
    screen_clear();

    uart_putstr("2048\n");
    uart_putstr("W/A/S/D move, Q quit, R restart.\n");
    uart_putstr("Score: ");
    uart_put_uint(score);
    uart_putstr("\nBest Score: ");
    uart_put_uint(best_score);
    uart_putstr("\n\n");

    draw_border();

    for (int y = 0; y < N; y++) {
        uart_putch('|');

        for (int x = 0; x < N; x++) {
            draw_cell(board[y][x]);
            uart_putch('|');
        }

        uart_putstr("\n");
        draw_border();
    }
}

/* 把一行向左压缩并合并。
   输入/输出都是 line[4]。
   返回 1 表示这一行发生变化。 */
static int slide_merge_left(uint32_t line[N], uint32_t *score)
{
    uint32_t tmp[N];
    uint32_t out[N];

    for (int i = 0; i < N; i++) {
        tmp[i] = 0;
        out[i] = 0;
    }

    int t = 0;

    for (int i = 0; i < N; i++) {
        if (line[i] != 0) {
            tmp[t] = line[i];
            t++;
        }
    }

    int o = 0;

    for (int i = 0; i < N; i++) {
        if (tmp[i] == 0) {
            break;
        }

        if ((i + 1 < N) && (tmp[i] == tmp[i + 1])) {
            out[o] = tmp[i] * 2u;
            *score += out[o];
            i++;
        } else {
            out[o] = tmp[i];
        }

        o++;
    }

    int changed = 0;

    for (int i = 0; i < N; i++) {
        if (line[i] != out[i]) {
            changed = 1;
        }

        line[i] = out[i];
    }

    return changed;
}

static int move_left(uint32_t board[4][4], uint32_t *score)
{
    int changed = 0;

    for (int y = 0; y < N; y++) {
        uint32_t line[N];

        for (int x = 0; x < N; x++) {
            line[x] = board[y][x];
        }

        if (slide_merge_left(line, score)) {
            changed = 1;
        }

        for (int x = 0; x < N; x++) {
            board[y][x] = line[x];
        }
    }

    return changed;
}

static int move_right(uint32_t board[4][4], uint32_t *score)
{
    int changed = 0;

    for (int y = 0; y < N; y++) {
        uint32_t line[N];

        for (int x = 0; x < N; x++) {
            line[x] = board[y][N - 1 - x];
        }

        if (slide_merge_left(line, score)) {
            changed = 1;
        }

        for (int x = 0; x < N; x++) {
            board[y][N - 1 - x] = line[x];
        }
    }

    return changed;
}

static int move_up(uint32_t board[4][4], uint32_t *score)
{
    int changed = 0;

    for (int x = 0; x < N; x++) {
        uint32_t line[N];

        for (int y = 0; y < N; y++) {
            line[y] = board[y][x];
        }

        if (slide_merge_left(line, score)) {
            changed = 1;
        }

        for (int y = 0; y < N; y++) {
            board[y][x] = line[y];
        }
    }

    return changed;
}

static int move_down(uint32_t board[4][4], uint32_t *score)
{
    int changed = 0;

    for (int x = 0; x < N; x++) {
        uint32_t line[N];

        for (int y = 0; y < N; y++) {
            line[y] = board[N - 1 - y][x];
        }

        if (slide_merge_left(line, score)) {
            changed = 1;
        }

        for (int y = 0; y < N; y++) {
            board[N - 1 - y][x] = line[y];
        }
    }

    return changed;
}

static int has_2048(uint32_t board[4][4])
{
    for (int y = 0; y < N; y++) {
        for (int x = 0; x < N; x++) {
            if (board[y][x] >= 2048u) {
                return 1;
            }
        }
    }

    return 0;
}

static int can_move(uint32_t board[4][4])
{
    if (count_empty(board) > 0) {
        return 1;
    }

    for (int y = 0; y < N; y++) {
        for (int x = 0; x < N; x++) {
            if ((x + 1 < N) && (board[y][x] == board[y][x + 1])) {
                return 1;
            }

            if ((y + 1 < N) && (board[y][x] == board[y + 1][x])) {
                return 1;
            }
        }
    }

    return 0;
}

static int handle_input(int ch, uint32_t board[4][4], uint32_t *score)
{
    if (ch >= 'A' && ch <= 'Z') {
        ch = ch - 'A' + 'a';
    }

    if (ch == 'a') {
        return move_left(board, score);
    } else if (ch == 'd') {
        return move_right(board, score);
    } else if (ch == 'w') {
        return move_up(board, score);
    } else if (ch == 's') {
        return move_down(board, score);
    }

    return 0;
}

static int read_key_ignore_enter(void)
{
    int ch;

    do {
        ch = uart_getch();
    } while (ch == '\r' || ch == '\n');

    return ch;
}

int main()
{
    uint32_t best_score = 0;
    uint32_t score = 0;
    uint32_t board[4][4];
    uint32_t rng_state = 1;
    uint32_t seed = 0;
START:
    screen_reset();
    best_score = (best_score < score) ? score : best_score;

    // initial board
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            board[i][j] = 0;
        }
    }

    board_clear(board, &score);

    screen_clear();
    uart_putstr("\nPress any key to seed random...\n");

    seed = uart_getch();
    rand_seed(seed, &rng_state);

    spawn_tile(board, &rng_state);
    spawn_tile(board, &rng_state);

    int won_printed = 0;

    while (1) {
        draw_board(board, score, best_score);

        if (!can_move(board)) {
            uart_putstr("\nGame Over!\n");
            uart_putstr("Final score: ");
            uart_put_uint(score);
            uart_putstr("\n");
            break;
        }

        if (has_2048(board) && !won_printed) {
            uart_putstr("\nYou reached 2048! Continue playing...\n");
            won_printed = 1;
        }

        int ch = read_key_ignore_enter();

        rand_seed((uint32_t)ch, &rng_state);

        if (ch == 'q' || ch == 'Q') {
            uart_putstr("\nQuit.\n");
            break;
        }

        if (ch == 'r' || ch == 'R') {
            goto RESTART;
        }

        int moved = handle_input(ch, board, &score);

        if (moved) {
            spawn_tile(board, &rng_state);
        }
    }

    uart_putstr("Press any key to restart game...\n");
    if(uart_getch()) {;}
RESTART:
    goto START;
    return 0;
}
