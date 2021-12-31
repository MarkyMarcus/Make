#include <stdio.h>
#include <lib2.h>

void lib2a(void)
{
    printf("%s:%d:%s: here\n", __FILE__, __LINE__, __func__);
}
