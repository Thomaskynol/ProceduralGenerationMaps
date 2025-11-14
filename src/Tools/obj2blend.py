import sys
import os
import subprocess
from pywavefront import Wavefront

if len(sys.argv) < 3:
    print("Uso: python converter_obj_to_blend.py input.obj output.blend")
    sys.exit(1)

obj_path = sys.argv[1]
blend_path = sys.argv[2]

scene = Wavefront(obj_path, collect_faces=True)

vertices = []
faces = []

# Extrai geometria
for name, mesh in scene.meshes.items():
    for face in mesh.faces:
        faces.append(face)
    for v in scene.vertices:
        vertices.append(v)

# Gera script temporário que o Blender irá rodar
blender_script = f"""
import bpy
import math
import mathutils

# Limpar cena
bpy.ops.wm.read_factory_settings(use_empty=True)

# Criar malha
mesh = bpy.data.meshes.new("ImportedOBJ")
mesh.from_pydata({vertices}, [], {faces})
mesh.update()

obj = bpy.data.objects.new("ImportedOBJ", mesh)
bpy.context.collection.objects.link(obj)

# Corrigir orientação (OBJ usa Y-up → Blender Z-up)
obj.rotation_euler[0] = math.pi / 2

# ===== CENTRALIZAR SEM OPERADORES =====

# Calcula o centro da malha
mesh.calc_loop_triangles()
min_x = min(v.co.x for v in mesh.vertices)
max_x = max(v.co.x for v in mesh.vertices)
min_y = min(v.co.y for v in mesh.vertices)
max_y = max(v.co.y for v in mesh.vertices)
min_z = min(v.co.z for v in mesh.vertices)
max_z = max(v.co.z for v in mesh.vertices)

center = mathutils.Vector((
    (min_x + max_x) / 2.0,
    (min_y + max_y) / 2.0,
    (min_z + max_z) / 2.0,
))

# Move todos os vértices para que o centro fique em (0,0,0)
for v in mesh.vertices:
    v.co -= center

mesh.update()

# Garante que o objeto está no (0,0,0)
obj.location = (0.0, 0.0, 0.0)

# ========== FIM CENTRALIZAÇÃO ==========

# Salvar .blend
bpy.ops.wm.save_as_mainfile(filepath=r"{os.path.abspath(blend_path)}")
"""



temp_script = "temp_import_script.py"
with open(temp_script, "w") as f:
    f.write(blender_script)

# Executa Blender em modo background
subprocess.run(["blender", "--background", "--python", temp_script])

# Limpa script temporário
os.remove(temp_script)

print(f"Convertido com sucesso:\n{obj_path}  →  {blend_path}")
