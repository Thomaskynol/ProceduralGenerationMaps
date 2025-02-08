#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "HeightMapGenerator.h"
#include "PerlinNoise.h"

double** GenerateHeightmap(int width, int height, double scale, double amplitude) {
    double** heightmap = (double**)malloc(height * sizeof(double*));
    if (!heightmap) {
        fprintf(stderr, "Memory Error\n");
        exit(EXIT_FAILURE);
    }

    for (int y = 0; y < height; y++) {
        heightmap[y] = (double*)malloc(width * sizeof(double));
        if (!heightmap[y]) {
            fprintf(stderr, "Memory Error\n", y);
            exit(EXIT_FAILURE);
        }
        for (int x = 0; x < width; x++) {
            double nx = (double)x / scale;
            double ny = (double)y / scale;
            double value = PerlinNoise(nx, ny);
            heightmap[y][x] = (value + 1) * 0.5 * amplitude;
        }
    }
    return heightmap;
}

void FreeHeightmap(double** heightmap, int height) {
    for (int i = 0; i < height; i++) {
        free(heightmap[i]);
    }
    free(heightmap);
}