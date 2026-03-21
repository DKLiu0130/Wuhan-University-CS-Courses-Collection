#include <rtthread.h>
#include <string.h>

#define AES_BLOCK_SIZE 16
#define AES_KEY_SIZE 16

static void aes_add_round_key(rt_uint8_t *state, const rt_uint8_t *round_key)
{
    for (int i = 0; i < AES_BLOCK_SIZE; i++) {
        state[i] ^= round_key[i];
    }
}

static rt_uint8_t aes_sbox[256] = {
    0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,
    0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0,
    0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15,
    0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75,
    0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84,
    0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b, 0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf,
    0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8,
    0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2,
    0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73,
    0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb,
    0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79,
    0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08,
    0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a,
    0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e,
    0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf,
    0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16
};

static rt_uint8_t aes_inv_sbox[256] = {
    0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38, 0xbf, 0x40, 0xa3, 0x9e, 0x81, 0xf3, 0xd7, 0xfb,
    0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f, 0xff, 0x87, 0x34, 0x8e, 0x43, 0x44, 0xc4, 0xde, 0xe9, 0xcb,
    0x54, 0x7b, 0x94, 0x32, 0xa6, 0xc2, 0x23, 0x3d, 0xee, 0x4c, 0x95, 0x0b, 0x42, 0xfa, 0xc3, 0x4e,
    0x08, 0x2e, 0xa1, 0x66, 0x28, 0xd9, 0x24, 0xb2, 0x76, 0x5b, 0xa2, 0x49, 0x6d, 0x8b, 0xd1, 0x25,
    0x72, 0xf8, 0xf6, 0x64, 0x86, 0x68, 0x98, 0x16, 0xd4, 0xa4, 0x5c, 0xcc, 0x5d, 0x65, 0xb6, 0x92,
    0x6c, 0x70, 0x48, 0x50, 0xfd, 0xed, 0xb9, 0xda, 0x5e, 0x15, 0x46, 0x57, 0xa7, 0x8d, 0x9d, 0x84,
    0x90, 0xd8, 0xab, 0x00, 0x8c, 0xbc, 0xd3, 0x0a, 0xf7, 0xe4, 0x58, 0x05, 0xb8, 0xb3, 0x45, 0x06,
    0xd0, 0x2c, 0x1e, 0x8f, 0xca, 0x3f, 0x0f, 0x02, 0xc1, 0xaf, 0xbd, 0x03, 0x01, 0x13, 0x8a, 0x6b,
    0x3a, 0x91, 0x11, 0x41, 0x4f, 0x67, 0xdc, 0xea, 0x97, 0xf2, 0xcf, 0xce, 0xf0, 0xb4, 0xe6, 0x73,
    0x96, 0xac, 0x74, 0x22, 0xe7, 0xad, 0x35, 0x85, 0xe2, 0xf9, 0x37, 0xe8, 0x1c, 0x75, 0xdf, 0x6e,
    0x47, 0xf1, 0x1a, 0x71, 0x1d, 0x29, 0xc5, 0x89, 0x6f, 0xb7, 0x62, 0x0e, 0xaa, 0x18, 0xbe, 0x1b,
    0xfc, 0x56, 0x3e, 0x4b, 0xc6, 0xd2, 0x79, 0x20, 0x9a, 0xdb, 0xc0, 0xfe, 0x78, 0xcd, 0x5a, 0xf4,
    0x1f, 0xdd, 0xa8, 0x33, 0x88, 0x07, 0xc7, 0x31, 0xb1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xec, 0x5f,
    0x60, 0x51, 0x7f, 0xa9, 0x19, 0xb5, 0x4a, 0x0d, 0x2d, 0xe5, 0x7a, 0x9f, 0x93, 0xc9, 0x9c, 0xef,
    0xa0, 0xe0, 0x3b, 0x4d, 0xae, 0x2a, 0xf5, 0xb0, 0xc8, 0xeb, 0xbb, 0x3c, 0x83, 0x53, 0x99, 0x61,
    0x17, 0x2b, 0x04, 0x7e, 0xba, 0x77, 0xd6, 0x26, 0xe1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0c, 0x7d
};

