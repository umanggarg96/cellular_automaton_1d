#include "Vca_core.h"
#include "verilated.h"
#include <cstdio>

void tick(Vca_core *tb){
        tb -> eval();
        tb -> clk = 1;
        tb -> eval();
        tb -> clk = 0;
        tb -> eval();
}

char *format_CA(unsigned int *ca)
{
    char *s = new char[129];

    for( int j = 0 ; j < 4; ++j) {
        int term = ca[j];
        for(int i = 0; i < 32; ++i) {
            if(term & ( 1 << i ))
                s[j * 32 + i] = '1';
            else
                s[j * 32 + i] = '0';
        }
    }
    s[128] = '\0';
    return s;
}
int main(int argc, char **argv)
{

    Verilated::commandArgs(argc, argv);

    Vca_core *tb = new Vca_core;

    tb-> reset_n = 0;
    tick(tb);
    tick(tb);
    tb-> reset_n = 1;

    for(int i = 0; i < 100000; ++i)
    {
        if(tb -> ca_core__DOT__index == 128)
            printf("CA = %s\n", format_CA(tb -> ca));
        tick(tb);
    }

}


