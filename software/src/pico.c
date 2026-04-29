#include "pico.h"
#include <libps2000a/PicoStatus.h>
#include <libps2000a/ps2000aApi.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

struct pico_t {
    int16_t handle; 
};

pico *pico_new(const char *device_name) {
    pico *_pico = (pico *) malloc(sizeof(pico));
    PICO_STATUS status = ps2000aOpenUnit(&_pico->handle, (int8_t *) device_name);
    
    if (status != PICO_OK) {
        printf("Failed to open Picoscope %s\n", device_name ? device_name : "");
        free(_pico);
        _pico = NULL;
    }
    return _pico;
}

void pico_destroy(pico **_pico_ptr) {
    pico *_pico = *_pico_ptr;
    ps2000aCloseUnit(_pico->handle);
    free(_pico);
    _pico = NULL;
}
