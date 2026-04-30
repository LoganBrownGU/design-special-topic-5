#include "graph.h"
#include "pico.h"

#include <stdio.h>
#include <unistd.h>
#include <pthread.h>

#define SIZEX   (600)
#define SIZEY   (600)

static graph *_graph;

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
        for (int _ = 0; _ < 100; _++) {
            pico_gather_samples(p, 1);
        }
        pico_destroy(&p);
    } else {
        printf("pico initialisation failed\n");
    }

    pthread_join(t, NULL);
    
    return 0;
}
