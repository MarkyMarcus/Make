#include <stdio.h>
#include <main.h>

void main1(void)
{
    printf("%s:%d:%s: here\n", __FILE__, __LINE__, __func__);
}