static void aes_sub_bytes(rt_uint8_t *state)
{
    for (int i = 0; i < AES_BLOCK_SIZE; i++) {
        state[i] = aes_sbox[state[i]];
    }
}

static void aes_inv_sub_bytes(rt_uint8_t *state)
{
    for (int i = 0; i < AES_BLOCK_SIZE; i++) {
        state[i] = aes_inv_sbox[state[i]];
    }
}

static void aes_shift_rows(rt_uint8_t *state)
{
    rt_uint8_t temp;
    temp = state[1];
    state[1] = state[5];
    state[5] = state[9];
    state[9] = state[13];
    state[13] = temp;
    temp = state[2];
    state[2] = state[10];
    state[10] = temp;
    temp = state[6];
    state[6] = state[14];
    state[14] = temp;
    temp = state[3];
    state[3] = state[15];
    state[15] = state[11];
    state[11] = state[7];
    state[7] = temp;
}

static void aes_inv_shift_rows(rt_uint8_t *state)
{
    rt_uint8_t temp;
    temp = state[13];
    state[13] = state[9];
    state[9] = state[5];
    state[5] = state[1];
    state[1] = temp;
    temp = state[2];
    state[2] = state[10];
    state[10] = temp;
    temp = state[6];
    state[6] = state[14];
    state[14] = temp;
    temp = state[3];
    state[3] = state[7];
    state[7] = state[11];
    state[11] = state[15];
    state[15] = temp;
}

static rt_uint8_t aes_gmul(rt_uint8_t a, rt_uint8_t b)
{
    rt_uint8_t p = 0;
    for (int i = 0; i < 8; i++) {
        if (b & 1) {
            p ^= a;
        }
        rt_uint8_t hi_bit_set = (a & 0x80);
        a <<= 1;
        if (hi_bit_set) {
            a ^= 0x1b;
        }
        b >>= 1;
    }
    return p;
}

static void aes_mix_columns(rt_uint8_t *state)
{
    rt_uint8_t temp[4];
    for (int i = 0; i < 4; i++) {
        temp[0] = state[i * 4];
        temp[1] = state[i * 4 + 1];
        temp[2] = state[i * 4 + 2];
        temp[3] = state[i * 4 + 3];
        state[i * 4] = aes_gmul(temp[0], 2) ^ aes_gmul(temp[1], 3) ^ temp[2] ^ temp[3];
        state[i * 4 + 1] = temp[0] ^ aes_gmul(temp[1], 2) ^ aes_gmul(temp[2], 3) ^ temp[3];
        state[i * 4 + 2] = temp[0] ^ temp[1] ^ aes_gmul(temp[2], 2) ^ aes_gmul(temp[3], 3);
        state[i * 4 + 3] = aes_gmul(temp[0], 3) ^ temp[1] ^ temp[2] ^ aes_gmul(temp[3], 2);
    }
}

static void aes_inv_mix_columns(rt_uint8_t *state)
{
    rt_uint8_t temp[4];
    for (int i = 0; i < 4; i++) {
        temp[0] = state[i * 4];
        temp[1] = state[i * 4 + 1];
        temp[2] = state[i * 4 + 2];
        temp[3] = state[i * 4 + 3];
        state[i * 4] = aes_gmul(temp[0], 0x0e) ^ aes_gmul(temp[1], 0x0b) ^ aes_gmul(temp[2], 0x0d) ^ aes_gmul(temp[3], 0x09);
        state[i * 4 + 1] = aes_gmul(temp[0], 0x09) ^ aes_gmul(temp[1], 0x0e) ^ aes_gmul(temp[2], 0x0b) ^ aes_gmul(temp[3], 0x0d);
        state[i * 4 + 2] = aes_gmul(temp[0], 0x0d) ^ aes_gmul(temp[1], 0x09) ^ aes_gmul(temp[2], 0x0e) ^ aes_gmul(temp[3], 0x0b);
        state[i * 4 + 3] = aes_gmul(temp[0], 0x0b) ^ aes_gmul(temp[1], 0x0d) ^ aes_gmul(temp[2], 0x09) ^ aes_gmul(temp[3], 0x0e);
    }
}

