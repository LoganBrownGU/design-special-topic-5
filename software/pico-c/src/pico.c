#include "pico.h"
#include <assert.h>
#include <libps2000/ps2000.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <threads.h>
#include <unistd.h>

#define AWG_BUFFER_SIZE (4096)
#define AWG_DDS_FREQ (48e6)

struct pico_t {
    int16_t handle; 
    int16_t timebase; 
    uint8_t awg_buffer[AWG_BUFFER_SIZE]; 
    int16_t read_buffer[PICO_BUFFER_SIZE];
};

void collect_block_immediate(pico *);

int16_t saved_values[PICO_BUFFER_SIZE]; 
int32_t last_n = 0; 

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

int16_t *pico_gather_samples(pico *self, uint32_t requested_sample_rate, uint32_t *samples_written, float *actual_sample_rate) {
    int32_t time_indisposed;

    int16_t timebase = 0; 
    int32_t time_interval = 0;
    int16_t time_units;
    int32_t max_samples;
    int result = 0;

    uint32_t n_samples = requested_sample_rate;
    
    while (result == 0 && (uint32_t) time_interval < 1000000000 / n_samples) {
        ps2000_get_timebase(self->handle, ++timebase, n_samples, &time_interval, &time_units, 1, &max_samples);
        if (timebase > 100) { printf("Failed to select timebase\n"); exit(-1); };
    }
    
    // printf("timebase: %d\n", timebase);
    ps2000_run_block(self->handle, n_samples, timebase, 1, &time_indisposed);
    
    fprintf(stderr, "time indisposed: %d ms\n", time_indisposed);

    // thrd_sleep(&(struct timespec){ .tv_sec = time_indisposed / 1000 }, NULL);
    while (!ps2000_ready(self->handle)) { 
        thrd_sleep(&(struct timespec){ .tv_nsec = 1000000 }, NULL);
    }

    int16_t *sbuf = (int16_t *) malloc(sizeof(int16_t) * n_samples);
    int32_t *tbuf = (int32_t *) malloc(sizeof(int32_t) * n_samples);
    ps2000_get_times_and_values(self->handle, tbuf, sbuf, NULL, NULL, NULL, 0, time_units, n_samples);
    fprintf(stderr, "maxsamples: %d\n", max_samples);
    fprintf(stderr, "n_samples: %d\n", n_samples);
    ps2000_stop(self->handle);

    *samples_written = n_samples;
    *actual_sample_rate =  (n_samples * 1e9) / (tbuf[n_samples - 1] - tbuf[0]);

    free(tbuf);

    return sbuf;
}

void pico_destroy(pico **self_ptr) {
    pico *self = *self_ptr;
    ps2000_stop(self->handle);
    ps2000_close_unit(self->handle);
    free(self);
    self = NULL;
}

void pico_awg(pico *self) {
    for (size_t i = 0; i < AWG_BUFFER_SIZE / 2; i++) {
        self->awg_buffer[i] = 0;
        self->awg_buffer[i + (AWG_BUFFER_SIZE / 2)] = 128;
    }

    float f = 1000.0;

    float delta = ((float) UINT32_MAX + 1.0) * f / AWG_DDS_FREQ;

    int result = ps2000_set_sig_gen_arbitrary(self->handle, 0, 2e6, delta, delta, 0, 0, self->awg_buffer, AWG_BUFFER_SIZE, 0, 0);
    assert(result != 0);
    printf("%d %d\n", result, self->handle);
}
