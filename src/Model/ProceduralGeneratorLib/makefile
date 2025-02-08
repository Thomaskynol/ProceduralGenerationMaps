# Compiler to use
CC = gcc

# Flags for compilation
INCLUDE_DIR = C:/Users/types/Documents/scripts/ProceduralGenerationMaps/src/Model/ProceduralGeneratorLib/include
CFLAGS = -shared -I"C:/Users/types/Documents/Lua" -I$(INCLUDE_DIR) -fPIC
# -shared  → Creates a shared library (.dll) instead of an executable.
# -I"C:/Users/types/Documents/Lua"  → Adds the Lua headers directory for inclusion during compilation.
# -fPIC  → Generates position-independent code (required for shared libraries).

# Flags for linking
LDFLAGS = -L"C:/Users/types/Documents/Lua" -llua "C:/Users/types/Documents/Lua/liblua.a" -lm
# -L"C:/Users/types/Documents/Lua"  → Adds the Lua library directory for linking.
# -llua  → Links the Lua library, assuming it's found in the path defined by -L.
# "C:/Users/types/Documents/Lua/liblua.a"  → Specifies the Lua static library (liblua.a) for linking.
# -lm  → Links the math library, which may be required for math functions.

# Optimization flags for better performance
OPTIMIZATIONFLAGS = -O3 -march=native -flto -fomit-frame-pointer
# -O3  → Aggressive optimizations, including loop unrolling and vectorization.
# -march=native  → Uses the processor-specific instructions for better performance (takes advantage of SSE, AVX, etc.).
# -flto  → Link-time optimization (LTO), performs global optimizations across all compilation units.
# -fomit-frame-pointer  → Removes the frame pointer from the stack, generating faster code.

# The target file name
TARGET = C:/Users/types/Documents/scripts/ProceduralGenerationMaps/src/ProceduralMapsGeneration.dll

# The source file to compile
SRC = ProceduralMapsGeneration.c HeightMapGenerator.c PerlinNoise.c

# Default target: when 'make' is called, it compiles the target
all: $(TARGET)

# How to build the target from the source
$(TARGET): $(SRC)
	# Use the compiler and the specified flags to compile the source file and produce the target shared library
	$(CC) $(CFLAGS) $(OPTIMIZATIONFLAGS) -o $(TARGET) $(SRC) $(LDFLAGS)

# Clean the generated files (like .dll) when 'make clean' is called
clean:
	# Delete the target DLL file
	del /Q $(TARGET)




# This above is:
#gcc -shared -o ProceduralMapsGeneration.dll -I"C:\Users\types\Documents\Lua" ProceduralMapsGeneration.c -L"C:\Users\types\Documents\Lua" -llua "C:\Users\types\Documents\Lua\liblua.a" -lm -fPIC