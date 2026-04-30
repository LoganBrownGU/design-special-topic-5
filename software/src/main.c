#include "graph.h"
#include "pico.h"

#include <stdint.h>
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>

#define SIZEX   (600)
#define SIZEY   (600)

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
    if (p) {
        for (;;) {
            int32_t n; 
            int16_t *samples = pico_gather_samples(p, &n);
            point *points = graph_get_buffer(_graph); 

            float div = ((float) SIZEX - 10.0) / ((float) n);
            for (int i = 0; i < n; i++) {
                float y = ((float) samples[i]) / 80.0 + 10.0;
                points[i].y = y;  
                float x = ((float) i) * div;
                if (i > n - 10) { printf("%f %f\n", x, y); };
                points[i].x = x;
            }
        }
        pico_destroy(&p);
    } else {
        printf("pico initialisation failed\n");
    }

    pthread_join(t, NULL);
    
    return 0;
}
