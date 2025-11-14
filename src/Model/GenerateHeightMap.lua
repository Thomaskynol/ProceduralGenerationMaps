-- Import the OpenSimplex noise library
local OpenSimplex = require("Dependencies.opensimplex-lua.opensimplex-lua")

-- Main function to generate a heightmap
-- Parameters:
-- isTable: if true, use a table of parameters instead of individual values
-- seed: random seed or a table with parameters
-- width, height: dimensions of the heightmap
-- scale: controls zoom level of noise
-- amplitude: controls height variation
-- octaves: number of layers of noise
-- persistence: controls amplitude decay across octaves
-- lacunarity: controls frequency increase across octaves
-- resolution: how densely the noise is sampled
-- terreinCurve: exponent for shaping terrain
-- heightmapMask: optional mask to blend with generated noise
-- heightmapMaskWeight: weight of the mask in final value
local function GenerateHeightmap(isTable, seed, width, height, scale, amplitude, octaves, persistence, lacunarity, resolution, terreinCurve, heightmapMask, heightmapMaskWeight)

    -- If 'seed' is actually a table with parameters, unpack the table
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
        seed = seed.seed  -- Extract the actual numeric seed
    end

    -- Create a new Simplex noise generator with the given seed
    local SimplexNoise = OpenSimplex.new(seed)
    
    -- Initialize the heightmap table
    local Heightmap = {}

    -- Loop through each row
    for y = 1, height do
        Heightmap[y] = {}  -- Create a new row in the heightmap
        -- Loop through each column
        for x = 1, width do
            local noiseValue = 0      -- Accumulator for noise value at this point
            local maxAmplitude = 0    -- Track max amplitude for normalization

            -- Generate layered noise (fractal noise) with multiple octaves
            for o = 0, octaves - 1 do
                local frequency = (1 / scale) * (lacunarity ^ o)       -- Increase frequency per octave
                local amp = amplitude * (persistence ^ o)            -- Decrease amplitude per octave

                local nx = (x * resolution) * frequency              -- Scaled x coordinate for noise
                local ny = (y * resolution) * frequency              -- Scaled y coordinate for noise

                noiseValue = noiseValue + SimplexNoise:noise2(nx, ny) * amp  -- Add noise layer
                maxAmplitude = maxAmplitude + amp                            -- Track total amplitude
            end

            -- Normalize noiseValue to [-1, 1]
            noiseValue = noiseValue / maxAmplitude
            -- Convert to [0, 1] range
            local h  = (noiseValue + 1) / 2

            -- Apply terrain shaping curve
            h = h ^ terreinCurve
            
            -- Blend with optional heightmap mask
            if heightmapMask then
                h = h * (1 - heightmapMaskWeight) + heightmapMask[y][x] * heightmapMaskWeight
            end

            -- Store final height value in heightmap
            Heightmap[y][x] = h
        end
    end

    -- Return the generated heightmap
    return Heightmap
end

-- Return the function so it can be required in other scripts
return GenerateHeightmap
