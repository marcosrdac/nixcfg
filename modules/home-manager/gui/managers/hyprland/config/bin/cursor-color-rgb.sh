#!/usr/bin/env bash
set -euo pipefail

pos="$(hyprctl cursorpos)"
x="${pos%,*}"
y="${pos#*, }"

pixel="$(
  grim -g "${x},${y} 1x1" - \
    | magick - -format '%[pixel:p{0,0}]' info:
)"

read -r r g b <<< "$(
  sed -E 's/.*\(([0-9]+),([0-9]+),([0-9]+)\).*/\1 \2 \3/' <<< "$pixel"
)"

hex="$(printf '#%02x%02x%02x' "$r" "$g" "$b")"

read -r hsv_h hsv_s hsv_v <<< "$(
  magick xc:"rgb($r,$g,$b)" -colorspace HSV \
    -format '%[fx:round(360*u.r)] %[fx:round(100*u.g)] %[fx:round(100*u.b)]' info:
)"

read -r hsl_h hsl_s hsl_l <<< "$(
  magick xc:"rgb($r,$g,$b)" -colorspace HSL \
    -format '%[fx:round(360*u.r)] %[fx:round(100*u.g)] %[fx:round(100*u.b)]' info:
)"

read -r lab_l lab_a lab_b <<< "$(
  magick xc:"rgb($r,$g,$b)" -colorspace Lab \
    -format '%[fx:round(100*u.r)] %[fx:round(255*u.g-128)] %[fx:round(255*u.b-128)]' info:
)"

lum=$(( (299*r + 587*g + 114*b) / 1000 ))
if (( lum > 140 )); then
  fg_r=0; fg_g=0; fg_b=0; fg="#000000"
else
  fg_r=255; fg_g=255; fg_b=255; fg="#ffffff"
fi

icon="/tmp/pixel-color-${hex#\#}.png"
magick -size 128x128 "xc:$hex" "$icon"

table="$(
  printf '%-5s %4d %4d %4d\n'        "RGB" "$r" "$g" "$b"
  printf '%-5s %4d° %3d%% %3d%%\n'   "HSV" "$hsv_h" "$hsv_s" "$hsv_v"
  printf '%-5s %4d° %3d%% %3d%%\n'   "HSL" "$hsl_h" "$hsl_s" "$hsl_l"
  printf '%-5s %4d %4d %4d\n'        "Lab" "$lab_l" "$lab_a" "$lab_b"
)"

printf '\n'

printf 'HEX:  \033[48;2;%s;%s;%sm        \033[0m  %s\n' \
  "$r" "$g" "$b" "$hex"

printf 'TXT:  \033[48;2;%s;%s;%sm\033[38;2;%s;%s;%sm  %s on %s  \033[0m\n' \
  "$r" "$g" "$b" \
  "$fg_r" "$fg_g" "$fg_b" \
  "$fg" "$hex"

printf '\n%s\n' "$table"

printf '%s' "$hex" | wl-copy

notify-send -i "$icon" "$hex" "$table"
