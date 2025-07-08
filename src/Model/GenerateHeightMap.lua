local OpenSimplex = require("Dependencies.opensimplex-lua.opensimplex-lua")

local function GenerateHeightmap(isTable, seed, width, height, scale, amplitude, octaves, persistence, lacunarity, resolution, terreinCurve, heightmapMask, heightmapMaskWeight)

    if isTable then
        width = seed.width
        height = seed.height
        scale = seed.scale
        amplitude = seed.amplitude
        octaves = seed.octaves
        persistence = seed.persistence
        lacunarity = seed.lacunarity
        resolution = seed.resolution
        terreinCurve = seed.terreinCurve
        heightmapMask = seed.heightmapMask
        heightmapMaskWeight = seed.heightmapMaskWeight
        seed = seed.seed
    end

    local SimplexNoise = OpenSimplex.new(seed)
    local Heightmap = {}

    for y = 1, height do
        Heightmap[y] = {}
        for x = 1, width do
            local noiseValue = 0
            local maxAmplitude = 0

            for o = 0, octaves - 1 do
                local frequency = (1 / scale) * (lacunarity ^ o)
                local amp = amplitude * (persistence ^ o)

                local nx = (x * resolution) * frequency
                local ny = (y * resolution) * frequency

                noiseValue = noiseValue + SimplexNoise:noise2(nx, ny) * amp
                maxAmplitude = maxAmplitude + amp
            end

            -- Normaliza para [-1, 1]
            noiseValue = noiseValue / maxAmplitude
            local h  = (noiseValue + 1) /2
            -- curva de elevação
            h = h ^ terreinCurve
            
            -- Ajusta para faixa [0, 1]
            
            if heightmapMask then
                h = h * (1 - heightmapMaskWeight) + heightmapMask[y][x] * heightmapMaskWeight
            end

            Heightmap[y][x] = h
        end
    end

    return Heightmap
end

return GenerateHeightmap