static void aes_key_expansion(const rt_uint8_t *key, rt_uint8_t *round_keys)
{
    memcpy(round_keys, key, AES_KEY_SIZE);
    rt_uint8_t temp[4];
    for (int i = 1; i < 11; i++) {
        temp[0] = round_keys[(i - 1) * 16 + 12];
        temp[1] = round_keys[(i - 1) * 16 + 13];
        temp[2] = round_keys[(i - 1) * 16 + 14];
        temp[3] = round_keys[(i - 1) * 16 + 15];
        rt_uint8_t k = temp[0];
        temp[0] = temp[1];
        temp[1] = temp[2];
        temp[2] = temp[3];
        temp[3] = k;
        temp[0] = aes_sbox[temp[0]];
        temp[1] = aes_sbox[temp[1]];
        temp[2] = aes_sbox[temp[2]];
        temp[3] = aes_sbox[temp[3]];
        temp[0] ^= (1 << (i - 1));
        for (int j = 0; j < 4; j++) {
            round_keys[i * 16 + j] = round_keys[(i - 1) * 16 + j] ^ temp[j];
        }
        for (int j = 4; j < 16; j++) {
            round_keys[i * 16 + j] = round_keys[(i - 1) * 16 + j] ^ round_keys[i * 16 + j - 4];
        }
    }
}

void aes_encrypt(const rt_uint8_t *input, const rt_uint8_t *key, rt_uint8_t *output)
{
    rt_uint8_t state[AES_BLOCK_SIZE];
    rt_uint8_t round_keys[176];
    memcpy(state, input, AES_BLOCK_SIZE);
    aes_key_expansion(key, round_keys);
    aes_add_round_key(state, round_keys);
    for (int i = 1; i < 10; i++) {
        aes_sub_bytes(state);
        aes_shift_rows(state);
        aes_mix_columns(state);
        aes_add_round_key(state, round_keys + i * 16);
    }
    aes_sub_bytes(state);
    aes_shift_rows(state);
    aes_add_round_key(state, round_keys + 10 * 16);
    memcpy(output, state, AES_BLOCK_SIZE);
}

void aes_decrypt(const rt_uint8_t *input, const rt_uint8_t *key, rt_uint8_t *output)
{
    rt_uint8_t state[AES_BLOCK_SIZE];
    rt_uint8_t round_keys[176];
    memcpy(state, input, AES_BLOCK_SIZE);
    aes_key_expansion(key, round_keys);
    aes_add_round_key(state, round_keys + 10 * 16);
    for (int i = 9; i > 0; i--) {
        aes_inv_shift_rows(state);
        aes_inv_sub_bytes(state);
        aes_add_round_key(state, round_keys + i * 16);
        aes_inv_mix_columns(state);
    }
    aes_inv_shift_rows(state);
    aes_inv_sub_bytes(state);
    aes_add_round_key(state, round_keys);
    memcpy(output, state, AES_BLOCK_SIZE);
}

void xor_encrypt(const rt_uint8_t *input, rt_uint32_t input_len, const rt_uint8_t *key, rt_uint32_t key_len, rt_uint8_t *output)
{
    for (rt_uint32_t i = 0; i < input_len; i++) {
        output[i] = input[i] ^ key[i % key_len];
    }
}

void xor_decrypt(const rt_uint8_t *input, rt_uint32_t input_len, const rt_uint8_t *key, rt_uint32_t key_len, rt_uint8_t *output)
{
    xor_encrypt(input, input_len, key, key_len, output);
}

#define SM4_BLOCK_SIZE 16
#define SM4_KEY_SIZE 16
#define SM3_HASH_SIZE 32

