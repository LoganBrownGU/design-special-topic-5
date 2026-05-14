#ifndef PICO_H_ 
#define PICO_H_ 

#include </opt/picoscope/include/libps2000/ps2000.h>
#include <stddef.h>
#include <stdint.h>

typedef struct pico_t pico; 
typedef int32_t pico_frequency_t;
typedef int16_t pico_sample_t;
typedef uint8_t pico_awg_value_t;
typedef int16_t pico_handle_t;
typedef int16_t pico_timebase_t;

pico *pico_new(void);
void  pico_destroy(pico **);

/**
 * Calculates the actual sample frequency that the PicoScope supports closest to the requested frequency. 
 * @param requested_fs: ideal sample frequency to use. 
 * @param tolerance: how close the actual sample frequency should be to `fs`, i.e. within +/- `tolerance` of `fs`.
 * @param actual_fs: pointer to the actual sample frequency found by this function.
 * @param timebase: pointer to the timebase corresponding to actual_fs.
 * @return 0 if unable to find a suitable frequency, non-zero otherwise. 
 */
uint16_t pico_get_fs(const pico *self, pico_frequency_t requested_fs, pico_frequency_t tolerance, pico_frequency_t *actual_fs, pico_timebase_t *timebase);

/**
 * Gathers `bufsize` samples at the sample frequency given by `timebase`. Blocking.
 * @return zero if unsuccessful, non-zero otherwise. 
 */
uint16_t pico_gather_samples(const pico *self, pico_timebase_t timebase, pico_frequency_t *tbuf, pico_sample_t *sbuf, size_t bufsize);

/**
 * Produces a waveform matching the contents of `buf`. 
 * @param buf: the buffer containing the waveform. _Must be exactly AWG_BUFFER_SIZE in size_. 
 * @return zero if unsuccessful, non-zero otherwise. 
 */
uint16_t pico_awg(pico *self, pico_awg_value_t *buf);

#endif
