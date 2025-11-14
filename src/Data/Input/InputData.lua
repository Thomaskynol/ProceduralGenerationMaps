local Seed = 12340971234
local Size = 1000

local HeightmapMaskArguments = {
    seed = Seed,
    width = Size,
    height = Size,
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
    seed = Seed,
    width = Size,
    height = Size,
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

return {HeightmapMaskArguments, HeightmapArguments}