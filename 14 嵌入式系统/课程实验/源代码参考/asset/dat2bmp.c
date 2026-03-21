#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <locale.h>
#ifdef _WIN32
#include <io.h>
#include <fcntl.h>
#endif

// 定义BMP文件头和信息头的结构
#pragma pack(1)
typedef struct {
    unsigned char bfType[2];
    unsigned int bfSize;
    unsigned short bfReserved1;
    unsigned short bfReserved2;
    unsigned int bfOffBits;
} BMPFileHeader;

typedef struct {
    unsigned int biSize;
    int biWidth;
    int biHeight;
    unsigned short biPlanes;
    unsigned short biBitCount;
    unsigned int biCompression;
    unsigned int biSizeImage;
    int biXPelsPerMeter;
    int biYPelsPerMeter;
    unsigned int biClrUsed;
    unsigned int biClrImportant;
} BMPInfoHeader;

// 工具函数：生成输出文件名（替换 .dat 后缀为 .bmp）
void generateOutputFileName(const char *inputFile, char *outputFile, size_t outputSize) {
    const char *dot = strrchr(inputFile, '.');
    if (dot && strcmp(dot, ".dat") == 0) {
        snprintf(outputFile, outputSize, "%.*s.bmp", (int)(dot - inputFile), inputFile);
    } else {
        snprintf(outputFile, outputSize, "%s.bmp", inputFile);
    }
}

// 写入灰度图的 BMP 文件头、信息头和调色板
void writeGrayBMPHeaders(FILE *fp, int width, int height) {
    BMPFileHeader fileHeader;
    BMPInfoHeader infoHeader;

    int rowSize = (width + 3) & ~3;
    int dataSize = rowSize * height;
    int paletteSize = 256 * 4;

    fileHeader.bfType[0] = 'B';
    fileHeader.bfType[1] = 'M';
    fileHeader.bfSize = sizeof(BMPFileHeader) + sizeof(BMPInfoHeader) + paletteSize + dataSize;
    fileHeader.bfReserved1 = 0;
    fileHeader.bfReserved2 = 0;
    fileHeader.bfOffBits = sizeof(BMPFileHeader) + sizeof(BMPInfoHeader) + paletteSize;

    infoHeader.biSize = sizeof(BMPInfoHeader);
    infoHeader.biWidth = width;
    infoHeader.biHeight = -height;
    infoHeader.biPlanes = 1;
    infoHeader.biBitCount = 8;
    infoHeader.biCompression = 0;
    infoHeader.biSizeImage = dataSize;
    infoHeader.biXPelsPerMeter = 2835;
    infoHeader.biYPelsPerMeter = 2835;
    infoHeader.biClrUsed = 256;
    infoHeader.biClrImportant = 256;

    fwrite(&fileHeader, sizeof(BMPFileHeader), 1, fp);
    fwrite(&infoHeader, sizeof(BMPInfoHeader), 1, fp);

    for (int i = 0; i < 256; i++) {
        unsigned char color[4] = {i, i, i, 0};
        fwrite(color, 1, 4, fp);
    }
}

// 写入三通道的 BMP 文件头和信息头
void writeColorBMPHeaders(FILE *fp, int width, int height) {
    BMPFileHeader fileHeader;
    BMPInfoHeader infoHeader;

    int rowSize = (width * 3 + 3) & ~3;
    int dataSize = rowSize * height;

    fileHeader.bfType[0] = 'B';
    fileHeader.bfType[1] = 'M';
    fileHeader.bfSize = sizeof(BMPFileHeader) + sizeof(BMPInfoHeader) + dataSize;
    fileHeader.bfReserved1 = 0;
    fileHeader.bfReserved2 = 0;
    fileHeader.bfOffBits = sizeof(BMPFileHeader) + sizeof(BMPInfoHeader);

    infoHeader.biSize = sizeof(BMPInfoHeader);
    infoHeader.biWidth = width;
    infoHeader.biHeight = -height;
    infoHeader.biPlanes = 1;
    infoHeader.biBitCount = 24;
    infoHeader.biCompression = 0;
    infoHeader.biSizeImage = dataSize;
    infoHeader.biXPelsPerMeter = 2835;
    infoHeader.biYPelsPerMeter = 2835;
    infoHeader.biClrUsed = 0;
    infoHeader.biClrImportant = 0;

    fwrite(&fileHeader, sizeof(BMPFileHeader), 1, fp);
    fwrite(&infoHeader, sizeof(BMPInfoHeader), 1, fp);
}

// 主函数
int main(int argc, char *argv[]) {
    // 设置终端编码为 UTF-8
#ifdef _WIN32
    _setmode(_fileno(stdout), _O_U16TEXT); // 设置标准输出为 Unicode 模式
#endif
    setlocale(LC_ALL, ""); // 本地化以支持宽字符

    if (argc != 5) {
#ifdef _WIN32
        wprintf(L"用法: %S <宽度> <高度> <输入文件> <通道数>\n", argv[0]);
#else
        wprintf(L"用法: %s <宽度> <高度> <输入文件> <通道数>\n", argv[0]);
#endif
        return 1;
    }

    int width = atoi(argv[1]);
    int height = atoi(argv[2]);
    char *inputFile = argv[3];
    int channels = atoi(argv[4]);

    if (channels != 1 && channels != 3) {
        wprintf(L"通道数必须是 1（灰度图）或 3（彩色图）！\n");
        return 1;
    }

    FILE *fpIn = fopen(inputFile, "rb");
    if (!fpIn) {
        perror("无法打开输入文件");
        return 1;
    }

    char outputFile[256];
    generateOutputFileName(inputFile, outputFile, sizeof(outputFile));

    FILE *fpOut = fopen(outputFile, "wb");
    if (!fpOut) {
        perror("无法创建输出文件");
        fclose(fpIn);
        return 1;
    }

    if (channels == 1) {
        writeGrayBMPHeaders(fpOut, width, height);
        int rowSize = (width + 3) & ~3;
        unsigned char *rowBuffer = malloc(rowSize);
        unsigned char *dataBuffer = malloc(width);

        for (int i = 0; i < height; i++) {
            fread(dataBuffer, 1, width, fpIn);
            memcpy(rowBuffer, dataBuffer, width);
            memset(rowBuffer + width, 0, rowSize - width);
            fwrite(rowBuffer, 1, rowSize, fpOut);
        }

        free(rowBuffer);
        free(dataBuffer);
    } else if (channels == 3) {
        writeColorBMPHeaders(fpOut, width, height);
        int rowSize = (width * 3 + 3) & ~3;
        unsigned char *rowBuffer = malloc(rowSize);
        unsigned char *dataBuffer = malloc(width * 3);

        for (int i = 0; i < height; i++) {
            fread(dataBuffer, 1, width * 3, fpIn);
            for (int j = 0; j < width; j++) {
                rowBuffer[j * 3 + 0] = dataBuffer[j * 3 + 2];
                rowBuffer[j * 3 + 1] = dataBuffer[j * 3 + 1];
                rowBuffer[j * 3 + 2] = dataBuffer[j * 3 + 0];
            }
            memset(rowBuffer + width * 3, 0, rowSize - width * 3);
            fwrite(rowBuffer, 1, rowSize, fpOut);
        }

        free(rowBuffer);
        free(dataBuffer);
    }

    fclose(fpIn);
    fclose(fpOut);

    wprintf(L"转换完成，生成文件: %s\n", outputFile);
    return 0;
}

