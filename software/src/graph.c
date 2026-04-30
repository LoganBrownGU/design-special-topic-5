#include "graph.h"
#include <X11/X.h>
#include <X11/Xlib.h>
#include <cairo/cairo-xlib.h>
#include <cairo/cairo.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define SIZEX   (600)
#define SIZEY   (600)

struct graph_t {
    // X11
    Display *d;
    Window root_win;
    Window win;
    XEvent e; 
    int scr; 

    // Cairo 
    cairo_surface_t *cs;
};

graph *graph_new(const char *name) {
    graph *self = (graph *) malloc(sizeof(graph));
    
    if (!(self->d = XOpenDisplay(NULL))) {
		fprintf(stderr, "ERROR: Could not open display\n");
		free(self);
		return NULL;
	}
    
	self->scr = DefaultScreen(self->d);
	self->root_win = RootWindow(self->d, self->scr);
	self->win = XCreateSimpleWindow(self->d, self->root_win, 1, 1, SIZEX, SIZEY, 0, BlackPixel(self->d, self->scr), BlackPixel(self->d, self->scr));
	XStoreName(self->d, self->win, name);
	XSelectInput(self->d, self->win, ExposureMask|ButtonPressMask);
	XMapWindow(self->d, self->win);

	
	self->cs=cairo_xlib_surface_create(self->d, self->win, DefaultVisual(self->d, 0), SIZEX, SIZEY);

	return self;
}

void graph_paint(graph *self) {
   	cairo_t *c;
	c=cairo_create(self->cs); 
	cairo_rectangle(c, 0.0, 0.0, SIZEX, SIZEY);
	cairo_set_source_rgb(c, 0.0, 0.0, 0.5);
	cairo_fill(c);
	
	cairo_set_source_rgb(c, 1.0, 1.0, 0.0);
	cairo_set_line_width(c, 2.0);
	cairo_move_to(c, 0, 0);
	for (double t = 0.0; t < SIZEX; t += 0.01) {
       	cairo_line_to(c, t, 100 + 20 * sin(t*0.1));
       	cairo_move_to(c, t, 100 + 20 * sin(t*0.1));
	}
	cairo_stroke(c);
	
	cairo_show_page(c);
	cairo_destroy(c);
}

void graph_render_loop(graph *self) {
    while (1) {
        XNextEvent(self->d, &self->e);

        if (self->e.type == Expose && self->e.xexpose.count < 1) {
            graph_paint(self);
        } else if (self->e.type == ButtonPress) {
            break;
        }
    }
}

void graph_destroy(graph **self_ptr) {
    graph *self = *self_ptr;

    cairo_surface_destroy(self->cs);
    XCloseDisplay(self->d);

    free(self);
    self = NULL;
}
