#ifndef HEIGHTMAPGENERATOR_H
#define HEIGHTMAPGENERATOR_H

double** GenerateHeightmap(int width, int height, double scale, double amplitude); 
void FreeHeightmap(double** heightmap, int height);

#endif