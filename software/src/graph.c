#include "graph.h"
#include "gl.h"
#include <X11/X.h>
#include <X11/Xlib.h>
#include <cairo/cairo-xlib.h>
#include <cairo/cairo.h>
#include <stddef.h>
#include <stdlib.h>
#include <unistd.h>

GL_Point points[GRAPH_MAX_POINTS];

static void render_frame(void) {
    GL_ClearWindow();
    GL_DrawLines(points, GRAPH_MAX_POINTS);
}

static void expose_handler(void) {
    GL_SetWindowVisible();
}

static void update_state(void) {
    
}


void graph_init(const char *name) {
    GL_Init();
    GL_CreateWindow(GRAPH_SIZE_X, GRAPH_SIZE_Y, GL.color.black);
    GL_SetWindowTitle(name);
    GL_SetWindowFixed();
    GL_SetFont("10x20");

    GL_SetExposeHandler(expose_handler);
    GL_SetFrameRate(60);
    GL_Loop(update_state, render_frame);
    printf("window closing...\n");
    GL_Quit();
}

GL_Point *graph_get_buffer(void) {
    return points;
}
