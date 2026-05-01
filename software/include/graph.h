#ifndef GRAPH_H_
#define GRAPH_H_

#include "gl.h"
#define GRAPH_MAX_POINTS    (10000)
#define GRAPH_SIZE_X        (1600)
#define GRAPH_SIZE_Y        (600)

void graph_init(const char *);
GL_Point *graph_get_buffer(void);

#endif
