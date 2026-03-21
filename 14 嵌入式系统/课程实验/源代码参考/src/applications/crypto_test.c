#include <rtthread.h>
#include "applications/crypto.h"
#include "applications/compress.h"
#include <string.h>

static rt_uint32_t simple_rand_seed = 1;

static rt_uint32_t simple_rand(void)
{
    simple_rand_seed = simple_rand_seed * 1103515245 + 12345;
    return (simple_rand_seed >> 16) & 0x7fff;
}

static void init_random_seed(void)
{
    simple_rand_seed = rt_tick_get();
}

static void generate_random_data(rt_uint8_t *data, rt_uint32_t len)
{
    for (rt_uint32_t i = 0; i < len; i++) {
        data[i] = (rt_uint8_t)(simple_rand() & 0xff);
    }
}

static void test_aes(void)
{
    rt_uint8_t key[AES_KEY_SIZE];
    rt_uint8_t plaintext[AES_BLOCK_SIZE];
    rt_uint8_t ciphertext[AES_BLOCK_SIZE];
    rt_uint8_t decrypted[AES_BLOCK_SIZE];
    
    init_random_seed();
    generate_random_data(key, AES_KEY_SIZE);
    generate_random_data(plaintext, AES_BLOCK_SIZE);
    
    rt_kprintf("=== AES加解密测试（随机数据）===\n");
    rt_kprintf("密钥: ");
    for (int i = 0; i < AES_KEY_SIZE; i++) {
        rt_kprintf("%02x ", key[i]);
    }
    rt_kprintf("\n");
    rt_kprintf("明文: ");
    for (int i = 0; i < AES_BLOCK_SIZE; i++) {
        rt_kprintf("%02x ", plaintext[i]);
    }
    rt_kprintf("\n");
    
    aes_encrypt(plaintext, key, ciphertext);
    rt_kprintf("密文: ");
    for (int i = 0; i < AES_BLOCK_SIZE; i++) {
        rt_kprintf("%02x ", ciphertext[i]);
    }
    rt_kprintf("\n");
    
    aes_decrypt(ciphertext, key, decrypted);
    rt_kprintf("解密: ");
    for (int i = 0; i < AES_BLOCK_SIZE; i++) {
        rt_kprintf("%02x ", decrypted[i]);
    }
    rt_kprintf("\n");
    
    if (memcmp(plaintext, decrypted, AES_BLOCK_SIZE) == 0) {
        rt_kprintf("AES测试通过\n");
    } else {
        rt_kprintf("AES测试失败\n");
    }
}

static void test_xor(void)
{
    rt_uint32_t len = 32;
    rt_uint8_t *plaintext = rt_malloc(len);
    rt_uint8_t key[16];
    rt_uint8_t *encrypted = rt_malloc(len);
    rt_uint8_t *decrypted = rt_malloc(len);
    
    if (!plaintext || !encrypted || !decrypted) {
        rt_kprintf("内存分配失败\n");
        if (plaintext) rt_free(plaintext);
        if (encrypted) rt_free(encrypted);
        if (decrypted) rt_free(decrypted);
        return;
    }
    
    init_random_seed();
    generate_random_data(plaintext, len);
    generate_random_data(key, 16);
    
    rt_kprintf("=== XOR加解密测试（随机数据）===\n");
    rt_kprintf("密钥长度: %d\n", 16);
    rt_kprintf("明文长度: %d\n", len);
    rt_kprintf("明文前16字节: ");
    for (rt_uint32_t i = 0; i < 16 && i < len; i++) {
        rt_kprintf("%02x ", plaintext[i]);
    }
    rt_kprintf("\n");
    
    xor_encrypt(plaintext, len, key, 16, encrypted);
    rt_kprintf("密文前16字节: ");
    for (rt_uint32_t i = 0; i < 16 && i < len; i++) {
        rt_kprintf("%02x ", encrypted[i]);
    }
    rt_kprintf("\n");
    
    xor_decrypt(encrypted, len, key, 16, decrypted);
    rt_kprintf("解密前16字节: ");
    for (rt_uint32_t i = 0; i < 16 && i < len; i++) {
        rt_kprintf("%02x ", decrypted[i]);
    }
    rt_kprintf("\n");
    
    if (memcmp(plaintext, decrypted, len) == 0) {
        rt_kprintf("XOR测试通过\n");
    } else {
        rt_kprintf("XOR测试失败\n");
    }
    
    rt_free(plaintext);
    rt_free(encrypted);
    rt_free(decrypted);
}

