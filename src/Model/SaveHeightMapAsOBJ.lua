local function SaveHeightmapAsOBJ(heightmap, filename, resolution, heightScale)
    local width = #heightmap[1]
    local height = #heightmap

    local file = assert(io.open(filename, "w"), "Não foi possível abrir o arquivo .obj")

    -- Escreve vértices
    for y = 1, height do
        for x = 1, width do
            local worldX = (x - 1) * resolution
            local worldY = (y - 1) * resolution
            local worldZ = heightmap[y][x] * heightScale

            file:write(string.format("v %.3f %.3f %.3f\n", worldX, worldZ, worldY))
        end
    end

    -- Escreve faces
    -- Cada célula se transforma em dois triângulos
    for y = 1, height - 1 do
        for x = 1, width - 1 do
            local i = (y - 1) * width + x
            local iRight = i + 1
            local iBelow = i + width
            local iDiag = iBelow + 1

            -- Triângulo 1
            file:write(string.format("f %d %d %d\n", i, iBelow, iRight))
            -- Triângulo 2
            file:write(string.format("f %d %d %d\n", iRight, iBelow, iDiag))
        end
    end

    file:close()
    print("Arquivo OBJ salvo em: " .. filename)
end

return SaveHeightmapAsOBJ