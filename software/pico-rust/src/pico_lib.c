#include "pico_lib.h"
#include <stdint.h>
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

uint16_t pico_get_fs_and_bufsize(const pico *self, pico_frequency_t requested_fs, pico_frequency_t *actual_fs, size_t *bufsize) {
    int32_t time_interval;
    pico_frequency_t max_samples = requested_fs; 
    pico_timebase_t timebase = 0; 
    pico_time_units_t time_units;
    int result = 0;

    while (result == 0 && time_interval < BILLION) {
        result = ps2000_get_timebase(self->handle, timebase, max_samples, &time_interval, &time_units, 0, &max_samples);
        timebase++;
    }

    if (result == 0) { return 0; }

    *bufsize = max_samples; 
    *actual_fs = BILLION / time_interval;
    
    return 1;
}

uint16_t pico_gather_samples(const pico *self, pico_frequency_t fs, pico_sample_t *buf, size_t bufsize) {

    return 1;
}
