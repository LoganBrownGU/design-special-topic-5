#ifndef PICO_H_ 
#define PICO_H_ 

#include <libps2000/ps2000.h>

typedef struct pico_t pico; 

pico *pico_new(void);

void pico_test_read(pico *);

void pico_destroy(pico **);

#endif
