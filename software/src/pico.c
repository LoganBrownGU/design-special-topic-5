#include "pico.h"
#include "ring-buffer.h"
#include <libps2000/ps2000.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

struct pico_t {
    int16_t handle; 
    int16_t timebase; 
};

void collect_block_immediate(pico *);

ring_buffer *saved_values = NULL; 
int32_t last_n = 0; 

void get_streaming_buffers (
    int16_t **overviewBuffers,
    int16_t overflow,
    uint32_t triggered_at,
    int16_t triggered,
    int16_t auto_stop,
    uint32_t n_values
) {
    (void) overflow;
    (void) triggered_at;
    (void) triggered;
    (void) auto_stop;

    last_n = n_values;
    printf("%d\n", n_values);

    if (n_values == 0) { return; }
    
    ring_buffer_write(saved_values, overviewBuffers[0], n_values);
}

pico *pico_new(void) {
    if (!saved_values) { saved_values = ring_buffer_new(PICO_BUFFER_SIZE); }
    
    pico *_pico = (pico *) malloc(sizeof(pico));
    _pico->handle = ps2000_open_unit();
    
    if (_pico->handle == 0) {
        printf("Failed to open Picoscope.\n");
        free(_pico);
        return NULL;
    }

    if (!(ps2000_set_channel(_pico->handle, PS2000_CHANNEL_A, PS2000_CONDITION_TRUE, PS2000_CONDITION_TRUE, PS2000_2V))) {
        printf("failed to set channel A active.\n");
        free(_pico);
        return NULL;
    }

    if (!(ps2000_set_trigger(_pico->handle, PS2000_NONE, 0, PS2000_RISING, 0, 0))) {    // disable trigger
        printf("failed to disable trigger.\n");
        free(_pico);
        return NULL;
    }

    return _pico;
}

ring_buffer *pico_gather_samples(pico *self, int32_t *n) {
    if (!(ps2000_run_streaming_ns(self->handle, 900, PS2000_NS, PICO_BUFFER_SIZE, PS2000_CONDITION_TRUE, 1, 1000000))) { 
        printf("failed to start streaming.\n");
        return NULL;
    }

    
    while (!ps2000_get_streaming_last_values(self->handle, &get_streaming_buffers)) { usleep(50); }
    ps2000_stop(self->handle);

    *n = last_n;
    return saved_values;
}

void pico_destroy(pico **self_ptr) {
    pico *self = *self_ptr;
    ps2000_stop(self->handle);
    ps2000_close_unit(self->handle);
    free(self);
    self = NULL;
}
