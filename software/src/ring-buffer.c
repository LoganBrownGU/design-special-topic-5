#include "ring-buffer.h"
#include <assert.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef int32_t element;

struct ring_buffer_t {
    element *buf;
    size_t size;
    size_t ptr; 
};

size_t size_t_min(size_t a, size_t b) {
    return a < b ? a : b;
} 

size_t size_t_max(size_t a, size_t b) {
    return a > b ? a : b;
}

ring_buffer *ring_buffer_new(size_t size) {
    ring_buffer *_rb = (ring_buffer *) malloc(sizeof(ring_buffer));
    _rb->buf = (element *) malloc(size * sizeof(element));
    memset(_rb->buf, 0, size * sizeof(element));
    _rb->size = size;
    _rb->ptr = 0;
    
    return _rb;
}

void ring_buffer_read(ring_buffer *self, element *dest, size_t n) {
    assert(n <= self->size);
    assert(n > 0);
    memcpy(dest, self->buf, n * sizeof(element));
}

void ring_buffer_write(ring_buffer *self, element *src, size_t n) {
    assert(n > 0);

    size_t left_to_write = n;
    size_t written = 0;
    size_t remaining_after_ptr = self->size - self->ptr;

    if (left_to_write <= remaining_after_ptr) {
        memcpy(self->buf + self->ptr, src, left_to_write * sizeof(element));
        self->ptr += left_to_write;
        printf("early\n");
        return;
    }

    memcpy(self->buf + self->ptr, src, remaining_after_ptr * sizeof(element));
    left_to_write -= remaining_after_ptr;
    written += remaining_after_ptr;
    self->ptr = 0;
    while (left_to_write > 0) {
        size_t to_copy = size_t_min(left_to_write, self->size);
        memcpy(self->buf, src + written, to_copy * sizeof(element));
        self->ptr += to_copy % self->size;
        left_to_write -= size_t_min(left_to_write, to_copy);
        written += to_copy;
    }
}

void ring_buffer_destroy(ring_buffer **self_ptr) {
    ring_buffer *self = *self_ptr;

    free(self->buf);
    free(self);
    
    self = NULL;
}
