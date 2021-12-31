#include <stdio.h>
#include <main.h>

int main(void)
{
    printf("%s:%d:%s: here\n", __FILE__, __LINE__, __func__);

    main1();

    return 0;
}