static rt_uint8_t sm4_sbox[256] = {
    0xd6, 0x90, 0xe9, 0xfe, 0xcc, 0xe1, 0x3d, 0xb7, 0x16, 0xb6, 0x14, 0xc2, 0x28, 0xfb, 0x2c, 0x05,
    0x2b, 0x67, 0x9a, 0x76, 0x2a, 0xbe, 0x04, 0xc3, 0xaa, 0x44, 0x13, 0x26, 0x49, 0x86, 0x06, 0x99,
    0x9c, 0x42, 0x50, 0xf4, 0x91, 0xef, 0x98, 0x7a, 0x33, 0x54, 0x0b, 0x43, 0xed, 0xcf, 0xac, 0x62,
    0xe4, 0xb3, 0x1c, 0xa9, 0xc9, 0x08, 0xe8, 0x95, 0x80, 0xdf, 0x94, 0xfa, 0x75, 0x8f, 0x3f, 0xa6,
    0x47, 0x07, 0xa7, 0xfc, 0xf3, 0x73, 0x17, 0xba, 0x83, 0x59, 0x3c, 0x19, 0xe6, 0x85, 0x4f, 0xa8,
    0x68, 0x6b, 0x81, 0xb2, 0x71, 0x64, 0xda, 0x8b, 0xf8, 0xeb, 0x0f, 0x4b, 0x70, 0x56, 0x9d, 0x35,
    0x1e, 0x24, 0x0e, 0x5e, 0x63, 0x58, 0xd1, 0xa2, 0x25, 0x22, 0x7c, 0x3b, 0x01, 0x21, 0x78, 0x87,
    0xd4, 0x00, 0x46, 0x57, 0x9f, 0xd3, 0x27, 0x52, 0x4c, 0x36, 0x02, 0xe7, 0xa0, 0xc4, 0xc8, 0x9e,
    0xea, 0xbf, 0x8a, 0xd2, 0x40, 0xc7, 0x38, 0xb5, 0xa3, 0xf7, 0xf2, 0xce, 0xf9, 0x61, 0x15, 0xa1,
    0xe0, 0xae, 0x5d, 0xa4, 0x9b, 0x34, 0x1a, 0x55, 0xad, 0x93, 0x32, 0x30, 0xf5, 0x8c, 0xb1, 0xe3,
    0x1d, 0xf6, 0xe2, 0x2e, 0x82, 0x66, 0xca, 0x60, 0xc0, 0x29, 0x23, 0xab, 0x0d, 0x53, 0x4e, 0x6f,
    0xd5, 0xdb, 0x37, 0x45, 0xde, 0xfd, 0x8e, 0x2f, 0x03, 0xff, 0x6a, 0x72, 0x6d, 0x6c, 0x5b, 0x51,
    0x8d, 0x1b, 0xaf, 0x92, 0xbb, 0xdd, 0xbc, 0x7f, 0x11, 0xd9, 0x5c, 0x41, 0x1f, 0x10, 0x5a, 0xd8,
    0x0a, 0xc1, 0x31, 0x88, 0xa5, 0xcd, 0x7b, 0xbd, 0x2d, 0x74, 0xd0, 0x12, 0xb8, 0xe5, 0xb4, 0xb0,
    0x89, 0x69, 0x97, 0x4a, 0x0c, 0x96, 0x77, 0x7e, 0x65, 0xb9, 0xf1, 0x09, 0xc5, 0x6e, 0xc6, 0x84,
    0x18, 0xf0, 0x7d, 0xec, 0x3a, 0xdc, 0x4d, 0x20, 0x79, 0xee, 0x5f, 0x3e, 0xd7, 0xcb, 0x39, 0x48
};

static rt_uint32_t sm4_fk[4] = {
    0xa3b1bac6, 0x56aa3350, 0x677d9197, 0xb27022dc
};

static rt_uint32_t sm4_ck[32] = {
    0x00070e15, 0x1c232a31, 0x383f464d, 0x545b6269,
    0x70777e85, 0x8c939aa1, 0xa8afb6bd, 0xc4cbd2d9,
    0xe0e7eef5, 0xfc030a11, 0x181f262d, 0x343b4249,
    0x50575e65, 0x6c737a81, 0x888f969d, 0xa4abb2b9,
    0xc0c7ced5, 0xdce3eaf1, 0xf8ff060d, 0x141b2229,
    0x30373e45, 0x4c535a61, 0x686f767d, 0x848b9299,
    0xa0a7aeb5, 0xbcc3cad1, 0xd8dfe6ed, 0xf4fb0209,
    0x10171e25, 0x2c333a41, 0x484f565d, 0x646b7279
};

