#ifndef CRYPTO_H__
#define CRYPTO_H__

#include <rtthread.h>

#define AES_BLOCK_SIZE 16
#define AES_KEY_SIZE 16
#define SM4_BLOCK_SIZE 16
#define SM4_KEY_SIZE 16
#define SM3_HASH_SIZE 32

void aes_encrypt(const rt_uint8_t *input, const rt_uint8_t *key, rt_uint8_t *output);
void aes_decrypt(const rt_uint8_t *input, const rt_uint8_t *key, rt_uint8_t *output);
void xor_encrypt(const rt_uint8_t *input, rt_uint32_t input_len, const rt_uint8_t *key, rt_uint32_t key_len, rt_uint8_t *output);
void xor_decrypt(const rt_uint8_t *input, rt_uint32_t input_len, const rt_uint8_t *key, rt_uint32_t key_len, rt_uint8_t *output);
void sm3_hash(const rt_uint8_t *input, rt_uint32_t input_len, rt_uint8_t *output);
void sm4_encrypt(const rt_uint8_t *input, const rt_uint8_t *key, rt_uint8_t *output);
void sm4_decrypt(const rt_uint8_t *input, const rt_uint8_t *key, rt_uint8_t *output);

#endif

