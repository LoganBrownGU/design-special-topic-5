#include "pico.h"
#include "ring-buffer.h"
#include <libps2000/ps2000.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <threads.h>
#include <unistd.h>

struct pico_t {
    int16_t handle; 
    int16_t timebase; 
};

void collect_block_immediate(pico *);

int16_t saved_values[PICO_BUFFER_SIZE]; 
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
    
    memcpy(saved_values, overviewBuffers[0], n_values * sizeof(int16_t));
}

pico *pico_new(void) {
    
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

int16_t *pico_gather_samples(pico *self, int32_t *n) {
    int32_t time_indisposed;

    int16_t timebase = 0; 
    int32_t time_interval = 0;
    int16_t time_units;
    int32_t max_samples;
    int result = 0;
    while (result == 0 && time_interval < 1000000000 / PICO_BUFFER_SIZE) {
        ps2000_get_timebase(self->handle, timebase++, PICO_BUFFER_SIZE, &time_interval, &time_units, 1, &max_samples);
        if (timebase > 100) {exit(-1);};
    }
    
    printf("timebase: %d\n", timebase);
    ps2000_run_block(self->handle, PICO_BUFFER_SIZE, timebase, 1, &time_indisposed);
    
    printf("time indisposed: %d ms\n", time_indisposed);

    thrd_sleep(&(struct timespec){ .tv_sec = time_indisposed / 1000 }, NULL);
    while (!ps2000_ready(self->handle)) { 
        thrd_sleep(&(struct timespec){ .tv_nsec = 1000000 }, NULL);
    }

    int16_t overflow;
    ps2000_get_values(self->handle, saved_values, NULL, NULL, NULL, &overflow, PICO_BUFFER_SIZE);
    
    // while (!ps2000_get_streaming_last_values(self->handle, &get_streaming_buffers);


    
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