static rt_uint32_t sm4_rotl(rt_uint32_t x, rt_uint32_t n)
{
    return ((x << n) | (x >> (32 - n)));
}

static rt_uint32_t sm4_tau(rt_uint32_t x)
{
    rt_uint32_t a0 = sm4_sbox[(x >> 24) & 0xff];
    rt_uint32_t a1 = sm4_sbox[(x >> 16) & 0xff];
    rt_uint32_t a2 = sm4_sbox[(x >> 8) & 0xff];
    rt_uint32_t a3 = sm4_sbox[x & 0xff];
    return (a0 << 24) | (a1 << 16) | (a2 << 8) | a3;
}

static rt_uint32_t sm4_l(rt_uint32_t x)
{
    return x ^ sm4_rotl(x, 2) ^ sm4_rotl(x, 10) ^ sm4_rotl(x, 18) ^ sm4_rotl(x, 24);
}

static rt_uint32_t sm4_l_prime(rt_uint32_t x)
{
    return x ^ sm4_rotl(x, 13) ^ sm4_rotl(x, 23);
}

static void sm4_key_expansion(const rt_uint8_t *key, rt_uint32_t *rk)
{
    rt_uint32_t mk[4];
    mk[0] = (key[0] << 24) | (key[1] << 16) | (key[2] << 8) | key[3];
    mk[1] = (key[4] << 24) | (key[5] << 16) | (key[6] << 8) | key[7];
    mk[2] = (key[8] << 24) | (key[9] << 16) | (key[10] << 8) | key[11];
    mk[3] = (key[12] << 24) | (key[13] << 16) | (key[14] << 8) | key[15];
    
    rt_uint32_t k[36];
    k[0] = mk[0] ^ sm4_fk[0];
    k[1] = mk[1] ^ sm4_fk[1];
    k[2] = mk[2] ^ sm4_fk[2];
    k[3] = mk[3] ^ sm4_fk[3];
    
    for (int i = 0; i < 32; i++) {
        k[i + 4] = k[i] ^ sm4_l_prime(sm4_tau(k[i + 1] ^ k[i + 2] ^ k[i + 3] ^ sm4_ck[i]));
        rk[i] = k[i + 4];
    }
}

static void sm4_f(rt_uint32_t *x, rt_uint32_t rk)
{
    rt_uint32_t t = x[1] ^ x[2] ^ x[3] ^ rk;
    t = sm4_tau(t);
    x[0] = x[0] ^ sm4_l(t);
}

void sm4_encrypt(const rt_uint8_t *input, const rt_uint8_t *key, rt_uint8_t *output)
{
    rt_uint32_t x[4];
    x[0] = (input[0] << 24) | (input[1] << 16) | (input[2] << 8) | input[3];
    x[1] = (input[4] << 24) | (input[5] << 16) | (input[6] << 8) | input[7];
    x[2] = (input[8] << 24) | (input[9] << 16) | (input[10] << 8) | input[11];
    x[3] = (input[12] << 24) | (input[13] << 16) | (input[14] << 8) | input[15];
    
    rt_uint32_t rk[32];
    sm4_key_expansion(key, rk);
    
    for (int i = 0; i < 32; i++) {
        sm4_f(x, rk[i]);
        rt_uint32_t temp = x[0];
        x[0] = x[1];
        x[1] = x[2];
        x[2] = x[3];
        x[3] = temp;
    }
    
    rt_uint32_t temp = x[0];
    x[0] = x[3];
    x[3] = temp;
    temp = x[1];
    x[1] = x[2];
    x[2] = temp;
    
    output[0] = (x[0] >> 24) & 0xff;
    output[1] = (x[0] >> 16) & 0xff;
    output[2] = (x[0] >> 8) & 0xff;
    output[3] = x[0] & 0xff;
    output[4] = (x[1] >> 24) & 0xff;
    output[5] = (x[1] >> 16) & 0xff;
    output[6] = (x[1] >> 8) & 0xff;
    output[7] = x[1] & 0xff;
    output[8] = (x[2] >> 24) & 0xff;
    output[9] = (x[2] >> 16) & 0xff;
    output[10] = (x[2] >> 8) & 0xff;
    output[11] = x[2] & 0xff;
    output[12] = (x[3] >> 24) & 0xff;
    output[13] = (x[3] >> 16) & 0xff;
    output[14] = (x[3] >> 8) & 0xff;
    output[15] = x[3] & 0xff;
}

