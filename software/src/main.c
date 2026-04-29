#include "pico.h"

int main(void) {
    pico *p = pico_new("Makefile");
    
    pico_destroy(&p);
    
    return 0;
}
