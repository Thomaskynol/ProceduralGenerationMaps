local Utils = {}

-- Salva a matriz como um dicionário Python (formato {(y, x): valor})
function Utils.SaveMapAsPythonDict(map, filename)
    local file = assert(io.open(filename, "w"), "Não foi possível abrir o arquivo para escrita: " .. filename)
    file:write("{\n")
    for y = 1, #map do
        for x = 1, #map[y] do
            local value = string.format("%.4f", map[y][x])
            file:write(string.format("  (%d, %d): %s,\n", y, x, value))
        end
    end
    file:write("}\n")
    file:close()
end

-- Salva a matriz como uma lista Python (formato [[...], [...], ...])
function Utils.SaveMapAsPythonArray(map, filename)
    local file = assert(io.open(filename, "w"), "Não foi possível abrir o arquivo para escrita: " .. filename)
    file:write("[\n")
    for y = 1, #map do
        local row = {}
        for x = 1, #map[y] do
            table.insert(row, string.format("%.4f", map[y][x]))
        end
        file:write("  [" .. table.concat(row, ", ") .. "]")
        if y < #map then
            file:write(",\n")
        else
            file:write("\n")
        end
    end
    file:write("]\n")
    file:close()
end

function Utils.Unpack(tbl)
    local result = {}
    for k, v in pairs(tbl) do
        table.insert(result, v)
    end
    return unpack(result)
end

return Utils