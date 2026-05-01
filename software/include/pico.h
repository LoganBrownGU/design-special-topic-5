#ifndef PICO_H_ 
#define PICO_H_ 

#include "ring-buffer.h"
#include "graph.h"
#include <libps2000/ps2000.h>
#include <stdint.h>

#define PICO_BUFFER_SIZE (GRAPH_MAX_POINTS) 

typedef struct pico_t pico; 

pico         *pico_new(void);
void          pico_destroy(pico **);
ring_buffer  *pico_gather_samples(pico *, int32_t *);

#endif
