#ifndef GRAPH_H_
#define GRAPH_H_

#define GRAPH_MAX_POINTS (1048576)

typedef struct graph_t graph;

typedef struct colour_t {
    float r, g, b, a;
} colour;

typedef struct point_t {
    float x, y; 
    colour c;
} point;

graph *graph_new(const char *);
point *graph_get_buffer(graph *);
void   graph_paint(graph *);
void   graph_destroy(graph **);
void   graph_render_loop(graph *);

#endif