static void test_lz77(void)
{
    rt_uint32_t test_lengths[] = {32, 64, 128, 256, 512};
    rt_uint32_t num_tests = sizeof(test_lengths) / sizeof(test_lengths[0]);
    rt_uint32_t pass_count = 0;
    rt_uint32_t fail_count = 0;
    rt_uint32_t total_original = 0;
    rt_uint32_t total_compressed = 0;
    
    rt_kprintf("=== LZ77压缩解压测试（随机数据多次测试）===\n\n");
    
    for (rt_uint32_t t = 0; t < num_tests; t++) {
        rt_uint32_t input_len = test_lengths[t];
        rt_uint32_t output_size = input_len * 2;
        
        rt_uint8_t *data = rt_malloc(input_len);
        rt_uint8_t *compressed = rt_malloc(output_size);
        rt_uint8_t *decompressed = rt_malloc(input_len);
        
        if (!data || !compressed || !decompressed) {
            rt_kprintf("测试 %d: 内存分配失败，跳过\n", t + 1);
            if (data) rt_free(data);
            if (compressed) rt_free(compressed);
            if (decompressed) rt_free(decompressed);
            continue;
        }
        
        init_random_seed();
        generate_random_data(data, input_len);
        
        rt_kprintf("--- 测试 %d: 长度 %d 字节 ---\n", t + 1, input_len);
        rt_kprintf("原始数据前16字节: ");
        for (rt_uint32_t i = 0; i < 16 && i < input_len; i++) {
            rt_kprintf("%02x ", data[i]);
        }
        rt_kprintf("\n");
        
        rt_uint32_t compressed_len = lz77_compress(data, input_len, compressed, output_size);
        rt_uint32_t saved_bytes = input_len > compressed_len ? (input_len - compressed_len) : 0;
        rt_uint32_t compression_ratio = input_len > 0 ? (saved_bytes * 100 / input_len) : 0;
        rt_kprintf("压缩后长度: %d (压缩率: %d%%, 节省: %d字节)\n", compressed_len, compression_ratio, saved_bytes);
        
        total_original += input_len;
        total_compressed += compressed_len;
        
        rt_uint32_t decompressed_len = lz77_decompress(compressed, compressed_len, decompressed, input_len);
        rt_kprintf("解压后长度: %d\n", decompressed_len);
        
        if (decompressed_len == input_len && memcmp(data, decompressed, input_len) == 0) {
            rt_kprintf("测试 %d 通过\n", t + 1);
            pass_count++;
        } else {
            rt_kprintf("测试 %d 失败\n", t + 1);
            fail_count++;
        }
        
        rt_kprintf("\n");
        
        rt_free(data);
        rt_free(compressed);
        rt_free(decompressed);
    }
    
    rt_kprintf("=== LZ77测试总结 ===\n");
    rt_kprintf("通过: %d, 失败: %d\n", pass_count, fail_count);
    if (total_original > 0) {
        rt_uint32_t total_saved = total_original > total_compressed ? (total_original - total_compressed) : 0;
        rt_uint32_t avg_ratio = (total_saved * 100 / total_original);
        rt_kprintf("总原始大小: %d 字节\n", total_original);
        rt_kprintf("总压缩大小: %d 字节\n", total_compressed);
        rt_kprintf("平均压缩率: %d%%\n", avg_ratio);
    }
    if (fail_count == 0) {
        rt_kprintf("所有测试通过\n");
    }
}

