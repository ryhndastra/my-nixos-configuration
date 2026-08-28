#!/usr/bin/env bash
# mirror-display.sh — Mirror eDP-1 ke layar eksternal (InFocus/proyektor).
# Super+P = mulai mirror | Super+P lagi = stop mirror

INTERNAL="eDP-1"

# --- TOGGLE: kalau wl-mirror lagi jalan, matiin dulu ---
if pgrep -x "wl-mirror" > /dev/null; then
  pkill -x "wl-mirror"
  notify-send "Mirror Display" "Mirror dihentikan. 🖥️" -a "System"
  exit 0
fi

# --- Cari output eksternal yang tersambung di Hyprland ---
EXTERNAL=$(hyprctl monitors -j 2>/dev/null \
  | python3 -c "
import sys, json
try:
    outputs = json.load(sys.stdin)
    for o in outputs:
        if o.get('name') != 'eDP-1':
            print(o.get('name'))
            break
except:
    pass
" 2>/dev/null)

if [ -z "$EXTERNAL" ]; then
  notify-send "Mirror Display" "❌ Tidak ada layar eksternal terdeteksi. Colok kabel HDMI/DP dulu!" -a "System"
  exit 1
fi

# --- Jalankan wl-mirror: fullscreen langsung di output eksternal ---
wl-mirror --fullscreen-output "${EXTERNAL}" "${INTERNAL}" &

notify-send "Mirror Display" "🖥️ Mirroring ke: ${EXTERNAL}. Tekan Super+P lagi untuk stop." -a "System"

