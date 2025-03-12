# Compiler to use
CC = gcc

# Flags for linking
ifeq ($(LUA), lua51)
    LUA_FLAG = -L$(LUA_DIR) -llua $(LUA_DIR)/liblua.a -lm
else ifeq ($(LUA), lua54)
    LUA_FLAG = -L$(LUA_DIR) -llua $(LUA_DIR)/liblua.a -lm
else ifeq ($(LUA), luajit)
    LUA_FLAG = -L$(LUA_DIR) -lluajit-5.1 $(LUA_DIR)/libluajit-5.1.dll.a -lm
else
    $(error Versão de Lua não suportada: $(LUA))
endif
# -L$(LUA_DIR) → Adds the Lua library directory for linking.
# -llua → Links the Lua library, assuming it's found in the path defined by -L.
# -llua $(LUA_DIR)/liblua.a → Specifies the Lua static library (liblua.a) for linking.
# -lm → Links the math library, which may be required for math functions.

# Flags for compilation
INCLUDE_DIR = $(CURDIR)/include
CFLAGS = -shared -I$(LUA_DIR) -I$(INCLUDE_DIR) -fPIC
# -shared → Creates a shared library (.dll) instead of an executable.
# -I$(LUA_DIR) → Adds the Lua headers directory for inclusion during compilation.
# -fPIC → Generates position-independent code (required for shared libraries).

# Optimization flags for better performance
OPTIMIZATION_FLAGS = -O3 -march=native -flto -fomit-frame-pointer
# -O3 → Aggressive optimizations, including loop unrolling and vectorization.
# -march=native → Uses the processor-specific instructions for better performance (takes advantage of SSE, AVX, etc.).
# -flto → Link-time optimization (LTO), performs global optimizations across all compilation units.
# -fomit-frame-pointer → Removes the frame pointer from the stack, generating faster code.
# -ffast-math → Optimize math (may not be accurate).

# The target file name
TARGET = ../../ProceduralMapsGeneration.dll

# The source files to compile
SRC = ProceduralMapsGeneration.c HeightMapGenerator.c PerlinNoise.c

# Default target: when 'make' is called, it compiles the target
all: $(TARGET)

# How to build the target from the source
$(TARGET): $(SRC)
	# Use the compiler and the specified flags to compile the source file and produce the target shared library
	$(CC) $(CFLAGS) $(OPTIMIZATION_FLAGS) -o $(TARGET) $(SRC) $(LUA_FLAG)

# Clean the generated files (like .dll) when 'make clean' is called
clean:
	# Delete the target DLL file
	rm -f $(TARGET)


#mingw32-make LUA=luajit LUA_DIR=C:/Users/thomaskyn/Documents/dev/libs/Lua/luaJIT/lua/jit