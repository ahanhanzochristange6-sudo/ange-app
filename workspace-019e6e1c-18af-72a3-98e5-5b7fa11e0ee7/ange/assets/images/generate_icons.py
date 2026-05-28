from PIL import Image
import os

sizes = {
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192,
}

base = Image.open('/home/user/ange/assets/images/icon.png').convert('RGBA')
# For store
base.resize((512,512), Image.Resampling.LANCZOS).save('/home/user/ange/assets/images/store_icon.png')

for folder, size in sizes.items():
    path = f'/home/user/ange/android/app/src/main/res/{folder}/ic_launcher.png'
    img = base.resize((size, size), Image.Resampling.LANCZOS)
    img.save(path)
    print(f'Saved {path}')

print('All icons generated.')