void sm4_decrypt(const rt_uint8_t *input, const rt_uint8_t *key, rt_uint8_t *output)
{
    rt_uint32_t x[4];
    x[0] = (input[0] << 24) | (input[1] << 16) | (input[2] << 8) | input[3];
    x[1] = (input[4] << 24) | (input[5] << 16) | (input[6] << 8) | input[7];
    x[2] = (input[8] << 24) | (input[9] << 16) | (input[10] << 8) | input[11];
    x[3] = (input[12] << 24) | (input[13] << 16) | (input[14] << 8) | input[15];
    
    rt_uint32_t rk[32];
    sm4_key_expansion(key, rk);
    
    for (int i = 31; i >= 0; i--) {
        sm4_f(x, rk[i]);
        rt_uint32_t temp = x[0];
        x[0] = x[1];
        x[1] = x[2];
        x[2] = x[3];
        x[3] = temp;
    }
    
    rt_uint32_t temp = x[0];
    x[0] = x[3];
    x[3] = temp;
    temp = x[1];
    x[1] = x[2];
    x[2] = temp;
    
    output[0] = (x[0] >> 24) & 0xff;
    output[1] = (x[0] >> 16) & 0xff;
    output[2] = (x[0] >> 8) & 0xff;
    output[3] = x[0] & 0xff;
    output[4] = (x[1] >> 24) & 0xff;
    output[5] = (x[1] >> 16) & 0xff;
    output[6] = (x[1] >> 8) & 0xff;
    output[7] = x[1] & 0xff;
    output[8] = (x[2] >> 24) & 0xff;
    output[9] = (x[2] >> 16) & 0xff;
    output[10] = (x[2] >> 8) & 0xff;
    output[11] = x[2] & 0xff;
    output[12] = (x[3] >> 24) & 0xff;
    output[13] = (x[3] >> 16) & 0xff;
    output[14] = (x[3] >> 8) & 0xff;
    output[15] = x[3] & 0xff;
}

static rt_uint32_t sm3_tj[64] = {
    0x79cc4519, 0x79cc4519, 0x79cc4519, 0x79cc4519, 0x79cc4519, 0x79cc4519, 0x79cc4519, 0x79cc4519,
    0x79cc4519, 0x79cc4519, 0x79cc4519, 0x79cc4519, 0x79cc4519, 0x79cc4519, 0x79cc4519, 0x79cc4519,
    0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a,
    0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a,
    0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a,
    0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a,
    0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a,
    0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a, 0x7a879d8a
};

static rt_uint32_t sm3_iv[8] = {
    0x7380166f, 0x4914b2b9, 0x172442d7, 0xda8a0600,
    0xa96f30bc, 0x163138aa, 0xe38dee4d, 0xb0fb0e4e
};

static rt_uint32_t sm3_ff(rt_uint32_t x, rt_uint32_t y, rt_uint32_t z, int j)
{
    if (j < 16) {
        return x ^ y ^ z;
    } else {
        return (x & y) | (x & z) | (y & z);
    }
}

static rt_uint32_t sm3_gg(rt_uint32_t x, rt_uint32_t y, rt_uint32_t z, int j)
{
    if (j < 16) {
        return x ^ y ^ z;
    } else {
        return (x & y) | ((~x) & z);
    }
}

static rt_uint32_t sm3_p0(rt_uint32_t x)
{
    return x ^ sm4_rotl(x, 9) ^ sm4_rotl(x, 17);
}

