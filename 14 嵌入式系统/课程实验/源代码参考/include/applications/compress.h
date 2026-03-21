#ifndef COMPRESS_H__
#define COMPRESS_H__

#include <rtthread.h>

rt_uint32_t lz77_compress(const rt_uint8_t *input, rt_uint32_t input_len, rt_uint8_t *output, rt_uint32_t output_size);
rt_uint32_t lz77_decompress(const rt_uint8_t *input, rt_uint32_t input_len, rt_uint8_t *output, rt_uint32_t output_size);
rt_uint32_t rle_compress(const rt_uint8_t *input, rt_uint32_t input_len, rt_uint8_t *output, rt_uint32_t output_size);
rt_uint32_t rle_decompress(const rt_uint8_t *input, rt_uint32_t input_len, rt_uint8_t *output, rt_uint32_t output_size);

#endif

