#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "HeightMapGenerator.h"
#include "PerlinNoise.h"

double** GenerateHeightmap(int width, int height, double scale, double amplitude) {
    // Allocate single memory block for both row pointers and data
    size_t row_ptrs_size = height * sizeof(double*);
    size_t data_size = (size_t)width * height * sizeof(double);
    char* memory_block = (char*)malloc(row_ptrs_size + data_size);
    
    if (!memory_block) {
        fprintf(stderr, "Memory Error: Failed to allocate contiguous block\n");
        exit(EXIT_FAILURE);
    }

    // Set up row pointers and data block
    double** rows = (double**)memory_block;
    double* data = (double*)(memory_block + row_ptrs_size);

    // Initialize row pointers
    for (int y = 0; y < height; y++) {
        rows[y] = data + y * width;
    }

    // Generate noise data
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            double nx = x / scale;
            double ny = y / scale;
            double value = PerlinNoise(nx, ny);
            rows[y][x] = (value + 1.0) * 0.5 * amplitude;
        }
    }

    return rows;
}

void FreeHeightmap(double** heightmap) {
    free(heightmap);
}