#include <rtthread.h>
#include <string.h>

#define MAX_WINDOW_SIZE 4096
#define MAX_MATCH_LENGTH 18
#define MIN_MATCH_LENGTH 3

typedef struct {
    rt_uint8_t *output;
    rt_uint32_t output_pos;
    rt_uint32_t output_size;
} lz77_ctx_t;

static void lz77_write_byte(lz77_ctx_t *ctx, rt_uint8_t byte)
{
    if (ctx->output_pos < ctx->output_size) {
        ctx->output[ctx->output_pos++] = byte;
    }
}

static void lz77_write_literal(lz77_ctx_t *ctx, rt_uint8_t byte)
{
    if (byte < 0x80) {
        lz77_write_byte(ctx, 0x80 | byte);
    } else {
        lz77_write_byte(ctx, 0x00);
        lz77_write_byte(ctx, byte);
    }
}

static void lz77_write_match(lz77_ctx_t *ctx, rt_uint16_t distance, rt_uint8_t length)
{
    lz77_write_byte(ctx, (distance >> 8) & 0x7F);
    lz77_write_byte(ctx, distance & 0xFF);
    lz77_write_byte(ctx, length);
}

rt_uint32_t lz77_compress(const rt_uint8_t *input, rt_uint32_t input_len, rt_uint8_t *output, rt_uint32_t output_size)
{
    lz77_ctx_t ctx;
    ctx.output = output;
    ctx.output_pos = 0;
    ctx.output_size = output_size;
    
    if (input_len == 0) {
        return 0;
    }
    
    rt_uint32_t i = 0;
    while (i < input_len) {
        rt_uint16_t best_distance = 0;
        rt_uint8_t best_length = 0;
        
        rt_uint32_t search_start = (i > MAX_WINDOW_SIZE) ? (i - MAX_WINDOW_SIZE) : 0;
        
        for (rt_uint32_t j = search_start; j < i; j++) {
            rt_uint8_t match_len = 0;
            while (match_len < MAX_MATCH_LENGTH && 
                   (i + match_len) < input_len && 
                   input[j + match_len] == input[i + match_len]) {
                match_len++;
            }
            
            if (match_len >= MIN_MATCH_LENGTH && match_len > best_length) {
                best_length = match_len;
                best_distance = i - j;
            }
        }
        
        if (best_length >= MIN_MATCH_LENGTH) {
            lz77_write_match(&ctx, best_distance, best_length);
            i += best_length;
        } else {
            lz77_write_literal(&ctx, input[i]);
            i++;
        }
    }
    
    return ctx.output_pos;
}

rt_uint32_t lz77_decompress(const rt_uint8_t *input, rt_uint32_t input_len, rt_uint8_t *output, rt_uint32_t output_size)
{
    rt_uint32_t input_pos = 0;
    rt_uint32_t output_pos = 0;
    
    while (input_pos < input_len && output_pos < output_size) {
        rt_uint8_t flag = input[input_pos++];
        
        if (flag & 0x80) {
            if (output_pos < output_size) {
                output[output_pos++] = flag & 0x7F;
            }
        } else if (flag == 0x00) {
            if (input_pos >= input_len) {
                break;
            }
            if (output_pos < output_size) {
                output[output_pos++] = input[input_pos++];
            }
        } else {
            if (input_pos + 1 >= input_len) {
                break;
            }
            rt_uint16_t distance = ((flag & 0x7F) << 8) | input[input_pos++];
            rt_uint8_t length = input[input_pos++];
            
            if (distance > output_pos || distance == 0) {
                break;
            }
            
            rt_uint32_t copy_start = output_pos - distance;
            for (rt_uint8_t i = 0; i < length && output_pos < output_size; i++) {
                output[output_pos++] = output[copy_start + i];
            }
        }
    }
    
    return output_pos;
}

rt_uint32_t rle_compress(const rt_uint8_t *input, rt_uint32_t input_len, rt_uint8_t *output, rt_uint32_t output_size)
{
    rt_uint32_t input_pos = 0;
    rt_uint32_t output_pos = 0;
    
    while (input_pos < input_len && output_pos + 2 < output_size) {
        rt_uint8_t current = input[input_pos];
        rt_uint8_t count = 1;
        
        while (input_pos + count < input_len && 
               input[input_pos + count] == current && 
               count < 255) {
            count++;
        }
        
        if (count >= 3) {
            output[output_pos++] = 0xFF;
            output[output_pos++] = current;
            output[output_pos++] = count;
        } else {
            if (current == 0xFF) {
                if (output_pos + 1 < output_size) {
                    output[output_pos++] = 0xFE;
                    for (rt_uint8_t i = 0; i < count && output_pos < output_size; i++) {
                        output[output_pos++] = current;
                    }
                } else {
                    for (rt_uint8_t i = 0; i < count && output_pos < output_size; i++) {
                        output[output_pos++] = current;
                    }
                }
            } else {
                for (rt_uint8_t i = 0; i < count && output_pos < output_size; i++) {
                    output[output_pos++] = current;
                }
            }
        }
        
        input_pos += count;
    }
    
    return output_pos;
}

rt_uint32_t rle_decompress(const rt_uint8_t *input, rt_uint32_t input_len, rt_uint8_t *output, rt_uint32_t output_size)
{
    rt_uint32_t input_pos = 0;
    rt_uint32_t output_pos = 0;
    
    while (input_pos < input_len && output_pos < output_size) {
        if (input[input_pos] == 0xFF && input_pos + 2 < input_len) {
            rt_uint8_t value = input[input_pos + 1];
            rt_uint8_t count = input[input_pos + 2];
            input_pos += 3;
            
            for (rt_uint8_t i = 0; i < count && output_pos < output_size; i++) {
                output[output_pos++] = value;
            }
        } else if (input[input_pos] == 0xFE && input_pos + 1 < input_len) {
            input_pos++;
            if (output_pos < output_size) {
                output[output_pos++] = 0xFF;
            }
        } else {
            if (output_pos < output_size) {
                output[output_pos++] = input[input_pos++];
            }
        }
    }
    
    return output_pos;
}

