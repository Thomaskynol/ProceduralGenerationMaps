require("luapath")

local ProceduralMapsGeneration = require('ProceduralMapsGeneration')
--[[
ProceduralMapsGeneration.GenerateHeightmap(Width, Height, Scale, Amplitude) --> heightmap
]]

-- Registra o tempo antes de chamar a função
local startTime = os.clock()

-- Chama a função
local Heightmap = ProceduralMapsGeneration.GenerateHeightmap(300, 300, 20, 25)

-- Registra o tempo depois de chamar a função
local endTime = os.clock()

-- Calcula o tempo de execução
local executionTime = endTime - startTime

-- Imprime o tempo de execução em segundos
print(string.format("Tempo de execução: %f segundos", executionTime))
