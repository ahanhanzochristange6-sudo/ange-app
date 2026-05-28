from PIL import Image, ImageDraw, ImageFont, ImageFilter
import math

SIZE = 1024
CX, CY = SIZE // 2, SIZE // 2

BLACK = (10, 10, 10)
FIRE_RED = (211, 47, 47)
ORANGE = (255, 111, 0)
GOLD = (255, 160, 0)
DARK_GOLD = (184, 134, 11)

def draw_logo(filename, for_icon=False):
    img = Image.new('RGBA', (SIZE, SIZE), (0,0,0,0) if for_icon else BLACK)
    draw = ImageDraw.Draw(img)

    if not for_icon:
        # Fond radial sombre
        for r in range(SIZE // 2, 0, -3):
            ratio = r / (SIZE // 2)
            col = int(10 + 25 * (1 - ratio))
            draw.ellipse([CX - r, CY - r, CX + r, CY + r], fill=(col, int(col * 0.25), int(col * 0.25)))

    # Flammes couronne
    n_flames = 24 if not for_icon else 20
    step = 360 / n_flames
    for i in range(n_flames):
        angle = math.radians(i * step)
        inner_r = 260 if not for_icon else 220
        outer_r = (360 if i % 2 == 0 else 320) if not for_icon else (380 if i % 2 == 0 else 340)
        a1 = angle - math.radians(6)
        a2 = angle + math.radians(6)
        bx = CX + inner_r * math.cos(a1)
        by = CY + inner_r * math.sin(a1)
        fx = CX + outer_r * math.cos(angle)
        fy = CY + outer_r * math.sin(angle)
        cx = CX + inner_r * math.cos(a2)
        cy = CY + inner_r * math.sin(a2)
        green = max(0, FIRE_RED[1] - i*3)
        draw.polygon([(bx, by), (fx, fy), (cx, cy)], fill=(FIRE_RED[0], green, 0))

    # Halo
    halo_r = 240 if not for_icon else 200
    for r in range(halo_r, halo_r + 20):
        ratio = (r - halo_r) / 20
        col = (int(ORANGE[0] + (GOLD[0]-ORANGE[0])*ratio), int(ORANGE[1]*ratio), 0)
        draw.ellipse([CX - r, CY - r, CX + r, CY + r], outline=col, width=3)

    # Tête lion (forme de polygone rempli avec ellipses empilées)
    top = CY - 200
    bottom = CY + 160
    for y in range(top, bottom + 1, 3):
        ratio = (y - top) / (bottom - top)
        r = int(FIRE_RED[0] + (GOLD[0] - FIRE_RED[0]) * ratio)
        g = int(FIRE_RED[1] + (GOLD[1] - FIRE_RED[1]) * ratio)
        b = int(FIRE_RED[2] + (GOLD[2] - FIRE_RED[2]) * ratio)
        rel_y = (y - CY) / 200
        try:
            dx = int(140 * math.sqrt(max(0, 1 - rel_y*rel_y)))
        except:
            dx = 0
        if dx > 0:
            draw.ellipse([CX - dx, y, CX + dx, y + 3], fill=(r, g, b))

    # Crinière intérieure
    for i in range(16):
        angle = math.radians(i * 22.5)
        r_in = 145
        r_out = 190 if i % 2 == 0 else 170
        x1 = CX + r_in * math.cos(angle)
        y1 = CY + r_in * math.sin(angle)
        x2 = CX + r_out * math.cos(angle)
        y2 = CY + r_out * math.sin(angle)
        draw.line([(x1, y1), (x2, y2)], fill=ORANGE, width=8)

    # Oreilles
    ear_y = -130 if not for_icon else -120
    draw.polygon([(CX - 110, CY + ear_y), (CX - 150, CY - 210), (CX - 60, CY - 160)], fill=DARK_GOLD)
    draw.polygon([(CX + 110, CY + ear_y), (CX + 150, CY - 210), (CX + 60, CY - 160)], fill=DARK_GOLD)

    # Yeux
    eye_y = -60
    eye_left = [(CX - 80, CY + eye_y), (CX - 40, CY - 80), (CX - 20, CY - 50), (CX - 50, CY - 30)]
    eye_right = [(CX + 80, CY + eye_y), (CX + 40, CY - 80), (CX + 20, CY - 50), (CX + 50, CY - 30)]
    draw.polygon(eye_left, fill=(255, 220, 0))
    draw.polygon(eye_right, fill=(255, 220, 0))
    draw.ellipse([CX - 60, CY - 65, CX - 40, CY - 45], fill=BLACK)
    draw.ellipse([CX + 40, CY - 65, CX + 60, CY - 45], fill=BLACK)

    # Nez
    draw.polygon([(CX, CY - 20), (CX - 30, CY + 30), (CX + 30, CY + 30)], fill=BLACK)

    # Bouche noire
    mouth_y = 30 if not for_icon else 20
    mouth_h = 120 if not for_icon else 110
    draw.ellipse([CX - 70, CY + mouth_y, CX + 70, CY + mouth_h], fill=BLACK)

    # Texte ANGE
    try:
        font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 52)
    except:
        try:
            font = ImageFont.truetype("/usr/share/fonts/TTF/DejaVuSans-Bold.ttf", 52)
        except:
            font = ImageFont.load_default()
    bbox = draw.textbbox((0,0), "ANGE", font=font)
    tw = bbox[2] - bbox[0]
    th = bbox[3] - bbox[1]
    text_y = CY + 65 - th/2 if not for_icon else CY + 55 - th/2
    draw.text((CX - tw/2, text_y), "ANGE", font=font, fill=GOLD)

    if not for_icon:
        img = img.filter(ImageFilter.GaussianBlur(radius=1))
    img.save('/home/user/ange/assets/images/' + filename)
    print(f"{filename} sauvegardé.")

draw_logo('logo.png', for_icon=False)
draw_logo('icon.png', for_icon=True)
