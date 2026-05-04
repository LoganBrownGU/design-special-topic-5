#include "pico_lib.h"
#include <assert.h>
#include <stddef.h>
#include <stdint.h>
#include </opt/picoscope/include/libps2000/ps2000.h>

#define AWG_BUFFER_SIZE (4096)
#define AWG_DDS_FREQ (48e6)

static uint8_t awg_buffer[AWG_BUFFER_SIZE];

void pico_awg(int16_t handle) {
    for (size_t i = 0; i < AWG_BUFFER_SIZE / 2; i++) {
        awg_buffer[i] = 0;
        awg_buffer[i + (AWG_BUFFER_SIZE / 2)] = 128;
    }

    float f = 1000.0;

    float delta = ((float) UINT32_MAX + 1.0) * f / AWG_DDS_FREQ;

    int result = ps2000_set_sig_gen_arbitrary(handle, 0, 2e6, delta, delta, 0, 0, awg_buffer, AWG_BUFFER_SIZE, 0, 0);
    assert(result != 0);
}