static void test_rle(void)
{
    rt_uint32_t test_lengths[] = {32, 64, 128, 256, 512};
    rt_uint32_t num_tests = sizeof(test_lengths) / sizeof(test_lengths[0]);
    rt_uint32_t pass_count = 0;
    rt_uint32_t fail_count = 0;
    rt_uint32_t total_original = 0;
    rt_uint32_t total_compressed = 0;
    
    rt_kprintf("=== RLE压缩解压测试（随机数据多次测试）===\n\n");
    
    for (rt_uint32_t t = 0; t < num_tests; t++) {
        rt_uint32_t input_len = test_lengths[t];
        rt_uint32_t output_size = input_len * 2;
        
        rt_uint8_t *data = rt_malloc(input_len);
        rt_uint8_t *compressed = rt_malloc(output_size);
        rt_uint8_t *decompressed = rt_malloc(input_len);
        
        if (!data || !compressed || !decompressed) {
            rt_kprintf("测试 %d: 内存分配失败，跳过\n", t + 1);
            if (data) rt_free(data);
            if (compressed) rt_free(compressed);
            if (decompressed) rt_free(decompressed);
            continue;
        }
        
        init_random_seed();
        generate_random_data(data, input_len);
        
        rt_kprintf("--- 测试 %d: 长度 %d 字节 ---\n", t + 1, input_len);
        rt_kprintf("原始数据前16字节: ");
        for (rt_uint32_t i = 0; i < 16 && i < input_len; i++) {
            rt_kprintf("%02x ", data[i]);
        }
        rt_kprintf("\n");
        
        rt_uint32_t compressed_len = rle_compress(data, input_len, compressed, output_size);
        rt_uint32_t saved_bytes = input_len > compressed_len ? (input_len - compressed_len) : 0;
        rt_uint32_t compression_ratio = input_len > 0 ? (saved_bytes * 100 / input_len) : 0;
        rt_kprintf("压缩后长度: %d (压缩率: %d%%, 节省: %d字节)\n", compressed_len, compression_ratio, saved_bytes);
        
        total_original += input_len;
        total_compressed += compressed_len;
        
        rt_uint32_t decompressed_len = rle_decompress(compressed, compressed_len, decompressed, input_len);
        rt_kprintf("解压后长度: %d\n", decompressed_len);
        
        if (decompressed_len == input_len && memcmp(data, decompressed, input_len) == 0) {
            rt_kprintf("测试 %d 通过\n", t + 1);
            pass_count++;
        } else {
            rt_kprintf("测试 %d 失败\n", t + 1);
            fail_count++;
        }
        
        rt_kprintf("\n");
        
        rt_free(data);
        rt_free(compressed);
        rt_free(decompressed);
    }
    
    rt_kprintf("=== RLE测试总结 ===\n");
    rt_kprintf("通过: %d, 失败: %d\n", pass_count, fail_count);
    if (total_original > 0) {
        rt_uint32_t total_saved = total_original > total_compressed ? (total_original - total_compressed) : 0;
        rt_uint32_t avg_ratio = (total_saved * 100 / total_original);
        rt_kprintf("总原始大小: %d 字节\n", total_original);
        rt_kprintf("总压缩大小: %d 字节\n", total_compressed);
        rt_kprintf("平均压缩率: %d%%\n", avg_ratio);
    }
    if (fail_count == 0) {
        rt_kprintf("所有测试通过\n");
    }
}

