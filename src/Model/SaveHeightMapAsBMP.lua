local function int_to_le_bytes(n, num_bytes)
    local bytes = {}
    for i = 1, num_bytes do
        table.insert(bytes, string.char(n % 256))
        n = math.floor(n / 256)
    end
    return table.concat(bytes)
end

local function SaveHeightMapAsBMP(heightmap, filename)
    local height = #heightmap
    local width = #heightmap[1]

    for i = 1, height do
        if #heightmap[i] ~= width then
            error("Todas as linhas do heightmap devem ter o mesmo comprimento. Linha " .. i .. " tem tamanho " .. #heightmap[i])
        end
    end
    

    -- Normaliza os valores para o intervalo 0-255
    local min_val, max_val = math.huge, -math.huge
    for i = 1, height do
        for j = 1, width do
            min_val = math.min(min_val, heightmap[i][j])
            max_val = math.max(max_val, heightmap[i][j])
        end
    end

    local norm = {}
    if max_val == min_val then
        for i = 1, height do
            norm[i] = {}
            for j = 1, width do
                norm[i][j] = 128
            end
        end
    else
        for i = 1, height do
            norm[i] = {}
            for j = 1, width do
                norm[i][j] = math.floor((heightmap[i][j] - min_val) / (max_val - min_val) * 255 + 0)

            end
        end
    end

    local row_padded = width
    local padding = (4 - (row_padded % 4)) % 4
    local row_size = row_padded + padding
    local filesize = 54 + 256 * 4 + row_size * height

    -- Cabeçalho BMP
    local bmp_header = {}
    table.insert(bmp_header, string.char(66, 77))  -- "BM"
    table.insert(bmp_header, int_to_le_bytes(filesize, 4))  -- Tamanho do arquivo
    table.insert(bmp_header, int_to_le_bytes(0, 2))  -- Reservado1
    table.insert(bmp_header, int_to_le_bytes(0, 2))  -- Reservado2
    table.insert(bmp_header, int_to_le_bytes(54 + 256 * 4, 4))  -- Offset para os dados da imagem

    -- Cabeçalho DIB
    table.insert(bmp_header, int_to_le_bytes(40, 4))  -- Tamanho do cabeçalho DIB
    table.insert(bmp_header, int_to_le_bytes(width, 4))  -- Largura
    table.insert(bmp_header, int_to_le_bytes(height, 4))  -- Altura
    table.insert(bmp_header, int_to_le_bytes(1, 2))  -- Planos
    table.insert(bmp_header, int_to_le_bytes(8, 2))  -- Bits por pixel
    table.insert(bmp_header, int_to_le_bytes(0, 4))  -- Compressão
    table.insert(bmp_header, int_to_le_bytes(row_size * height, 4))  -- Tamanho da imagem em bytes (incluindo padding)
    table.insert(bmp_header, int_to_le_bytes(2835, 4))  -- X pixels por metro
    table.insert(bmp_header, int_to_le_bytes(2835, 4))  -- Y pixels por metro
    table.insert(bmp_header, int_to_le_bytes(256, 4))  -- Número de cores na paleta
    table.insert(bmp_header, int_to_le_bytes(0, 4))  -- Cores importantes

    -- Paleta de cores em escala de cinza
    local palette = {}
    for i = 0, 255 do
        table.insert(palette, string.char(i, i, i, 0))
    end

    -- Dados dos pixels (de baixo para cima)
    local pixel_data = {}
    for i = height, 1, -1 do
        for j = 1, width do

            local val = norm[i][j]
            val = math.floor(val + 0)
            if type(val) ~= "number" or val < 0 or val > 255 then
                error("Valor inválido em norm[" .. i .. "][" .. j .. "]: " .. tostring(val))
            end
            table.insert(pixel_data, string.char(val))         

        end
        for p = 1, padding do
            table.insert(pixel_data, string.char(0))
        end
    end

    -- Escrever no arquivo
    local file = io.open(filename, "wb")
    if not file then
        error("Não foi possível abrir o arquivo para escrita: " .. filename)
    end

    file:write(table.concat(bmp_header))
    file:write(table.concat(palette))
    file:write(table.concat(pixel_data))
    file:close()
    print("Imagem BMP salva em " .. filename)
end

return SaveHeightMapAsBMP