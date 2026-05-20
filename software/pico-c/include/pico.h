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


/**
 * Takes approx. one second's worth of samples. 
 * @param requested_sample_rate: The rate to sample at. This function will use the sample rate closest to this. 
 * @param actual_sample_rate: Set by this function to the actual sample rate used. 
 * @param samples_written: Set by this function to the number of samples written by it. 
 * @returns: A pointer to the sample buffer. Note that this buffer is dynamically allocated and needs to be freed. 
 */
int16_t      *pico_gather_samples(pico *self, uint32_t requested_sample_rate, uint32_t *samples_written, float *actual_sample_rate);
void          pico_awg(pico *);

#endif
