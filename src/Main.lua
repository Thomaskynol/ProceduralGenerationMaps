local Utils = require("Model.Utils")
local GenerateHeightmap = require("Model.GenerateHeightMap")
local SaveHeightMapAsBMP = require("Model.SaveHeightMapAsBMP")
local SaveHeightmapAsOBJ = require("Model.SaveHeightMapAsOBJ")

-- Parâmetros
local GeneralSeed = 5409823 

local HeightmapMaskArguments = {
    seed = GeneralSeed,
    width = 1000,
    height = 1000,
    resolution = 0.10,

    scale = 100,            -- Muito baixa frequência → estrutura ampla (planícies, montanhas)

    amplitude = 1.0,
    octaves = 4,              -- Só estrutura, então poucos níveis
    persistence = 0.5,
    lacunarity = 2.0,
    
    terreinCurve = 1.0,        -- Mantém a estrutura fiel; pode ajustar no final

    heightmapMask = false,
    heightmapMaskWeight = 0
}

local HeightmapWithNoMaksArguments = {
    seed = GeneralSeed,
    width = 1000,
    height = 1000,
    resolution = 0.10,

    scale = 8,              -- Frequência mais alta → feições menores (colinas, rugosidade)

    amplitude = 1.0,
    octaves = 6,              -- Mais camadas → mais detalhes
    persistence = 0.45,       -- Decai suavemente
    lacunarity = 2.2,         -- Frequência aumenta rápido, bom pra fractal

    terreinCurve = 0.8,       -- Suaviza picos/vales (menos ruído agudo)

    heightmapMask = false,
    heightmapMaskWeight = 0.1
}

local HeightmapArguments = {
    seed = GeneralSeed,
    width = 1000,
    height = 1000,
    resolution = 0.10,

    scale = 8,              -- Frequência mais alta → feições menores (colinas, rugosidade)

    amplitude = 1.0,
    octaves = 6,              -- Mais camadas → mais detalhes
    persistence = 0.45,       -- Decai suavemente
    lacunarity = 2.2,         -- Frequência aumenta rápido, bom pra fractal

    terreinCurve = 0.8,       -- Suaviza picos/vales (menos ruído agudo)

    heightmapMask = false,
    heightmapMaskWeight = 0.8
}

-- Função utilitária para medir tempo de execução de uma função
local function timeExecution(description, func)
    local start_time = os.clock()
    local result = func()
    local end_time = os.clock()
    print(string.format("%s em %f segundos.", description, end_time - start_time))
    return result
end

-- Geração e salvamento do heightmap máscara
local function generateAndSaveHeightmapMask()
    return timeExecution("HeightmapMask gerado", function()
        local mask = GenerateHeightmap(true, HeightmapMaskArguments)
        SaveHeightMapAsBMP(mask, "heightmapMask.bmp")
        return mask
    end)
end

-- Geração e salvamento do heightmap sem máscara
local function generateAndSaveHeightmapNoMask()
    return timeExecution("Heightmap sem máscara gerado", function()
        local noMask = GenerateHeightmap(true, HeightmapWithNoMaksArguments)
        SaveHeightMapAsBMP(noMask, "heightmapWithNoMask.bmp")
        return noMask
    end)
end

-- Geração e salvamento do heightmap final com a máscara aplicada
local function generateAndSaveFinalHeightmap(mask)
    HeightmapArguments.heightmapMask = mask
    return timeExecution("Heightmap final gerado", function()
        local finalMap = GenerateHeightmap(true, HeightmapArguments)
        timeExecution("Heightmap final salvo", function()
            SaveHeightMapAsBMP(finalMap, "heightmap.bmp")
            SaveHeightmapAsOBJ(finalMap, "heightmap.obj", 0.10, 15)
        end)
        return finalMap
    end)
end

-- Execução dos testes
local mask = generateAndSaveHeightmapMask()
generateAndSaveHeightmapNoMask()
generateAndSaveFinalHeightmap(mask) 