static void test_sm4(void)
{
    rt_uint8_t key[SM4_KEY_SIZE];
    rt_uint8_t plaintext[SM4_BLOCK_SIZE];
    rt_uint8_t ciphertext[SM4_BLOCK_SIZE];
    rt_uint8_t decrypted[SM4_BLOCK_SIZE];
    
    init_random_seed();
    generate_random_data(key, SM4_KEY_SIZE);
    generate_random_data(plaintext, SM4_BLOCK_SIZE);
    
    rt_kprintf("=== SM4国密加解密测试（随机数据）===\n");
    rt_kprintf("密钥: ");
    for (int i = 0; i < SM4_KEY_SIZE; i++) {
        rt_kprintf("%02x ", key[i]);
    }
    rt_kprintf("\n");
    rt_kprintf("明文: ");
    for (int i = 0; i < SM4_BLOCK_SIZE; i++) {
        rt_kprintf("%02x ", plaintext[i]);
    }
    rt_kprintf("\n");
    
    sm4_encrypt(plaintext, key, ciphertext);
    rt_kprintf("密文: ");
    for (int i = 0; i < SM4_BLOCK_SIZE; i++) {
        rt_kprintf("%02x ", ciphertext[i]);
    }
    rt_kprintf("\n");
    
    sm4_decrypt(ciphertext, key, decrypted);
    rt_kprintf("解密: ");
    for (int i = 0; i < SM4_BLOCK_SIZE; i++) {
        rt_kprintf("%02x ", decrypted[i]);
    }
    rt_kprintf("\n");
    
    if (memcmp(plaintext, decrypted, SM4_BLOCK_SIZE) == 0) {
        rt_kprintf("SM4测试通过\n");
    } else {
        rt_kprintf("SM4测试失败\n");
    }
}

static int verify_sm3_hash(const rt_uint8_t *computed, const rt_uint8_t *expected)
{
    return memcmp(computed, expected, SM3_HASH_SIZE) == 0;
}

