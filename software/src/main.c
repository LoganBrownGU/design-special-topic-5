#include "pico.h"

#include<cairo/cairo.h>
#include<cairo/cairo-pdf.h>
#include<cairo/cairo-ps.h>
#include<cairo/cairo-xlib.h>
#include<X11/Xlib.h>
#include <math.h>

#define SIZEX   (600)
#define SIZEY   (600)

void paint(cairo_surface_t *cs)
{
	cairo_t *c;
	c=cairo_create(cs); 
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

int main(void) {
    // pico *p = pico_new("Makefile");
    // if (!p) { return 0; }
    
    // pico_destroy(&p);
    
    Display *dpy;
	Window rootwin;
	Window win;
	XEvent e;
	int scr;
	cairo_surface_t *cs;
	if(!(dpy=XOpenDisplay(NULL))) {
		fprintf(stderr, "ERROR: Could not open display\n");
		return -1;
	}
	scr=DefaultScreen(dpy);
	rootwin=RootWindow(dpy, scr);
	win=XCreateSimpleWindow(dpy, rootwin, 1, 1, SIZEX, SIZEY, 0, 
			BlackPixel(dpy, scr), BlackPixel(dpy, scr));
	XStoreName(dpy, win, "hello");
	XSelectInput(dpy, win, ExposureMask|ButtonPressMask);
	XMapWindow(dpy, win);
    
	cs=cairo_xlib_surface_create(dpy, win, DefaultVisual(dpy, 0), SIZEX, SIZEY);
	while(1) {
		XNextEvent(dpy, &e);
		if(e.type==Expose && e.xexpose.count<1) {
			paint(cs);
		} else if(e.type==ButtonPress) break;
	}
	cairo_surface_destroy(cs);
	XCloseDisplay(dpy); 
    
    return 0;
}
