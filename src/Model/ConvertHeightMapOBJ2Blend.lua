local ToolsFolder = "./Tools/"
local python3 = "./.venv/bin/python3"

local function ConvertHeightMapOBJ2Blend(objfile, filename)

    local file = io.open(filename, "r")
    if file then
        -- O arquivo já existe, então removemos ele
        file:close()  -- Fechar o arquivo antes de removê-lo
        os.remove(filename)
        print("Arquivo existente removido: " .. filename)
    end
    file = io.open(filename.."1", "r")
    if file then
        -- O arquivo já existe, então removemos ele
        file:close()  -- Fechar o arquivo antes de removê-lo
        os.remove(filename)
        print("Arquivo existente removido: " .. filename)
    end

    local Command = python3.." "..ToolsFolder.."obj2blend.py "..objfile.." "..filename
    os.execute(Command)
end

return ConvertHeightMapOBJ2Blend