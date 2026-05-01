#include "gl.h"
#include "graph.h"
#include "pico.h"
#include "ring-buffer.h"

#include <stdint.h>
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>

int int_min(int a, int b) {
    return a < b ? a : b;
}

void *graph_render_thread(void *_) { (void) _;
    graph_init("This is my window.");
    return NULL;
}

int main(void) {

    pthread_t t; 
    pthread_create(&t, NULL, graph_render_thread, NULL);

    pico *p = pico_new();
    
    if (!p) { printf("pico initialisation failed\n"); return -1; }
    
    for (;;) {
        int32_t n; 
        int16_t *samples = ring_buffer_get_raw(pico_gather_samples(p, &n));
        GL_Point *points = graph_get_buffer(); 

        for (int i = 0; i < GRAPH_MAX_POINTS; i++) {
            points[i].y = (samples[i] * GRAPH_SIZE_Y) / INT16_MAX;  
            points[i].x = (i * GRAPH_SIZE_X) / GRAPH_MAX_POINTS;
        }
    }
    
    pico_destroy(&p);
    pthread_join(t, NULL);
    
    return 0;
}
