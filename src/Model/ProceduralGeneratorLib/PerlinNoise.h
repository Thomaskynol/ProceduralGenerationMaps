#ifndef PERLINNOISE_H
#define PERLINNOISE_H

static double fade(double t);

static double lerp(double t, double a, double b);

extern const int permutation[512];
extern const double gradients[8][2];

double PerlinNoise(double x, double y);


#endif