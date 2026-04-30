#include "pico.h"
#include <libps2000/ps2000.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define BUFFER_SIZE (1024) 

struct pico_t {
    int16_t handle; 
    int16_t timebase; 
};

void collect_block_immediate(pico *);

void pico_test_read(pico *self) {
    collect_block_immediate(self);
}

void collect_block_immediate (pico *self)
{
	int32_t 	time_interval;
	int16_t 	time_units;
	int16_t 	oversample;
	int16_t 	timebase = 8;
	int32_t 	no_of_samples = BUFFER_SIZE;
	int16_t 	auto_trigger_ms = 0;
	int32_t 	time_indisposed_ms;
	int16_t 	overflow;
	int32_t 	max_samples;
	int32_t times[BUFFER_SIZE];

	/* Trigger disabled */
	ps2000_set_trigger ( self->handle, PS2000_NONE, 0, PS2000_RISING, 0, auto_trigger_ms );

	/*  Find the maximum number of samples, the time interval (in time_units),
	*		 the most suitable time units, and the maximum oversample at the current timebase
	*/
	oversample = 1;
	while (!ps2000_get_timebase ( self->handle,
                        timebase,
  					    no_of_samples,
                        &time_interval,
                        &time_units,
                        oversample,
                        &max_samples)) { timebase++; }

	printf ( "timebase: %hd\toversample:%hd\n", timebase, oversample );
	
	/* Start it collecting,
	*  then wait for completion
	*/

	ps2000_run_block ( self->handle, no_of_samples, timebase, oversample, &time_indisposed_ms );
	
	while ( !ps2000_ready ( self->handle ) )
	{
		sleep(1);
	}

	ps2000_stop ( self->handle );

	/* Should be done now...
	*  get the times (in nanoseconds)
	*   and the values (in ADC counts)
	*/

	int16_t avalues[BUFFER_SIZE];
	int16_t bvalues[BUFFER_SIZE];
	ps2000_get_times_and_values ( self->handle, times,
								    avalues,	
									bvalues,
									NULL,
									NULL,
									&overflow, time_units, no_of_samples );

	/* Print out the first 10 readings,
	*  converting the readings to mV if required
	*/

	printf("%d %d\n", time_units, time_interval);
	int nsamples = 38;
	for (int i = 0; i < nsamples; i++) {
	    printf("%5d ", avalues[i]);
	}
	printf("\n");
	for (int i = 0; i < nsamples; i++) {
        printf("%5d ", times[i]);
	}
	printf("\n");
}

void get_streaming_buffers 
(
    int16_t **overviewBuffers,
    int16_t overflow,
    uint32_t triggeredAt,
    int16_t triggered,
    int16_t auto_stop,
    uint32_t nValues
) {
    (void) overflow;
    (void) triggeredAt;
    (void) triggered;
    (void) auto_stop;

    printf("got %d values\n", nValues);

    if (nValues == 0) { return; }
    
    int16_t channel_a_max = overviewBuffers[0][0];
    int16_t channel_b_max = overviewBuffers[1][0];

    (void) channel_a_max;
    (void) channel_b_max;
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

    if (!(ps2000_run_streaming_ns(_pico->handle, 100, 3, BUFFER_SIZE, PS2000_CONDITION_TRUE, 1, 15000))) { 
        printf("failed to start streaming.\n");
        free(_pico);
        return NULL;
    }
    
    return _pico;
}

void pico_gather_samples(pico *self, int delay) {
    if (!(ps2000_run_streaming_ns(self->handle, 100, 3, BUFFER_SIZE, PS2000_CONDITION_TRUE, 1, 15000))) { 
        printf("failed to start streaming.\n");
        return;
    }
    sleep(delay);
    ps2000_get_streaming_last_values(self->handle, &get_streaming_buffers);
    ps2000_stop(self->handle);
}

void pico_destroy(pico **self_ptr) {
    pico *self = *self_ptr;
    ps2000_stop(self->handle);
    ps2000_close_unit(self->handle);
    free(self);
    self = NULL;
}
