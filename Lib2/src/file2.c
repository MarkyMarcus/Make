#include <stdio.h>
#include <lib2.h>

void lib2b(void)
{
    printf("%s:%d:%s: here\n", __FILE__, __LINE__, __func__);
}
