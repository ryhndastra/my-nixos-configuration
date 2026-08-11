#!/usr/bin/env bash
# mirror-display.sh — Mirror eDP-1 ke layar eksternal (InFocus/proyektor).
# Super+P = mulai mirror | Super+P lagi = stop mirror
#
# Dipanggil via Niri bind: Mod+P { spawn-sh "...mirror-display.sh"; }

INTERNAL="eDP-1"

# --- TOGGLE: kalau wl-mirror lagi jalan, matiin dulu ---
if pgrep -x "wl-mirror" > /dev/null; then
  pkill -x "wl-mirror"
  notify-send -u normal "Mirror Display 🖥️" "Mirror dihentikan."
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
  notify-send -u critical "Mirror Display ❌" "Tidak ada layar eksternal terdeteksi.\nCoba colok kabel HDMI/DP/Type-C dulu bro!"
  exit 1
fi

# --- Jalankan wl-mirror: fullscreen langsung di output eksternal ---
wl-mirror --fullscreen-output "${EXTERNAL}" "${INTERNAL}" &

notify-send -u normal "Mirror Display 🖥️" "Mirroring ke: ${EXTERNAL}\nTekan Super+P lagi untuk stop."
