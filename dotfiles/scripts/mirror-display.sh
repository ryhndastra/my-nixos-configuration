#!/usr/bin/env bash
# mirror-display.sh — Mirror eDP-1 ke layar eksternal (InFocus/proyektor).
# Super+P = mulai mirror | Super+P lagi = stop mirror

INTERNAL="eDP-1"

# --- TOGGLE: kalau wl-mirror lagi jalan, matiin dulu ---
if pgrep -x "wl-mirror" > /dev/null; then
  pkill -x "wl-mirror"
  noctalia msg notification-show "Mirror dihentikan. 🖥️"
  exit 0
fi

# --- Cari output eksternal yang tersambung ---
EXTERNAL=$(niri msg outputs --json 2>/dev/null \
  | python3 -c "
import sys, json
outputs = json.load(sys.stdin)
for o in outputs:
    if o.get('name') != 'eDP-1':
        print(o.get('name'))
        break
" 2>/dev/null)

if [ -z "$EXTERNAL" ]; then
  noctalia msg notification-show "Mirror Display ❌ -- Tidak ada layar eksternal terdeteksi. Colok kabel HDMI/DP dulu!"
  exit 1
fi

# --- Jalankan wl-mirror: fullscreen langsung di output eksternal ---
wl-mirror --fullscreen-output "${EXTERNAL}" "${INTERNAL}" &

noctalia msg notification-show "Mirror Display 🖥️ -- Mirroring ke: ${EXTERNAL}. Tekan Super+P lagi untuk stop."
