int main()
{
    int a[5] = {1, 20, 3, 4, 5}; //initiate array of 5 numbers
    int max_val = 0;            // initiate max_val 

    // find the length of the array (number of elements in array)
    int length = sizeof(a) / sizeof(a[0]);

    int i;
    for (i = 0; i < length; i++)
    {
        // check if the value is greater than the max
        if (max_val < a[i])
        {
            // if greater than change the max_val
            max_val = a[i];
        }
    }
    return max_val;
}
