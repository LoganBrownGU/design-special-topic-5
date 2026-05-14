#include "pico_lib.h"
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define BILLION (1000000000)

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
        }
        
        (*timebase)++;
    }

    if (result == 0 || last_valid_time_interval == INT32_MIN) { return 0; }

    *actual_fs = BILLION / last_valid_time_interval;
    *timebase -= 1;
    return 1;
}

uint16_t pico_gather_samples(const pico *self, pico_frequency_t fs, pico_sample_t *buf, size_t bufsize) {

    return 1;
}
