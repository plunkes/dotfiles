# GRUB theme

`grub/lunkes/` is installed by `scripts/03-grub.sh`.

| File | Required | What |
|---|---|---|
| `background.png` | yes | 1920×1080, 8-bit RGB PNG |
| `font.ttf` | no | Pixel font; falls back to JetBrains Mono Nerd Font |
| `*.jpeg` | no | source image `background.png` was made from |

The menu sits in the empty band at the bottom (`top = 80%` in `theme.txt`); keep that area dark in any new image.

## Changing the background

GRUB only reads plain RGB PNGs: no indexed/interlaced PNG, and no progressive JPEG.

```bash
magick new.jpg -resize 1920x1080^ -gravity center -extent 1920x1080 \
  -define png:color-type=2 -strip grub/lunkes/background.png
```

For pixel art, add `-filter point` and scale by a whole number (e.g. 960×540 → `-resize 200%`) so pixels stay sharp.

## Test without rebooting

```bash
grub2-theme-preview /boot/grub/themes/lunkes   # AUR: grub2-theme-preview (uses QEMU)
```
