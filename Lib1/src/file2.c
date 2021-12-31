#include <stdio.h>
#include <lib1.h>

void lib1b(void)
{
    printf("%s:%d:%s: here\n", __FILE__, __LINE__, __func__);
}
