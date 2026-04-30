#include "graph.h"
#include "pico.h"

#include <stdint.h>
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>

static graph *_graph;

int min(int a, int b) {
    return a < b ? a : b;
}

void *graph_render_thread(void *_) { (void) _;
    graph_render_loop(_graph);
    graph_destroy(&_graph);

    return NULL;
}

int main(void) {
    _graph = graph_new("This is my window.");

    pthread_t t; 
    pthread_create(&t, NULL, graph_render_thread, NULL);

    pico *p = pico_new();
    
    if (!p) { printf("pico initialisation failed\n"); return -1; }
    
    for (;;) {
        int32_t n; 
        int16_t *samples = pico_gather_samples(p, &n);
        point *points = graph_get_buffer(_graph); 

        float div_x = ((float) GRAPH_SIZE_X - 10.0) / ((float) n);
        float div_y = ((float) GRAPH_SIZE_Y - 10.0) / (2.0 * (float) INT16_MAX);
        for (int i = 0; i < n; i++) {
            float y = ((float) samples[i]) * div_y;
            points[i].y = y;  
            float x = ((float) i) * div_x;
            if (i > n - 10) { printf("%f %f\n", x, y); };
            points[i].x = x;
        }
    }
    
    pico_destroy(&p);
    pthread_join(t, NULL);
    
    return 0;
}
