extern int MAX_2(int x, int y);

int main()
{
    int a[5] = {21, 2, 82, 12, 24};
    int max = 0;
    int i;

    // find the length of the array
    int length = sizeof(a) / sizeof(a[0]);
    for (i = 0; i < length; i++)
    {
        // call the subroutine and swap the max if it is less than the val
        max = MAX_2(a[i], max);
    }
    return 0;
}
