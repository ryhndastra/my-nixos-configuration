import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

// ============================================================
// shell.qml — Quickshell Bar Entry Point
// Manages all state, system polling, and PanelWindow layout.
// Visual widgets live in separate component files.
// ============================================================
ShellRoot {
    id: root

    // === Global Bar State ===
    property int  activeDesktop:  1
    property string openDropdown: ""   // "clock" | "stats" | "volume" | "battery" | ""

    // === Media / MPRIS State ===
    property string playerName:   ""
    property string playerIcon:   "󰎆"
    property string trackTitle:   ""
    property string trackArtist:  ""
    property bool   isPlaying:    false

    // === System Stats State ===
    property int    cpuPercent:   0
    property string ramText:      "--"
    property int    ramUsedMB:    0
    property int    ramTotalMB:   24000

    // === Battery State ===
    property int  batteryPercent: 0
    property bool batteryCharging: false

    // === Volume State ===
    property int  volumePercent:  80
    property bool volumeMuted:    false

    // ─────────────────────────────────────────────────────────
    // SYSTEM POLLING — all Process objects live here
    // ─────────────────────────────────────────────────────────

    // 1. Active Desktop (poll every 350ms)
    Process {
        id: desktopProc
        command: ["sh", "-c", "qdbus org.kde.KWin /KWin currentDesktop 2>/dev/null || echo 1"]
        stdout: SplitParser {
            onRead: function(line) {
                var n = parseInt(line.trim())
                if (!isNaN(n) && n >= 1 && n <= 5) root.activeDesktop = n
            }
        }
    }
    Timer {
        interval: 350; running: true; repeat: true
        onTriggered: if (!desktopProc.running) desktopProc.running = true
    }

    // 2. RAM (poll every 3s)
    Process {
        id: ramProc
        command: ["sh", "-c", "free -m | awk 'NR==2{printf \"%dM/%dM|%d|%d\", $3, $2, $3, $2}'"]
        stdout: SplitParser {
            onRead: function(line) {
                var parts = line.trim().split("|")
                if (parts.length >= 3) {
                    root.ramText   = parts[0]
                    root.ramUsedMB = parseInt(parts[1]) || 0
                    root.ramTotalMB= parseInt(parts[2]) || 24000
                }
            }
        }
    }

    // 3. CPU (poll every 5s — vmstat takes 1s)
    Process {
        id: cpuProc
        command: ["sh", "-c", "vmstat 1 2 2>/dev/null | tail -1 | awk '{print 100-$15}'"]
        stdout: SplitParser {
            onRead: function(line) {
                var v = parseInt(line.trim())
                if (!isNaN(v)) root.cpuPercent = v
            }
        }
    }

    // 4. Battery (poll every 5s)
    Process {
        id: batProc
        command: ["sh", "-c", "cap=$(cat /sys/class/power_supply/BAT1/capacity 2>/dev/null); chg=$(cat /sys/class/power_supply/ADP1/online 2>/dev/null); echo \"${cap:-0}|${chg:-0}\""]
        stdout: SplitParser {
            onRead: function(line) {
                var parts = line.trim().split("|")
                if (parts.length >= 2) {
                    var cap = parseInt(parts[0])
                    if (!isNaN(cap)) root.batteryPercent = cap
                    root.batteryCharging = parts[1].trim() === "1"
                }
            }
        }
    }

    // 5. Volume (poll every 2s)
    Process {
        id: volProc
        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null"]
        stdout: SplitParser {
            onRead: function(line) {
                var l = line.trim()
                var parts = l.split(" ")
                if (parts.length >= 2) {
                    var pct = Math.round(parseFloat(parts[1]) * 100)
                    if (!isNaN(pct)) root.volumePercent = Math.max(0, Math.min(150, pct))
                }
                root.volumeMuted = l.includes("[MUTED]")
            }
        }
    }

    // 6. MPRIS Media Player (poll every 2s)
    Process {
        id: mediaProc
        command: ["sh", "-c", "playerctl -a metadata --format '{{playerName}}|||{{title}}|||{{artist}}|||{{status}}' 2>/dev/null | head -1"]
        stdout: SplitParser {
            onRead: function(line) {
                var l = line.trim()
                if (l === "" || l.startsWith("No players")) {
                    root.playerName = ""; root.trackTitle = ""; root.trackArtist = ""; root.isPlaying = false
                    return
                }
                var p = l.split("|||")
                var pn = (p[0] || "").toLowerCase()
                root.playerName   = pn
                root.trackTitle   = p[1] || ""
                root.trackArtist  = p[2] || ""
                root.isPlaying    = (p[3] || "").trim() === "Playing"

                // Dynamic player icon based on player name
                if      (pn.includes("spotify"))                  root.playerIcon = "󰓇"
                else if (pn.includes("zen") || pn.includes("firefox") ||
                         pn.includes("brave") || pn.includes("chrome")) root.playerIcon = "󰈹"
                else if (pn.includes("mpv"))                      root.playerIcon = "󰕼"
                else if (pn.includes("vlc"))                      root.playerIcon = "󰕼"
                else if (pn.includes("rhythmbox") || pn.includes("lollypop")) root.playerIcon = "󰎵"
                else                                              root.playerIcon = "󰎆"
            }
        }
    }

    // Polling timers
    Timer { interval: 3000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: { if (!ramProc.running) ramProc.running = true; if (!batProc.running) batProc.running = true } }
    Timer { interval: 2000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: { if (!volProc.running) volProc.running = true; if (!mediaProc.running) mediaProc.running = true } }
    Timer { interval: 5000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: if (!cpuProc.running) cpuProc.running = true }

    // ─────────────────────────────────────────────────────────
    // PANEL WINDOW — the floating glass bar
    // ─────────────────────────────────────────────────────────
    PanelWindow {
        id: barWindow

        anchors { top: true; left: true; right: true }
        // Expand height to accommodate dropdown panels
        implicitHeight: 46 + (root.openDropdown !== "" ? dropdownHeight : 0)
        color: "transparent"

        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        WlrLayershell.namespace: "quickshell-bar"

        readonly property int barH: 44
        readonly property int dropdownHeight: 250

        // ── Dismiss overlay: tap anywhere below bar to close dropdown ──
        MouseArea {
            anchors { top: parent.top; topMargin: barWindow.barH; left: parent.left; right: parent.right; bottom: parent.bottom }
            visible: root.openDropdown !== ""
            z: 5
            onClicked: root.openDropdown = ""
        }

        // ── Main Glass Capsule Bar ──
        Rectangle {
            id: barCapsule
            anchors {
                top: parent.top; topMargin: 5
                left: parent.left; leftMargin: 10
                right: parent.right; rightMargin: 10
            }
            height: 34
            radius: 12
            color: "#c8181825"       // More opaque — 78% solid
            border.color: "#90cba6f7"
            border.width: 1.5
            z: 10

            // Top glass specular sheen
            Rectangle {
                anchors { top: parent.top; topMargin: 1; left: parent.left; leftMargin: 14; right: parent.right; rightMargin: 14 }
                height: 1; color: "#40ffffff"; radius: 1
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                spacing: 6

                // ── LEFT ──────────────────────────────────────────
                // NixOS Launcher Button
                Rectangle {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 28
                    Layout.preferredHeight: 22
                    radius: 6
                    color: nixMa.containsMouse ? "#40cba6f7" : "#20cba6f7"
                    border.color: nixMa.containsMouse ? "#cba6f7" : "#35cba6f7"
                    border.width: 1
                    Text {
                        anchors.centerIn: parent; text: "󱄅"
                        font.pixelSize: 14; color: "#cba6f7"
                    }
                    MouseArea {
                        id: nixMa; anchors.fill: parent; hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Quickshell.execDetached(["qdbus", "org.kde.krunner", "/App", "display"])
                    }
                }

                // Workspace pills
                WorkspaceWidget {
                    Layout.alignment: Qt.AlignVCenter
                    activeDesktop: root.activeDesktop
                    onDesktopClicked: (d) => Quickshell.execDetached(["qdbus", "org.kde.KWin", "/KWin", "setCurrentDesktop", "" + d])
                }

                // Media player (hidden when no player)
                MediaWidget {
                    Layout.alignment: Qt.AlignVCenter
                    visible: root.playerName !== ""
                    playerIcon: root.playerIcon
                    playerName: root.playerName
                    isPlaying: root.isPlaying
                    trackTitle: root.trackTitle
                    trackArtist: root.trackArtist
                    onPrev: Quickshell.execDetached(["playerctl", "previous"])
                    onPlayPause: Quickshell.execDetached(["playerctl", "play-pause"])
                    onNext: Quickshell.execDetached(["playerctl", "next"])
                }

                Item { Layout.fillWidth: true }

                // ── CENTER ────────────────────────────────────────
                ClockWidget {
                    Layout.alignment: Qt.AlignVCenter
                    isOpen: root.openDropdown === "clock"
                    onClicked: root.openDropdown = root.openDropdown === "clock" ? "" : "clock"
                }

                Item { Layout.fillWidth: true }

                // ── RIGHT ─────────────────────────────────────────
                StatsWidget {
                    Layout.alignment: Qt.AlignVCenter
                    cpuPercent: root.cpuPercent
                    ramText: root.ramText
                    isOpen: root.openDropdown === "stats"
                    onClicked: root.openDropdown = root.openDropdown === "stats" ? "" : "stats"
                }

                VolumeWidget {
                    Layout.alignment: Qt.AlignVCenter
                    volumePercent: root.volumePercent
                    muted: root.volumeMuted
                    isOpen: root.openDropdown === "volume"
                    onScroll: (up) => {
                        Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", up ? "5%+" : "5%-"])
                        if (!volProc.running) volProc.running = true
                    }
                    onClicked: root.openDropdown = root.openDropdown === "volume" ? "" : "volume"
                }

                BatteryWidget {
                    Layout.alignment: Qt.AlignVCenter
                    batteryPercent: root.batteryPercent
                    charging: root.batteryCharging
                    isOpen: root.openDropdown === "battery"
                    onClicked: root.openDropdown = root.openDropdown === "battery" ? "" : "battery"
                }

                ActionHub {
                    Layout.alignment: Qt.AlignVCenter
                    onLaunchKitty:    Quickshell.execDetached(["kitty"])
                    onLaunchBrowser:  Quickshell.execDetached(["zen-beta"])
                    onScreenshot:     Quickshell.execDetached(["spectacle", "-r"])
                    onLockScreen:     Quickshell.execDetached(["loginctl", "lock-session"])
                    onLogout:         Quickshell.execDetached(["qdbus", "org.kde.Shutdown", "/Shutdown", "logoutAndPrompt"])
                }
            }
        }

        // ── Dropdown Panels (appear below capsule on click) ────
        // Calendar Dropdown (Clock widget)
        CalendarDropdown {
            visible: root.openDropdown === "clock"
            anchors { top: barCapsule.bottom; topMargin: 6; horizontalCenter: barWindow.horizontalCenter }
            z: 20
            Behavior on opacity { NumberAnimation { duration: 150 } }
            opacity: visible ? 1 : 0
        }

        // Stats Dropdown
        StatsDropdown {
            visible: root.openDropdown === "stats"
            cpuPercent: root.cpuPercent
            ramText: root.ramText
            ramUsedMB: root.ramUsedMB
            ramTotalMB: root.ramTotalMB
            anchors { top: barCapsule.bottom; topMargin: 6; right: barWindow.right; rightMargin: 140 }
            z: 20
            opacity: visible ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }

        // Volume Dropdown
        VolumeDropdown {
            visible: root.openDropdown === "volume"
            volumePercent: root.volumePercent
            muted: root.volumeMuted
            onScroll: (up) => Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", up ? "5%+" : "5%-"])
            onMuteToggle: {
                Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"])
                if (!volProc.running) volProc.running = true
            }
            anchors { top: barCapsule.bottom; topMargin: 6; right: barWindow.right; rightMargin: 80 }
            z: 20
            opacity: visible ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }

        // Battery Dropdown
        BatteryDropdown {
            visible: root.openDropdown === "battery"
            batteryPercent: root.batteryPercent
            charging: root.batteryCharging
            anchors { top: barCapsule.bottom; topMargin: 6; right: barWindow.right; rightMargin: 20 }
            z: 20
            opacity: visible ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }
    }
}
