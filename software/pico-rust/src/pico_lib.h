#ifndef PICO_H_ 
#define PICO_H_ 

#include </opt/picoscope/include/libps2000/ps2000.h>
#include <stddef.h>
#include <stdint.h>

typedef struct pico_t pico; 
typedef int32_t  pico_frequency_t;
typedef uint16_t pico_sample_t;
typedef uint8_t  pico_awg_value_t;
typedef int16_t  pico_handle_t;

pico *pico_new(void);
void  pico_destroy(pico **);

/**
 * Calculates the actual sample frequency that the PicoScope supports closest to the requested frequency,
 * and the size of a buffer required to store a second's worth of data at that frequency. 
 * @param requested_fs: ideal sample frequency to use. 
 * @param actual_fs: pointer to variable in which to store the actual sample frequency that will be used.
 * @param bufsize: pointer to variable in which to store the size of the buffer required for a second's worth 
 *                 of data at `actual_fs`.
 * @return zero if requested sample frequency is invalid (either too small or too large), non-zero otherwise. 
 */
uint16_t pico_get_fs_and_bufsize(const pico *self, pico_frequency_t requested_fs, pico_frequency_t *actual_fs, size_t *bufsize);

/**
 * Gathers a second's worth of samples at `fs`, and places them into `buf`. 
 * @return zero if unsuccessful, non-zero otherwise. 
 */
uint16_t pico_gather_samples(const pico *self, pico_frequency_t fs, pico_sample_t *buf, size_t bufsize);

/**
 * Produces a waveform matching the contents of `buf`. 
 * @param buf: the buffer containing the waveform. _Must be exactly AWG_BUFFER_SIZE in size_. 
 * @return zero if unsuccessful, non-zero otherwise. 
 */
uint16_t pico_awg(pico *self, pico_awg_value_t *buf);

#endif
