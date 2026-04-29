#include "pico.h"
#include <stdio.h>
#include <stdlib.h>

struct pico_t {
    FILE *f;
};

pico *pico_new(const char* path) {
    pico *_pico = (pico *) malloc(sizeof(pico));
    _pico->f = fopen(path, "r");
    
    return _pico;
}

char pico_get_next(pico *_pico) {
    char c; 
    fread(&c, 1, 1, _pico->f);
    return c; 
}

void pico_destroy(pico **_pico) {
    fclose((*_pico)->f);
    free(*_pico);
    *_pico = NULL;
}
