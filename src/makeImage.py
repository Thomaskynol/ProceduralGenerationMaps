import time

def load_array_from_file(filename):
    with open(filename, 'r') as f:
        content = f.read()

    # Usa eval para transformar o texto em lista Python
    array = eval(content)
    return array

def save_heightmap_as_bmp(heightmap, filename):
    height = len(heightmap)
    width = len(heightmap[0])

    # Normaliza valores 0-255
    min_val = min(min(row) for row in heightmap)
    max_val = max(max(row) for row in heightmap)
    if max_val == min_val:
        norm = [[128]*width for _ in range(height)]
    else:
        norm = [[int((val - min_val)/(max_val - min_val)*255) for val in row] for row in heightmap]

    row_padded = (width + 3) & (~3)
    padding = row_padded - width

    filesize = 54 + 256*4 + row_padded * height  # 54 header + 256*4 palette + pixels

    # Cabeçalho BMP
    bmp_header = bytearray()
    bmp_header.extend(b'BM')                          # Signature
    bmp_header.extend(filesize.to_bytes(4, 'little'))# File size
    bmp_header.extend((0).to_bytes(2, 'little'))     # Reserved1
    bmp_header.extend((0).to_bytes(2, 'little'))     # Reserved2
    bmp_header.extend((54 + 256*4).to_bytes(4, 'little')) # Offset to pixel data

    # DIB header (BITMAPINFOHEADER)
    bmp_header.extend((40).to_bytes(4, 'little'))    # DIB header size
    bmp_header.extend(width.to_bytes(4, 'little'))   # Width
    bmp_header.extend(height.to_bytes(4, 'little'))  # Height
    bmp_header.extend((1).to_bytes(2, 'little'))     # Planes
    bmp_header.extend((8).to_bytes(2, 'little'))     # Bits per pixel
    bmp_header.extend((0).to_bytes(4, 'little'))     # Compression
    bmp_header.extend((row_padded * height).to_bytes(4, 'little')) # Image size
    bmp_header.extend((2835).to_bytes(4, 'little'))  # X pixels per meter
    bmp_header.extend((2835).to_bytes(4, 'little'))  # Y pixels per meter
    bmp_header.extend((256).to_bytes(4, 'little'))   # Colors in palette
    bmp_header.extend((0).to_bytes(4, 'little'))     # Important colors

    # Paleta grayscale
    palette = bytearray()
    for i in range(256):
        palette.extend([i, i, i, 0])

    # Dados dos pixels (bottom-up)
    pixel_data = bytearray()
    for row in reversed(norm):
        pixel_data.extend(row)
        pixel_data.extend([0]*padding)

    with open(filename, 'wb') as f:
        f.write(bmp_header)
        f.write(palette)
        f.write(pixel_data)

    print(f"Imagem BMP salva em {filename}")


heightmap = load_array_from_file("heightmap.txt")
save_heightmap_as_bmp(heightmap, "heightmap.bmp")