# 1x -> 2x automatic no-input scaling

# Heavily modified version of similar script committed by MathIsFun
# https://github.com/MathIsFun0/Cryptid/blob/main/assets/2x/resize.py

# Requires Pillow to be installed

import sys, os, time
from PIL import Image

def upscale_pixel_art(input_image, output_directory, input_image_path):
    # Double the size
    new_size = (int(input_image.width * 2), int(input_image.height * 2))
    resized_image = input_image.resize(new_size, Image.NEAREST)  # NEAREST resampling preserves pixelation

    # Save the resized image
    filename = os.path.basename(input_image_path)
    output_image_path = os.path.join(output_directory, filename)
    resized_image.save(output_image_path)

# Get paths of folders
directory_assets = os.path.dirname(os.path.dirname(__file__)) # Parent of parent of this very file
directory_1x = os.path.join(directory_assets, "1x")
directory_2x = os.path.join(directory_assets, "2x")

for file in os.listdir(directory_1x):
    # Get file name and paths
    filename = os.fsdecode(file)
    if filename.split(".")[-1] != "png": continue
    input_image_path = os.path.join(directory_1x, filename)
    input_image = Image.open(input_image_path)
    upscale_pixel_art(input_image, directory_2x, input_image_path)