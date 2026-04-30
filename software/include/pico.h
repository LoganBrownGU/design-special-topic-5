#ifndef PICO_H_ 
#define PICO_H_ 

#include <libps2000/ps2000.h>
#include <stdint.h>

typedef struct pico_t pico; 

pico     *pico_new(void);
void      pico_destroy(pico **);
int16_t  *pico_gather_samples(pico *, int);

#endif
