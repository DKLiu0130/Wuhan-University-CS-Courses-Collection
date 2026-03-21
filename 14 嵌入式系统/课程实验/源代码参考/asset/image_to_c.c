#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <windows.h> // 用于设置控制台输出编码
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

#define OUTPUT_WIDTH 128
#define OUTPUT_HEIGHT 128

int main() {
  SetConsoleOutputCP(CP_UTF8);
    const char *input_file = "input.png";         // 输入文件路径
    const char *output_file = "..\\src\\applications\\output.c"; // 输出 C 文件路径

    int width, height, channels;
    // 使用 stb_image 加载图像
    unsigned char *image_data = stbi_load(input_file, &width, &height, &channels, 3); // 强制加载为 RGB 格式（3 通道）
    if (image_data == NULL) {
        fprintf(stderr, "无法加载图像文件: %s\n", input_file);
        return 1;
    }

    printf("原始图像大小：%dx%d, 通道数：%d\n", width, height, channels);

    // 如果原始图像大小不是 128x128，可以使用简单的最近邻插值缩放（手动实现）
    unsigned char resized_data[OUTPUT_WIDTH * OUTPUT_HEIGHT * 3]; // 存储缩放后的 RGB 数据
    for (int y = 0; y < OUTPUT_HEIGHT; y++) {
        for (int x = 0; x < OUTPUT_WIDTH; x++) {
            int src_x = x * width / OUTPUT_WIDTH;  // 对应原图的 x 坐标
            int src_y = y * height / OUTPUT_HEIGHT; // 对应原图的 y 坐标
            for (int c = 0; c < 3; c++) { // 3 通道（R、G、B）
                resized_data[(y * OUTPUT_WIDTH + x) * 3 + c] =
                    image_data[(src_y * width + src_x) * 3 + c];
            }
        }
    }

    // 将数据写入为 C 语言数组
    FILE *output_fp = fopen(output_file, "w");
    if (!output_fp) {
        fprintf(stderr, "无法创建输出文件: %s\n", output_file);
        stbi_image_free(image_data);
        return 1;
    }

    fprintf(output_fp, "unsigned char SIZE_128x128[] = {\n");

    // 输出像素数据
    int total_elements = OUTPUT_WIDTH * OUTPUT_HEIGHT * 3;
    for (int i = 0; i < total_elements; i++) {
        fprintf(output_fp, " %3d", resized_data[i]); // 输出当前像素值

        // 如果不是最后一个元素，添加逗号
        if (i < total_elements - 1) {
            fprintf(output_fp, ",");
        }

        // 每 12 个数据换一行，最后一行不用换行
        if ((i + 1) % 12 == 0 && i < total_elements - 1) {
            fprintf(output_fp, "\n");
        }
    }

    fprintf(output_fp, "\n};\n"); // 数组结束

    fclose(output_fp);
    stbi_image_free(image_data);

    printf("C 语言数组已写入到 %s\n", output_file);
    return 0;
}
