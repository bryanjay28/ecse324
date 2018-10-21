#include <stdio.h>

extern int MAX_2(int x, int y);

int main(int argc, char const *argv[])
{
    int a = 1, b = 2, c;
    c = MAX_2(a, b);
    return 0;
}
