#ifndef PICO_H_ 
#define PICO_H_ 

#include <libps2000a/ps2000aApi.h>

typedef struct pico_t pico; 

pico *pico_new(const char *);

void pico_destroy(pico **);

#endif
