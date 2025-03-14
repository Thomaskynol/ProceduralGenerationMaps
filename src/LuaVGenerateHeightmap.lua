--[[
this is just for tests
]]

local function bitwise_and(a, b)
    local result = 0
    local bit = 1
    while a > 0 and b > 0 do
        if a % 2 == 1 and b % 2 == 1 then
            result = result + bit
        end
        a = math.floor(a / 2)
        b = math.floor(b / 2)
        bit = bit * 2
    end
    return result
end

function fade(t)
    return t * t * t * (t * (t * 6 - 15) + 10)  -- 6t^5 - 15t^4 + 10t^3
end

-- Função de interpolação linear
function lerp(t, a, b)
    return a + t * (b - a)
end

-- Tabela de permutações (256 valores iniciais)
local permutation = {
    151,160,137,91,90,15,131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,
    8,99,37,240,21,10,23,190,6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,
    35,11,32,57,177,33,88,237,149,56,87,174,20,125,136,171,168,68,175,74,165,71,
    134,139,48,27,166,77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,
    55,46,245,40,244,102,143,54,65,25,63,161,1,216,80,73,209,76,132,187,208,89,
    18,169,200,196,135,130,116,188,159,86,164,100,109,198,173,186,3,64,52,217,226,
    250,124,123,5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,
    189,28,42,223,183,170,213,119,248,152,2,44,154,163,70,221,153,101,155,167,43,
    172,9,129,22,39,253,19,98,108,110,79,113,224,232,178,185,112,104,218,246,97,
    228,251,34,242,193,238,210,144,12,191,179,162,241,81,51,145,235,249,14,239,
    107,49,192,214,31,181,199,106,157,184,84,204,176,115,121,50,45,127,4,150,254,
    138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180
}

-- Duplicar a tabela para formar 512 elementos
for i = 1, 256 do
    permutation[256 + i] = permutation[i]
end

-- Gradientes possíveis para o Perlin Noise
local gradients = {
    {1, 1}, {-1, 1}, {1, -1}, {-1, -1},
    {1, 0}, {-1, 0}, {0, 1}, {0, -1}
}

-- Função para gerar Perlin Noise
function PerlinNoise(x, y)
    local xi = bitwise_and(math.floor(x), 255)  -- Substituído o operador &
    local yi = bitwise_and(math.floor(y), 255)  -- Substituído o operador &
    local xf = x - math.floor(x)
    local yf = y - math.floor(y)

    local u = fade(xf)
    local v = fade(yf)

    local a = permutation[(xi + 1) % 512 + 1] + yi
    local b = permutation[(xi + 2) % 512 + 1] + yi
    local aa = permutation[(a % 512) + 1]
    local ab = permutation[(a + 1) % 512 + 1]
    local ba = permutation[(b % 512) + 1]
    local bb = permutation[(b + 1) % 512 + 1]

    local dot_aa = gradients[(aa % 8) + 1][1] * xf + gradients[(aa % 8) + 1][2] * yf
    local dot_ba = gradients[(ba % 8) + 1][1] * (xf - 1) + gradients[(ba % 8) + 1][2] * yf
    local dot_ab = gradients[(ab % 8) + 1][1] * xf + gradients[(ab % 8) + 1][2] * (yf - 1)
    local dot_bb = gradients[(bb % 8) + 1][1] * (xf - 1) + gradients[(bb % 8) + 1][2] * (yf - 1)

    local x1 = lerp(u, dot_aa, dot_ba)
    local x2 = lerp(u, dot_ab, dot_bb)

    return (lerp(v, x1, x2) + 1) / 2  -- Normalizar para o intervalo [0, 1]
end

function GenerateHeightmap(width, height, scale, amplitude)
    local heightmap = {}
    
    for y = 1, height do
        heightmap[y] = {}
        for x = 1, width do
            local nx = x / scale
            local ny = y / scale
            local value = PerlinNoise(nx, ny)
            heightmap[y][x] = (value + 1.0) * 0.5 * amplitude
        end
    end

    return heightmap
end

local startTime = os.clock()
local Heightmap = GenerateHeightmap(5, 5, 20, 25)
local endTime = os.clock()
print(string.format("Tempo de execução: %f segundos", endTime - startTime))