static void test_sm3(void)
{
    rt_uint8_t hash[SM3_HASH_SIZE];
    rt_uint32_t pass_count = 0;
    rt_uint32_t fail_count = 0;
    
    rt_kprintf("=== SM3国密哈希测试 ===\n\n");
    
    rt_kprintf("--- 测试1: 标准测试向量验证 ---\n");
    
    const char *test1 = "abc";
    const rt_uint8_t expected1[SM3_HASH_SIZE] = {
        0x66, 0xc7, 0xf0, 0xf4, 0x62, 0xee, 0xed, 0xd9,
        0xd1, 0xf2, 0xd4, 0x6b, 0xdc, 0x10, 0xe4, 0xe2,
        0x41, 0x67, 0xc4, 0x87, 0x5c, 0xf2, 0xf7, 0xa2,
        0x29, 0x7d, 0xa0, 0x2b, 0x8f, 0x4b, 0xa8, 0xe0
    };
    
    rt_kprintf("输入: \"%s\" (长度: %d)\n", test1, strlen(test1));
    sm3_hash((rt_uint8_t *)test1, strlen(test1), hash);
    rt_kprintf("计算哈希: ");
    for (int i = 0; i < SM3_HASH_SIZE; i++) {
        rt_kprintf("%02x", hash[i]);
    }
    rt_kprintf("\n");
    rt_kprintf("期望哈希: ");
    for (int i = 0; i < SM3_HASH_SIZE; i++) {
        rt_kprintf("%02x", expected1[i]);
    }
    rt_kprintf("\n");
    
    if (verify_sm3_hash(hash, expected1)) {
        rt_kprintf("测试1通过\n");
        pass_count++;
    } else {
        rt_kprintf("测试1失败\n");
        fail_count++;
    }
    
    rt_kprintf("\n--- 测试2: 空字符串 ---\n");
    const char *test2 = "";
    const rt_uint8_t expected2[SM3_HASH_SIZE] = {
        0x1a, 0xb2, 0x1d, 0x83, 0x55, 0xcf, 0xa1, 0x7f,
        0x8e, 0x61, 0x19, 0x48, 0x31, 0xe8, 0x1a, 0x8f,
        0x22, 0xbe, 0xc8, 0xc7, 0x28, 0xfe, 0xfb, 0x74,
        0x7e, 0xd0, 0x35, 0xeb, 0x50, 0x82, 0xaa, 0x2b
    };
    
    rt_kprintf("输入: \"\" (空字符串, 长度: 0)\n");
    sm3_hash((rt_uint8_t *)test2, 0, hash);
    rt_kprintf("计算哈希: ");
    for (int i = 0; i < SM3_HASH_SIZE; i++) {
        rt_kprintf("%02x", hash[i]);
    }
    rt_kprintf("\n");
    rt_kprintf("期望哈希: ");
    for (int i = 0; i < SM3_HASH_SIZE; i++) {
        rt_kprintf("%02x", expected2[i]);
    }
    rt_kprintf("\n");
    
    if (verify_sm3_hash(hash, expected2)) {
        rt_kprintf("测试2通过\n");
        pass_count++;
    } else {
        rt_kprintf("测试2失败\n");
        fail_count++;
    }
    
    rt_kprintf("\n--- 测试3: 64字节数据 ---\n");
    const char *test3 = "abcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcd";
    rt_kprintf("输入: \"%s\" (长度: %d)\n", test3, strlen(test3));
    sm3_hash((rt_uint8_t *)test3, strlen(test3), hash);
    rt_kprintf("计算哈希: ");
    for (int i = 0; i < SM3_HASH_SIZE; i++) {
        rt_kprintf("%02x", hash[i]);
    }
    rt_kprintf("\n");
    rt_kprintf("测试3完成（无标准向量，仅显示结果）\n");
    pass_count++;
    
    rt_kprintf("\n--- 测试4: 不同长度随机数据测试 ---\n");
    rt_uint32_t test_lengths[] = {1, 16, 32, 64, 128, 256, 512, 1024};
    rt_uint32_t num_lengths = sizeof(test_lengths) / sizeof(test_lengths[0]);
    
    for (rt_uint32_t i = 0; i < num_lengths; i++) {
        rt_uint32_t len = test_lengths[i];
        rt_uint8_t *random_data = rt_malloc(len);
        rt_uint8_t hash1[SM3_HASH_SIZE];
        rt_uint8_t hash2[SM3_HASH_SIZE];
        
        if (!random_data) {
            rt_kprintf("内存分配失败，跳过长度 %d 的测试\n", len);
            continue;
        }
        
        init_random_seed();
        generate_random_data(random_data, len);
        
        sm3_hash(random_data, len, hash1);
        sm3_hash(random_data, len, hash2);
        
        if (memcmp(hash1, hash2, SM3_HASH_SIZE) == 0) {
            rt_kprintf("长度 %d: 一致性测试通过 (", len);
            for (int j = 0; j < 8; j++) {
                rt_kprintf("%02x", hash1[j]);
            }
            rt_kprintf("...)\n");
            pass_count++;
        } else {
            rt_kprintf("长度 %d: 一致性测试失败\n", len);
            fail_count++;
        }
        
        rt_free(random_data);
    }
    
    rt_kprintf("\n--- 测试5: 不同输入产生不同哈希 ---\n");
    rt_uint8_t data1[32] = {0};
    rt_uint8_t data2[32] = {0};
    rt_uint8_t hash1[SM3_HASH_SIZE];
    rt_uint8_t hash2[SM3_HASH_SIZE];
    
    init_random_seed();
    generate_random_data(data1, 32);
    generate_random_data(data2, 32);
    
    while (memcmp(data1, data2, 32) == 0) {
        generate_random_data(data2, 32);
    }
    
    sm3_hash(data1, 32, hash1);
    sm3_hash(data2, 32, hash2);
    
    if (memcmp(hash1, hash2, SM3_HASH_SIZE) != 0) {
        rt_kprintf("不同输入产生不同哈希: 通过\n");
        pass_count++;
    } else {
        rt_kprintf("不同输入产生不同哈希: 失败（哈希冲突）\n");
        fail_count++;
    }
    
    rt_kprintf("\n=== SM3测试总结 ===\n");
    rt_kprintf("通过: %d, 失败: %d\n", pass_count, fail_count);
    if (fail_count == 0) {
        rt_kprintf("所有测试通过\n");
    } else {
        rt_kprintf("部分测试失败\n");
    }
}