static rt_uint32_t sm3_p1(rt_uint32_t x)
{
    return x ^ sm4_rotl(x, 15) ^ sm4_rotl(x, 23);
}

void sm3_hash(const rt_uint8_t *input, rt_uint32_t input_len, rt_uint8_t *output)
{
    rt_uint32_t v[8];
    for (int i = 0; i < 8; i++) {
        v[i] = sm3_iv[i];
    }
    
    rt_uint32_t total_len = input_len * 8;
    rt_uint32_t pad_len = 64 - ((input_len + 9) % 64);
    if (pad_len == 64) pad_len = 0;
    rt_uint32_t total_padded = input_len + pad_len + 9;
    rt_uint32_t block_count = total_padded / 64;
    
    rt_uint8_t *padded = rt_malloc(total_padded);
    if (!padded) return;
    
    memcpy(padded, input, input_len);
    padded[input_len] = 0x80;
    memset(padded + input_len + 1, 0, pad_len);
    
    padded[total_padded - 8] = (total_len >> 56) & 0xff;
    padded[total_padded - 7] = (total_len >> 48) & 0xff;
    padded[total_padded - 6] = (total_len >> 40) & 0xff;
    padded[total_padded - 5] = (total_len >> 32) & 0xff;
    padded[total_padded - 4] = (total_len >> 24) & 0xff;
    padded[total_padded - 3] = (total_len >> 16) & 0xff;
    padded[total_padded - 2] = (total_len >> 8) & 0xff;
    padded[total_padded - 1] = total_len & 0xff;
    
    for (rt_uint32_t i = 0; i < block_count; i++) {
        rt_uint32_t w[68];
        rt_uint32_t w1[64];
        
        for (int j = 0; j < 16; j++) {
            w[j] = (padded[i * 64 + j * 4] << 24) | (padded[i * 64 + j * 4 + 1] << 16) |
                   (padded[i * 64 + j * 4 + 2] << 8) | padded[i * 64 + j * 4 + 3];
        }
        
        for (int j = 16; j < 68; j++) {
            w[j] = sm3_p1(w[j - 16] ^ w[j - 9] ^ sm4_rotl(w[j - 3], 15)) ^
                   sm4_rotl(w[j - 13], 7) ^ w[j - 6];
        }
        
        for (int j = 0; j < 64; j++) {
            w1[j] = w[j] ^ w[j + 4];
        }
        
        rt_uint32_t a = v[0];
        rt_uint32_t b = v[1];
        rt_uint32_t c = v[2];
        rt_uint32_t d = v[3];
        rt_uint32_t e = v[4];
        rt_uint32_t f = v[5];
        rt_uint32_t g = v[6];
        rt_uint32_t h = v[7];
        
        for (int j = 0; j < 64; j++) {
            rt_uint32_t ss1 = sm4_rotl((sm4_rotl(a, 12) + e + sm4_rotl(sm3_tj[j], j)) & 0xffffffff, 7);
            rt_uint32_t ss2 = ss1 ^ sm4_rotl(a, 12);
            rt_uint32_t tt1 = (sm3_ff(a, b, c, j) + d + ss2 + w1[j]) & 0xffffffff;
            rt_uint32_t tt2 = (sm3_gg(e, f, g, j) + h + ss1 + w[j]) & 0xffffffff;
            d = c;
            c = sm4_rotl(b, 9);
            b = a;
            a = tt1;
            h = g;
            g = sm4_rotl(f, 19);
            f = e;
            e = sm3_p0(tt2);
        }
        
        v[0] ^= a;
        v[1] ^= b;
        v[2] ^= c;
        v[3] ^= d;
        v[4] ^= e;
        v[5] ^= f;
        v[6] ^= g;
        v[7] ^= h;
    }
    
    for (int i = 0; i < 8; i++) {
        output[i * 4] = (v[i] >> 24) & 0xff;
        output[i * 4 + 1] = (v[i] >> 16) & 0xff;
        output[i * 4 + 2] = (v[i] >> 8) & 0xff;
        output[i * 4 + 3] = v[i] & 0xff;
    }
    
    rt_free(padded);
}

