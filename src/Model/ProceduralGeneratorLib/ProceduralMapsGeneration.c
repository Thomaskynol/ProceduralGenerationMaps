#include <lua.h>
//#include <lauxlib.h>
//#include <lualib.h>

//#include <luajit.h>
#include <lauxlib.h>
#include <lualib.h>

#include "PerlinNoise.h"
#include "HeightMapGenerator.h"

// Example C function to add two numbers
static int lua_add(lua_State *L)
{
    float a = lua_tonumber(L, 1); // Get first argument
    float b = lua_tonumber(L, 2); // Get second argument
    lua_pushnumber(L, a + b);     // Push result to Lua stack
    return 1;                     // Return 1 result
}

static int lua_GenerateHeightMap(lua_State *L)
{
    int Width = luaL_checkinteger(L, 1);
    int Height = luaL_checkinteger(L, 2);
    double Scale = luaL_checknumber(L, 3);
    double Amplitude = luaL_checknumber(L, 4);

    double **heightmap = GenerateHeightmap(Width, Height, Scale, Amplitude);
    if (!heightmap)
    {
        return luaL_error(L, "Failed to generate heightmap");
    }

    lua_newtable(L);
    for (int y = 0; y < Height; y++)
    {
        lua_newtable(L);
        for (int x = 0; x < Width; x++)
        {
            lua_pushnumber(L, heightmap[y][x]);
            lua_rawseti(L, -2, x + 1);
        }
        lua_rawseti(L, -2, y + 1);
    }

    FreeHeightmap(heightmap);

    return 1;
}

static int lua_PerlinNoise(lua_State *L)
{
    float x = lua_tonumber(L, 1); // Get first argument
    float y = lua_tonumber(L, 2); // Get second argument
    
    double result = PerlinNoise(x, y);
    lua_pushnumber(L, result);     // Push result to Lua stack
    return 1;                     // Return 1 result
}

__declspec(dllexport) int luaopen_ProceduralMapsGeneration(lua_State *L)
{
    // Cria a tabela da biblioteca
    lua_newtable(L);

    // Adiciona as funções à tabela
    lua_pushcfunction(L, lua_GenerateHeightMap);
    lua_setfield(L, -2, "GenerateHeightmap");

    // Se você quiser registrar outras funções, como lua_add:
    lua_pushcfunction(L, lua_PerlinNoise);
    lua_setfield(L, -2, "PerlinNoise");

    lua_pushcfunction(L, lua_add);
    lua_setfield(L, -2, "Add");

    // Retorna a tabela como resultado
    return 1;
}
