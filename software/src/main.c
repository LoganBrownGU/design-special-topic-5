#include "graph.h"

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

    pthread_join(t, NULL);
    
    return 0;
}
