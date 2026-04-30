#ifndef RING_BUFFER_H_
#define RING_BUFFER_H_

#include <stddef.h>
#include <stdint.h>
typedef struct ring_buffer_t ring_buffer;

ring_buffer *ring_buffer_new(size_t);
void         ring_buffer_read(ring_buffer *, int32_t *, size_t);
void         ring_buffer_destroy(ring_buffer **);
void         ring_buffer_write(ring_buffer *, int32_t *, size_t);

#endif
