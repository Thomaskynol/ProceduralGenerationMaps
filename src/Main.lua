local GenerateHeightmap = require("Model.GenerateHeightMap")
local SaveHeightMapAsBMP = require("Model.SaveHeightMapAsBMP")
local SaveHeightmapAsOBJ = require("Model.SaveHeightMapAsOBJ")
local ConvertHeightMapOBJ2Blend = require("Model.ConvertHeightMapOBJ2Blend")

local FolderToSaveOutputFiles = [[./Data/Output/]]
-- Parâmetros

local GeneralSeed = 109283213

local HeightmapMaskArguments = {
    seed = GeneralSeed,
    width = 1000,
    height = 1000,
    resolution = 0.10,

    scale = 130,            -- Muito baixa frequência → estrutura ampla (planícies, montanhas)

    amplitude = 1.0,
    octaves = 4,              -- Só estrutura, então poucos níveis
    persistence = 0.5,
    lacunarity = 2.0,

    terreinCurve = 1.0,        -- Mantém a estrutura fiel; pode ajustar no final

    heightmapMask = false,
    heightmapMaskWeight = 0
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

    terreinCurve = 0.5  ,       -- Suaviza picos/vales (menos ruído agudo)

    heightmapMask = false,
    heightmapMaskWeight = 0.85
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
        SaveHeightMapAsBMP(mask, FolderToSaveOutputFiles.."heightmapMask.bmp")
        return mask
    end)
end

-- Geração e salvamento do heightmap sem máscara
local function generateAndSaveHeightmapNoMask()
    return timeExecution("Heightmap sem máscara gerado", function()
        local noMask = GenerateHeightmap(true, HeightmapArguments)
        SaveHeightMapAsBMP(noMask, FolderToSaveOutputFiles.."heightmapWithNoMask.bmp")
        return noMask
    end)
end

-- Geração e salvamento do heightmap final com a máscara aplicada
local function generateAndSaveFinalHeightmap(mask)
    HeightmapArguments.heightmapMask = mask
    return timeExecution("Heightmap final gerado", function()
        local finalMap = GenerateHeightmap(true, HeightmapArguments)
        timeExecution("Heightmap final salvo", function()
            SaveHeightMapAsBMP(finalMap, FolderToSaveOutputFiles.."heightmap.bmp")
            SaveHeightmapAsOBJ(finalMap, FolderToSaveOutputFiles.."heightmap.obj", 0.10, 15)
            --os.execute(python3.." "..ToolsFolder.."obj2blend.py "..FolderToSaveOutputFiles.."heightmap.obj "..FolderToSaveOutputFiles.."heightmap.blend")
            ConvertHeightMapOBJ2Blend(FolderToSaveOutputFiles.."heightmap.obj ", FolderToSaveOutputFiles.."heightmap.blend")
        end)
        return finalMap
    end)
end

-- Execução dos testes
local mask = generateAndSaveHeightmapMask()
generateAndSaveHeightmapNoMask()
generateAndSaveFinalHeightmap(mask)