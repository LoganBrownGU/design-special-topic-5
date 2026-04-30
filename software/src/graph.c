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
    graph *this = (graph *) malloc(sizeof(graph));
    
    if (!(this->d = XOpenDisplay(NULL))) {
		fprintf(stderr, "ERROR: Could not open display\n");
		free(this);
		return NULL;
	}
    
	this->scr = DefaultScreen(this->d);
	this->root_win = RootWindow(this->d, this->scr);
	this->win = XCreateSimpleWindow(this->d, this->root_win, 1, 1, SIZEX, SIZEY, 0, BlackPixel(this->d, this->scr), BlackPixel(this->d, this->scr));
	XStoreName(this->d, this->win, name);
	XSelectInput(this->d, this->win, ExposureMask|ButtonPressMask);
	XMapWindow(this->d, this->win);

	
	this->cs=cairo_xlib_surface_create(this->d, this->win, DefaultVisual(this->d, 0), SIZEX, SIZEY);

	return this;
}

void graph_paint(graph *this) {
   	cairo_t *c;
	c=cairo_create(this->cs); 
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

void graph_render_loop(graph *this) {
    while (1) {
        XNextEvent(this->d, &this->e);

        if (this->e.type == Expose && this->e.xexpose.count < 1) {
            graph_paint(this);
        } else if (this->e.type == ButtonPress) {
            break;
        }
    }
}

void graph_destroy(graph **this_ptr) {
    graph *this = *this_ptr;

    cairo_surface_destroy(this->cs);
    XCloseDisplay(this->d);

    free(this);
    this = NULL;
}
