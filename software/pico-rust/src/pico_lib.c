#include "pico_lib.h"
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <threads.h>

#define BILLION (1000000000)
#define MILLION (1000000)

typedef int16_t pico_timebase_t;
typedef int16_t pico_time_units_t;

struct pico_t {
    pico_handle_t handle;
};

pico *pico_new(void) {
    int16_t handle = ps2000_open_unit();
    if (handle < 1) { return NULL; }
    
    pico *self = (pico *)malloc(sizeof(pico));
    self->handle = handle;

    ps2000_set_channel(self->handle, PS2000_CHANNEL_A, 1, 1, PS2000_2V);

    return self;
}

void pico_destroy(pico **self_ptr) {
    pico *self = *self_ptr;
    ps2000_stop(self->handle);
    free(self);
    self = NULL;
}

uint16_t pico_get_fs(
    const pico *self, 
    pico_frequency_t  requested_fs, 
    pico_frequency_t  tolerance, 
    pico_frequency_t *actual_fs, 
    pico_timebase_t  *timebase
) {
    pico_frequency_t requested_time_interval = BILLION / requested_fs;
    pico_frequency_t time_interval_max = BILLION / (requested_fs - tolerance); 
    pico_frequency_t time_interval_min = BILLION / (requested_fs + tolerance); 
    
    pico_frequency_t time_interval; 
    *timebase = 1; 
    pico_time_units_t time_units;
    int result = 0;

    if (ps2000_get_timebase(self->handle, *timebase, 0, &time_interval, &time_units, 0, NULL) == 0) { return 0; }

    pico_frequency_t last_valid_time_interval = INT32_MIN;
    pico_frequency_t last_valid_time_interval_error = INT32_MAX;
    pico_timebase_t  last_valid_timebase = -1;
    while (*timebase < PS2000_MAX_TIMEBASE) {
        result = ps2000_get_timebase(self->handle, *timebase, 0, &time_interval, &time_units, 0, NULL);

        if ( // if time interval is valid
            time_interval >= time_interval_min && 
            time_interval <= time_interval_max 
        ) {
            pico_frequency_t time_interval_error = requested_time_interval - time_interval;
            // take abs()
            time_interval_error = time_interval_error < 0 ? -time_interval_error : time_interval_error;

            // if the time interval error has become worse, stop. 
            if (time_interval_error > last_valid_time_interval_error) { break; }

            last_valid_time_interval_error = time_interval_error;
            last_valid_time_interval = time_interval;
            last_valid_timebase = *timebase;
        }
        
        (*timebase)++;
    }

    if (result == 0 || last_valid_time_interval == INT32_MIN) { return 0; }

    *actual_fs = BILLION / last_valid_time_interval;
    *timebase = last_valid_timebase;
    return 1;
}

uint16_t pico_gather_samples(const pico *self, pico_timebase_t timebase, pico_frequency_t *tbuf, pico_sample_t *sbuf, size_t bufsize) {

    int32_t time_indisposed;
    int16_t result = ps2000_run_block(self->handle, bufsize, timebase, 0, &time_indisposed);
    if (result == 0) { fprintf(stderr, "failed to start read\n"); return 0; }
    
    thrd_sleep(&(struct timespec){ .tv_nsec = MILLION * time_indisposed / 2  }, NULL);
    while (!ps2000_ready(self->handle)) { 
        thrd_sleep(&(struct timespec){ .tv_nsec = MILLION }, NULL);
    }

    int16_t overflow;
    int32_t no_samples = ps2000_get_times_and_values(self->handle, tbuf, sbuf, NULL, NULL, NULL, &overflow, PS2000_NS, bufsize); 
    if (overflow && 0x01 == 0x01) { fprintf(stderr, "overflow occurred."); return 0; }
    
    fprintf(stderr, "read successful\n");
    if (no_samples == (int32_t) bufsize) {
        return 1; 
    } else {
        fprintf(stderr, "too few samples gathered for the sampling rate: %d vs %lu", no_samples, bufsize);
        return 0;
    }
}

uint16_t pico_awg(pico *self, pico_frequency_t f, pico_awg_value_t *buf) {
    float delta = ((float) UINT32_MAX + 1.0) * ((float) f) / AWG_DDS_FREQ;

    return ps2000_set_sig_gen_arbitrary(self->handle, 0, 2e6, delta, delta, 0, 0, buf, AWG_BUFFER_SIZE, 0, 0);
}
