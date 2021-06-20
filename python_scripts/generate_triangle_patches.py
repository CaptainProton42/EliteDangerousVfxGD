# This script generates the texture containing the triangle patches for the
# triangle wave VFX.
# Needs Pillow to run: pip install pillow
# The script is not perfect, there's artifacts between the triangle patches.

import numpy as np
from PIL import Image

# Adjust these values to change resolution and number of triangles.
size_x = 1000
size_y = 1400

num_tris_x = 10
num_tris_y = 14

data = np.zeros((size_x, size_y, 3), dtype=np.uint8)

def sdTri(p_x, p_y):
    k = np.sqrt(3.0)
    p_x = np.abs(p_x) - 1.0
    p_y = p_y + 1.0 / k
    if (p_x + k*p_y > 0.0):
        tp_x = (p_x - k*p_y) / 2.0
        p_y = (-k*p_x - p_y) / 2.0
        p_x = tp_x
    p_x -= np.clip(p_x, -2.0, 0.0)
    return -np.linalg.norm([p_x, p_y]) * np.sign(p_y)

bb_x = size_x / num_tris_x
bb_y = size_y / num_tris_y

offset = 0.2*np.random.rand(num_tris_x, num_tris_y) - 0.1

for x in range(size_x):
    t_x = int(x / size_x * num_tris_x)
    p_x = 2.0 * (x - t_x * size_x / num_tris_x) / bb_x - 1.0 # rel coords
    for y in range(size_y):
        t_y = int(y / size_y * num_tris_y)
        p_y = np.sqrt(3.0) * (y - t_y * size_y / num_tris_y) / bb_y  + (2.0 / np.sqrt(3.0) - np.sqrt(3.0))# rel coords
        d_t = sdTri(p_x, p_y)
        if d_t < 0.0:
            data[x, y][1] = d_t * 255
            dtx = np.linalg.norm([t_x - 0.5*num_tris_x, t_y - 0.5*num_tris_y])
            data[x, y][0] = dtx * 255 / np.linalg.norm([0.5*num_tris_x, 0.5*num_tris_y])
            # add a random offset
            data[x, y][0] = np.clip(data[x, y][0] + offset[t_x, t_y] * 255, 0, 255)

# Due to symmetry, we can simply flip + shift
data += np.roll(np.fliplr(data), int(0.5*size_x/num_tris_x), axis=0)
        
image = Image.fromarray(data)
image.save("triangles.png")