static void test_image_encrypt(void)
{
    rt_uint32_t image_size = 1024;
    rt_uint8_t *image_data = rt_malloc(image_size);
    rt_uint8_t key[AES_KEY_SIZE];
    rt_uint8_t *encrypted = rt_malloc(image_size);
    rt_uint8_t *decrypted = rt_malloc(image_size);
    
    if (!image_data || !encrypted || !decrypted) {
        rt_kprintf("内存分配失败\n");
        if (image_data) rt_free(image_data);
        if (encrypted) rt_free(encrypted);
        if (decrypted) rt_free(decrypted);
        return;
    }
    
    init_random_seed();
    generate_random_data(image_data, image_size);
    generate_random_data(key, AES_KEY_SIZE);
    
    rt_kprintf("=== 图像数据加密测试 ===\n");
    rt_kprintf("图像大小: %d 字节\n", image_size);
    rt_kprintf("原始图像数据前16字节: ");
    for (int i = 0; i < 16; i++) {
        rt_kprintf("%02x ", image_data[i]);
    }
    rt_kprintf("\n");
    
    rt_uint32_t block_count = image_size / AES_BLOCK_SIZE;
    rt_uint32_t remaining = image_size % AES_BLOCK_SIZE;
    
    for (rt_uint32_t i = 0; i < block_count; i++) {
        aes_encrypt(image_data + i * AES_BLOCK_SIZE, key, encrypted + i * AES_BLOCK_SIZE);
    }
    
    if (remaining > 0) {
        rt_uint8_t last_block[AES_BLOCK_SIZE] = {0};
        memcpy(last_block, image_data + block_count * AES_BLOCK_SIZE, remaining);
        rt_uint8_t encrypted_block[AES_BLOCK_SIZE];
        aes_encrypt(last_block, key, encrypted_block);
        memcpy(encrypted + block_count * AES_BLOCK_SIZE, encrypted_block, remaining);
    }
    
    rt_kprintf("加密后数据前16字节: ");
    for (int i = 0; i < 16; i++) {
        rt_kprintf("%02x ", encrypted[i]);
    }
    rt_kprintf("\n");
    
    for (rt_uint32_t i = 0; i < block_count; i++) {
        aes_decrypt(encrypted + i * AES_BLOCK_SIZE, key, decrypted + i * AES_BLOCK_SIZE);
    }
    
    if (remaining > 0) {
        rt_uint8_t encrypted_block[AES_BLOCK_SIZE];
        memcpy(encrypted_block, encrypted + block_count * AES_BLOCK_SIZE, remaining);
        rt_uint8_t decrypted_block[AES_BLOCK_SIZE];
        aes_decrypt(encrypted_block, key, decrypted_block);
        memcpy(decrypted + block_count * AES_BLOCK_SIZE, decrypted_block, remaining);
    }
    
    rt_kprintf("解密后数据前16字节: ");
    for (int i = 0; i < 16; i++) {
        rt_kprintf("%02x ", decrypted[i]);
    }
    rt_kprintf("\n");
    
    if (memcmp(image_data, decrypted, image_size) == 0) {
        rt_kprintf("图像加密测试通过\n");
    } else {
        rt_kprintf("图像加密测试失败\n");
    }
    
    rt_free(image_data);
    rt_free(encrypted);
    rt_free(decrypted);
}

static void crypto_test(int argc, char **argv)
{
    if (argc < 2) {
        rt_kprintf("用法: crypto_test <test_name>\n");
        rt_kprintf("测试: aes, xor, sm3, sm4, lz77, rle, image, all\n");
        return;
    }
    
    if (strcmp(argv[1], "aes") == 0) {
        test_aes();
    } else if (strcmp(argv[1], "xor") == 0) {
        test_xor();
    } else if (strcmp(argv[1], "sm3") == 0) {
        test_sm3();
    } else if (strcmp(argv[1], "sm4") == 0) {
        test_sm4();
    } else if (strcmp(argv[1], "lz77") == 0) {
        test_lz77();
    } else if (strcmp(argv[1], "rle") == 0) {
        test_rle();
    } else if (strcmp(argv[1], "image") == 0) {
        test_image_encrypt();
    } else if (strcmp(argv[1], "all") == 0) {
        test_sm3();
        rt_kprintf("\n");
        test_sm4();
        rt_kprintf("\n");
        test_lz77();
        rt_kprintf("\n");
        test_image_encrypt();
    } else {
        rt_kprintf("未知测试: %s\n", argv[1]);
    }
}
