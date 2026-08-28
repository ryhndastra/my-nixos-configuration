import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

// ============================================================
// shell.qml — Quickshell Bar Entry Point
// All state, polling, and PanelWindow definitions live here.
// ============================================================
ShellRoot {
    id: root

    // ── Global State ──────────────────────────────────────────
    property int    activeDesktop:   1
    property string openDropdown:    ""    // "clock"|"stats"|"volume"|"battery"|"cc"|""
    property bool   powerMenuOpen:   false
    property real   clockWidgetX:    0
    property real   statsWidgetX:    0
    property real   volumeWidgetX:   0
    property real   batteryWidgetX:  0
    property real   ccWidgetX:       0
    property real   trayWidgetX:     0

    // ── Media / MPRIS ─────────────────────────────────────────
    property string playerName:   ""
    property string playerIcon:   "󰎆"
    property string trackTitle:   ""
    property string trackArtist:  ""
    property bool   isPlaying:    false

    // ── System Stats ──────────────────────────────────────────
    property int    cpuPercent:   0
    property int    ramPercent:   0
    property string ramDetail:    "--"

    // ── Battery ───────────────────────────────────────────────
    property int  batteryPercent:  0
    property bool batteryCharging: false

    // ── Volume ────────────────────────────────────────────────
    property int  volumePercent:   80
    property bool volumeMuted:     false

    // ── Brightness ───────────────────────────────────────────
    property int  brightnessPercent: 100

    // ── Network ───────────────────────────────────────────────
    property string netInterface:   "enp3s0"
    property string netType:        "ethernet"  // "ethernet"|"wifi"|"none"
    property string netSpeed:       "0 KB/s"
    property string netSSID:        ""
    property int    netSignal:      0
    property real   prevNetRxBytes: 0
    property real   prevNetTxBytes: 0

    // ── WiFi Scan ─────────────────────────────────────────────
    property var    wifiNetworks:   []
    property bool   wifiScanning:   false

    // ─────────────────────────────────────────────────────────
    // SYSTEM POLLING — all Process objects live here
    // ─────────────────────────────────────────────────────────

    // 1. Active Desktop (every 350ms)
    Process {
        id: desktopProc
        command: ["sh", "-c", "qdbus org.kde.KWin /KWin currentDesktop 2>/dev/null || echo 1"]
        stdout: SplitParser {
            onRead: function(line) {
                var n = parseInt(line.trim())
                if (!isNaN(n) && n >= 1 && n <= 9) root.activeDesktop = n
            }
        }
    }
    Timer { interval: 350; running: true; repeat: true
        onTriggered: if (!desktopProc.running) desktopProc.running = true }

    // 2. RAM + CPU (every 2s) — uses /proc/stat delta instead of slow `top`
    property real prevCpuIdle: 0
    property real prevCpuTotal: 0
    Process {
        id: statsProc
        command: ["sh", "-c",
            "cpu=$(awk '/^cpu /{print $2+$3+$4+$5+$6+$7+$8\"|\"$5}' /proc/stat);" +
            "ram=$(free | awk 'NR==2{printf \"%d|%d|%d\", $3/$2*100, $3/1024, $2/1024}');" +
            "echo \"$cpu|$ram\""]
        stdout: SplitParser {
            onRead: function(line) {
                var p = line.trim().split("|")
                if (p.length >= 5) {
                    var total = parseFloat(p[0]) || 0
                    var idle  = parseFloat(p[1]) || 0
                    if (root.prevCpuTotal > 0) {
                        var dt = total - root.prevCpuTotal
                        var di = idle  - root.prevCpuIdle
                        root.cpuPercent = dt > 0 ? Math.round((1 - di / dt) * 100) : 0
                    }
                    root.prevCpuTotal = total
                    root.prevCpuIdle  = idle
                    root.ramPercent  = parseInt(p[2]) || 0
                    var used = Math.round(parseInt(p[3]) / 1024 * 10) / 10
                    var total2 = Math.round(parseInt(p[4]) / 1024 * 10) / 10
                    root.ramDetail = used + "G / " + total2 + "G"
                }
            }
        }
    }
    Timer { interval: 2000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: if (!statsProc.running) statsProc.running = true }

    // 3. Battery (every 10s)
    Process {
        id: batProc
        command: ["sh", "-c",
            "cap=$(cat /sys/class/power_supply/BAT1/capacity 2>/dev/null || echo 0);" +
            "chg=$(cat /sys/class/power_supply/ADP1/online 2>/dev/null || echo 0);" +
            "echo \"$cap|$chg\""]
        stdout: SplitParser {
            onRead: function(line) {
                var p = line.trim().split("|")
                if (p.length >= 2) {
                    var c = parseInt(p[0]); if (!isNaN(c)) root.batteryPercent = c
                    root.batteryCharging = p[1].trim() === "1"
                }
            }
        }
    }
    Timer { interval: 10000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: if (!batProc.running) batProc.running = true }

    // 4. Volume (every 2s)
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
    Timer { interval: 2000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: if (!volProc.running) volProc.running = true }

    // 5. MPRIS Media (every 2s) — with active check
    Process {
        id: mediaProc
        command: ["sh", "-c",
            "status=$(playerctl -a status 2>/dev/null | grep -E 'Playing|Paused' | head -1);" +
            "if [ -z \"$status\" ]; then echo 'NONE'; exit 0; fi;" +
            "playerctl -a metadata --format '{{playerName}}|||{{title}}|||{{artist}}|||{{status}}' 2>/dev/null | head -1"]
        stdout: SplitParser {
            onRead: function(line) {
                var l = line.trim()
                if (l === "" || l === "NONE" || l.startsWith("No players")) {
                    root.playerName = ""; root.trackTitle = ""; root.trackArtist = ""; root.isPlaying = false
                    return
                }
                var p = l.split("|||")
                var pn = (p[0] || "").toLowerCase()
                var status = (p[3] || "").trim()
                if (status !== "Playing" && status !== "Paused") {
                    root.playerName = ""; root.trackTitle = ""; root.trackArtist = ""; root.isPlaying = false
                    return
                }
                root.playerName   = pn
                root.trackTitle   = p[1] || ""
                root.trackArtist  = p[2] || ""
                root.isPlaying    = status === "Playing"
                // Dynamic icon
                if      (pn.includes("spotify"))   root.playerIcon = "󰓇"
                else if (pn.includes("zen") || pn.includes("firefox") || pn.includes("chrome") || pn.includes("brave")) root.playerIcon = "󰈹"
                else if (pn.includes("mpv") || pn.includes("vlc"))        root.playerIcon = "󰕼"
                else                                                      root.playerIcon = "󰎆"
            }
        }
    }
    Timer { interval: 2000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: if (!mediaProc.running) mediaProc.running = true }

    // 6. Brightness (every 5s)
    Process {
        id: brightProc
        command: ["sh", "-c",
            "cur=$(brightnessctl get 2>/dev/null || echo 100);" +
            "max=$(brightnessctl max 2>/dev/null || echo 100);" +
            "echo \"$cur|$max\""]
        stdout: SplitParser {
            onRead: function(line) {
                var p = line.trim().split("|")
                if (p.length >= 2) {
                    var cur = parseInt(p[0]); var max = parseInt(p[1])
                    if (!isNaN(cur) && !isNaN(max) && max > 0)
                        root.brightnessPercent = Math.round(cur / max * 100)
                }
            }
        }
    }
    Timer { interval: 5000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: if (!brightProc.running) brightProc.running = true }

    // 7. Network speed (every 2s)
    Process {
        id: netProc
        command: ["sh", "-c",
            "iface=$(ip route get 8.8.8.8 2>/dev/null | grep -oP 'dev \\K\\S+' | head -1 || echo enp3s0);" +
            "rx=$(cat /proc/net/dev 2>/dev/null | awk -v iface=\"$iface:\" '$1==iface{print $2}');" +
            "tx=$(cat /proc/net/dev 2>/dev/null | awk -v iface=\"$iface:\" '$1==iface{print $10}');" +
            "type=$(nmcli -t -f TYPE,STATE device 2>/dev/null | grep connected | head -1 | cut -d: -f1 || echo ethernet);" +
            "ssid=$(nmcli -t -f ACTIVE,SSID dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2 || echo '');" +
            "echo \"$iface|$rx|$tx|$type|$ssid\""]
        stdout: SplitParser {
            onRead: function(line) {
                var p = line.trim().split("|")
                if (p.length < 3) return
                root.netInterface = p[0]
                var rx = parseFloat(p[1]) || 0
                var tx = parseFloat(p[2]) || 0
                var deltaRx = Math.max(0, rx - root.prevNetRxBytes)
                var deltaTx = Math.max(0, tx - root.prevNetTxBytes)
                var combined = (deltaRx + deltaTx) / 2
                if (root.prevNetRxBytes > 0) {
                    var kbps = combined / 1024
                    if (kbps > 1024) root.netSpeed = (Math.round(kbps / 102.4) / 10) + " MB/s"
                    else             root.netSpeed = Math.round(kbps) + " KB/s"
                }
                root.prevNetRxBytes = rx
                root.prevNetTxBytes = tx
                var t = (p[3] || "").trim()
                root.netType = t.includes("wifi") ? "wifi" : t.includes("ethernet") ? "ethernet" : "none"
                root.netSSID = (p[4] || "").trim()
            }
        }
    }
    Timer { interval: 2000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: if (!netProc.running) netProc.running = true }

    // 8. WiFi scan (on demand)
    Process {
        id: wifiScanProc
        command: ["sh", "-c", "nmcli -t -f SSID,SIGNAL,SECURITY,IN-USE dev wifi list 2>/dev/null | head -20"]
        stdout: SplitParser {
            onRead: function(line) {
                var p = line.trim().split(":")
                if (p.length >= 3 && p[0] !== "") {
                    var nets = root.wifiNetworks.slice()
                    nets.push({ ssid: p[0], signal: parseInt(p[1]) || 0, security: p[2] || "", active: p[3] === "*" })
                    root.wifiNetworks = nets
                }
            }
        }
        onRunningChanged: {
            if (!running) root.wifiScanning = false
        }
    }
    function scanWifi() {
        root.wifiNetworks = []
        root.wifiScanning = true
        if (!wifiScanProc.running) wifiScanProc.running = true
    }

    // ─────────────────────────────────────────────────────────
    // MAIN BAR PANEL WINDOW
    // ─────────────────────────────────────────────────────────
    PanelWindow {
        id: barWindow
        anchors { top: true; left: true; right: true }
        implicitHeight: barH + (root.openDropdown !== "" ? dropdownMaxH : 0)
        color: "transparent"

        // Request compositor background blur behind bar
        BackgroundEffect.blurRegion: Region { item: barCapsule }

        WlrLayershell.layer:         WlrLayer.Top
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        WlrLayershell.namespace:     "quickshell-bar"
        WlrLayershell.exclusiveZone: barH

        readonly property int barH:        44
        readonly property int dropdownMaxH: 480

        // Dismiss overlay — click below bar to close any dropdown
        MouseArea {
            anchors { top: parent.top; topMargin: barWindow.barH; left: parent.left; right: parent.right; bottom: parent.bottom }
            visible: root.openDropdown !== ""
            z: 5
            onClicked: root.openDropdown = ""
        }

        // ── Glass Bar Capsule ────────────────────────────────
        Rectangle {
            id: barCapsule
            anchors { top: parent.top; topMargin: 5; left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10 }
            height: 34
            radius: 12
            color: "#a0181825"  // more transparent for blur
            border.color: "#95cba6f7"
            border.width: 1.5
            z: 10

            // Top specular sheen
            Rectangle {
                anchors { top: parent.top; topMargin: 1; left: parent.left; leftMargin: 16; right: parent.right; rightMargin: 16 }
                height: 1; color: "#45ffffff"; radius: 1
            }

            // ── Absolutely Centered Clock (immune to left/right width changes) ──
            ClockWidget {
                id: clockW
                anchors.centerIn: parent
                z: 2
                isOpen: root.openDropdown === "clock"
                onClicked: {
                    root.clockWidgetX = barCapsule.x + barCapsule.width / 2 - 143
                    root.openDropdown = root.openDropdown === "clock" ? "" : "clock"
                }
            }

            // ── LEFT ROW ─────────────────────────────────────
            RowLayout {
                anchors { left: parent.left; leftMargin: 8; verticalCenter: parent.verticalCenter }
                spacing: 8
                z: 1

                // NixOS Launcher
                Rectangle {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 28; Layout.preferredHeight: 22; radius: 6
                    color: nixMa.containsMouse ? "#40cba6f7" : "#20cba6f7"
                    border.color: nixMa.containsMouse ? "#cba6f7" : "#30cba6f7"; border.width: 1
                    Text { anchors.centerIn: parent; text: "󱄅"; font.pixelSize: 14; color: "#cba6f7" }
                    MouseArea {
                        id: nixMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        onClicked: Quickshell.execDetached(["qdbus", "org.kde.krunner", "/App", "display"])
                    }
                }

                // Workspace pills
                WorkspaceWidget {
                    Layout.alignment: Qt.AlignVCenter
                    activeDesktop: root.activeDesktop
                    onDesktopClicked: (d) => Quickshell.execDetached(["qdbus", "org.kde.KWin", "/KWin", "setCurrentDesktop", "" + d])
                }

                // Running & Minimized Apps Taskbar
                TaskbarWidget {
                    Layout.alignment: Qt.AlignVCenter
                }

                // Media player
                MediaWidget {
                    id: mediaW
                    Layout.alignment: Qt.AlignVCenter
                    visible: root.playerName !== ""
                    playerIcon: root.playerIcon; playerName: root.playerName
                    isPlaying: root.isPlaying; trackTitle: root.trackTitle; trackArtist: root.trackArtist
                    onPrev:      Quickshell.execDetached(["playerctl", "previous"])
                    onPlayPause: Quickshell.execDetached(["playerctl", "play-pause"])
                    onNext:      Quickshell.execDetached(["playerctl", "next"])
                }
            }

            // ── RIGHT ROW ────────────────────────────────────
            RowLayout {
                anchors { right: parent.right; rightMargin: 8; verticalCenter: parent.verticalCenter }
                spacing: 8
                z: 1

                // System Tray (Vesktop, Steam, etc.) — chevron opens dropdown
                TrayWidget {
                    id: trayW
                    Layout.alignment: Qt.AlignVCenter
                    isOpen: root.openDropdown === "tray"
                    onClicked: {
                        var p = trayW.mapToItem(barCapsule, 0, 0)
                        root.trayWidgetX = barCapsule.x + p.x + trayW.width / 2 - 110
                        root.openDropdown = root.openDropdown === "tray" ? "" : "tray"
                    }
                }

                // Noctalia Master Control Center Pill
                ControlCenterWidget {
                    id: ccW
                    Layout.alignment: Qt.AlignVCenter
                    volumePercent: root.volumePercent; volumeMuted: root.volumeMuted
                    batteryPercent: root.batteryPercent; batteryCharging: root.batteryCharging
                    netType: root.netType; isOpen: root.openDropdown === "cc"
                    onClicked: {
                        var p = ccW.mapToItem(barCapsule, 0, 0)
                        root.ccWidgetX = barCapsule.x + p.x + ccW.width / 2 - 180
                        root.openDropdown = root.openDropdown === "cc" ? "" : "cc"
                    }
                }

                BrightnessWidget {
                    id: brightW
                    Layout.alignment: Qt.AlignVCenter
                    brightnessPercent: root.brightnessPercent
                    onScroll: (up) => {
                        var newPct = Math.max(5, Math.min(100, root.brightnessPercent + (up ? 5 : -5)))
                        Quickshell.execDetached(["brightnessctl", "set", newPct + "%"])
                        if (!brightProc.running) brightProc.running = true
                    }
                }

                StatsWidget {
                    id: statsW
                    Layout.alignment: Qt.AlignVCenter
                    cpuPercent: root.cpuPercent; ramPercent: root.ramPercent
                    isOpen: root.openDropdown === "stats"
                    onClicked: {
                        var p = statsW.mapToItem(barCapsule, 0, 0)
                        root.statsWidgetX = barCapsule.x + p.x + statsW.width / 2 - 130
                        root.openDropdown = root.openDropdown === "stats" ? "" : "stats"
                    }
                }

                VolumeWidget {
                    id: volumeW
                    Layout.alignment: Qt.AlignVCenter
                    volumePercent: root.volumePercent; muted: root.volumeMuted
                    isOpen: root.openDropdown === "volume"
                    onScroll: (up) => {
                        Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", up ? "5%+" : "5%-"])
                        if (!volProc.running) volProc.running = true
                    }
                    onClicked: {
                        var p = volumeW.mapToItem(barCapsule, 0, 0)
                        root.volumeWidgetX = barCapsule.x + p.x + volumeW.width / 2 - 120
                        root.openDropdown = root.openDropdown === "volume" ? "" : "volume"
                    }
                }

                BatteryWidget {
                    id: batteryW
                    Layout.alignment: Qt.AlignVCenter
                    batteryPercent: root.batteryPercent; charging: root.batteryCharging
                    isOpen: root.openDropdown === "battery"
                    onClicked: {
                        var p = batteryW.mapToItem(barCapsule, 0, 0)
                        root.batteryWidgetX = barCapsule.x + p.x + batteryW.width / 2 - 120
                        root.openDropdown = root.openDropdown === "battery" ? "" : "battery"
                    }
                }

                ActionHub {
                    Layout.alignment: Qt.AlignVCenter
                    onLaunchKitty:    Quickshell.execDetached(["kitty"])
                    onLaunchBrowser:  Quickshell.execDetached(["zen-beta"])
                    onScreenshot:     Quickshell.execDetached(["spectacle", "-r"])
                    onLockScreen:     Quickshell.execDetached(["loginctl", "lock-session"])
                    onPowerMenu:      root.powerMenuOpen = !root.powerMenuOpen
                }
            }
        }

        // ── DROPDOWN PANELS (positioned near their widget) ───

        CalendarDropdown {
            visible: root.openDropdown === "clock"
            x: Math.max(10, Math.min(root.clockWidgetX, barWindow.width - width - 10))
            anchors { top: barCapsule.bottom; topMargin: 6 }
            z: 20
            opacity: visible ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
        }

        StatsDropdown {
            visible: root.openDropdown === "stats"
            x: Math.max(10, Math.min(root.statsWidgetX, barWindow.width - width - 10))
            anchors { top: barCapsule.bottom; topMargin: 6 }
            cpuPercent: root.cpuPercent; ramPercent: root.ramPercent; ramDetail: root.ramDetail
            z: 20
            opacity: visible ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
        }

        VolumeDropdown {
            visible: root.openDropdown === "volume"
            x: Math.max(10, Math.min(root.volumeWidgetX, barWindow.width - width - 10))
            anchors { top: barCapsule.bottom; topMargin: 6 }
            volumePercent: root.volumePercent; muted: root.volumeMuted
            onVolumeChange: (pct) => {
                Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", (pct / 100).toFixed(2)])
                if (!volProc.running) volProc.running = true
            }
            onMuteToggle: {
                Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"])
                if (!volProc.running) volProc.running = true
            }
            z: 20
            opacity: visible ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
        }

        BatteryDropdown {
            visible: root.openDropdown === "battery"
            x: Math.max(10, Math.min(root.batteryWidgetX, barWindow.width - width - 10))
            anchors { top: barCapsule.bottom; topMargin: 6 }
            batteryPercent: root.batteryPercent; charging: root.batteryCharging
            z: 20
            opacity: visible ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
        }

        // System Tray Dropdown
        TrayDropdown {
            visible: root.openDropdown === "tray"
            x: Math.max(10, Math.min(root.trayWidgetX, barWindow.width - width - 10))
            anchors { top: barCapsule.bottom; topMargin: 6 }
            z: 20
            opacity: visible ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
        }

        // Master Control Center Dropdown
        ControlCenterDropdown {
            visible: root.openDropdown === "cc"
            x: Math.max(10, Math.min(root.ccWidgetX, barWindow.width - width - 10))
            anchors { top: barCapsule.bottom; topMargin: 6 }
            volumePercent: root.volumePercent; muted: root.volumeMuted
            brightnessPercent: root.brightnessPercent
            cpuPercent: root.cpuPercent; ramPercent: root.ramPercent; ramDetail: root.ramDetail
            batteryPercent: root.batteryPercent; batteryCharging: root.batteryCharging
            netType: root.netType; netSpeed: root.netSpeed; netSSID: root.netSSID
            playerName: root.playerName; playerIcon: root.playerIcon
            trackTitle: root.trackTitle; trackArtist: root.trackArtist; isPlaying: root.isPlaying
            wifiNetworks: root.wifiNetworks
            wifiScanning: root.wifiScanning
            onVolumeChange: (pct) => {
                Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", (pct / 100).toFixed(2)])
                if (!volProc.running) volProc.running = true
            }
            onMuteToggle: {
                Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"])
                if (!volProc.running) volProc.running = true
            }
            onBrightnessChange: (pct) => {
                Quickshell.execDetached(["brightnessctl", "set", pct + "%"])
                if (!brightProc.running) brightProc.running = true
            }
            onPrevTrack:      Quickshell.execDetached(["playerctl", "previous"])
            onPlayPauseTrack: Quickshell.execDetached(["playerctl", "play-pause"])
            onNextTrack:      Quickshell.execDetached(["playerctl", "next"])
            onScanWifi:       root.scanWifi()
            onConnectWifi: (ssid) => {
                Quickshell.execDetached(["nmcli", "dev", "wifi", "connect", ssid])
            }
            onOpenPowerMenu: {
                root.openDropdown = ""
                root.powerMenuOpen = true
            }
            z: 20
            opacity: visible ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
        }
    }

    // ─────────────────────────────────────────────────────────
    // POWER MENU — full screen overlay with luxury aesthetic
    // ─────────────────────────────────────────────────────────
    PanelWindow {
        id: pwrWindow
        anchors { top: true; bottom: true; left: true; right: true }
        visible: root.powerMenuOpen
        color: "transparent"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
        WlrLayershell.exclusiveZone: 0
        WlrLayershell.namespace: "quickshell-power"

        // Dark backdrop — click to dismiss
        Rectangle {
            anchors.fill: parent
            color: "#c0000000"
            MouseArea { anchors.fill: parent; onClicked: root.powerMenuOpen = false }
        }

        // Power card (centered)
        Rectangle {
            anchors.centerIn: parent
            width: 480; height: 230
            radius: 20
            color: "#f2181825"
            border.color: "#90cba6f7"; border.width: 1.5

            // Top sheen
            Rectangle {
                anchors { top: parent.top; topMargin: 1; left: parent.left; leftMargin: 20; right: parent.right; rightMargin: 20 }
                height: 1; color: "#50ffffff"; radius: 1
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 18
                spacing: 12

                // Header
                RowLayout {
                    Layout.fillWidth: true
                    Text { text: "󰐥"; font.pixelSize: 18; color: "#cba6f7" }
                    ColumnLayout {
                        spacing: 1
                        Text { text: "電源メニュー • Power Menu"; font.pixelSize: 14; font.bold: true; font.family: "Noto Sans CJK JP"; color: "#cdd6f4" }
                        Text { text: "システム操作を選択してください"; font.pixelSize: 9; font.family: "Noto Sans CJK JP"; color: "#6c7086" }
                    }
                    Item { Layout.fillWidth: true }
                    // Close button
                    Rectangle {
                        width: 26; height: 26; radius: 13
                        color: closeMa.containsMouse ? "#30f38ba8" : "#20313244"
                        border.color: closeMa.containsMouse ? "#f38ba8" : "#3045475a"; border.width: 1
                        Text { anchors.centerIn: parent; text: "󰅖"; font.pixelSize: 12; color: "#cdd6f4" }
                        MouseArea {
                            id: closeMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                            onClicked: root.powerMenuOpen = false
                        }
                    }
                }

                // 5 Power Buttons
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Repeater {
                        model: [
                            { icon: "󰐥", label: "シャット\nダウン", sub: "Power Off",  cmd: ["systemctl", "poweroff"],   color: "#f38ba8" },
                            { icon: "󰜉", label: "再起動",       sub: "Reboot",     cmd: ["systemctl", "reboot"],      color: "#fab387" },
                            { icon: "󰤄", label: "サスペンド",   sub: "Suspend",    cmd: ["systemctl", "suspend"],      color: "#89b4fa" },
                            { icon: "󰒲", label: "休止状態",     sub: "Hibernate",  cmd: ["systemctl", "hibernate"],    color: "#cba6f7" },
                            { icon: "󰌾", label: "画面ロック",   sub: "Lock",       cmd: ["loginctl", "lock-session"], color: "#a6e3a1" }
                        ]
                        Rectangle {
                            Layout.fillWidth: true; height: 104; radius: 14
                            color: pwrBtnMa.containsMouse ? Qt.rgba(
                                parseInt(modelData.color.slice(1,3),16)/255,
                                parseInt(modelData.color.slice(3,5),16)/255,
                                parseInt(modelData.color.slice(5,7),16)/255, 0.22) : "#1c313244"
                            border.color: pwrBtnMa.containsMouse ? modelData.color : "#3045475a"
                            border.width: pwrBtnMa.containsMouse ? 2 : 1
                            Behavior on color { ColorAnimation { duration: 100 } }

                            Column {
                                anchors.centerIn: parent
                                spacing: 4
                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: modelData.icon; font.pixelSize: 26; color: modelData.color
                                }
                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: modelData.label
                                    font.pixelSize: 10; font.bold: true; font.family: "Noto Sans CJK JP"
                                    color: "#cdd6f4"; horizontalAlignment: Text.AlignHCenter
                                }
                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: modelData.sub
                                    font.pixelSize: 8; color: "#6c7086"
                                }
                            }

                            MouseArea {
                                id: pwrBtnMa; anchors.fill: parent; hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    root.powerMenuOpen = false
                                    Quickshell.execDetached(modelData.cmd)
                                }
                            }
                        }
                    }
                }

                // Cancel button
                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    width: 140; height: 28; radius: 8
                    color: cancelMa.containsMouse ? "#30cba6f7" : "#18313244"
                    border.color: cancelMa.containsMouse ? "#cba6f7" : "#3045475a"; border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: "キャンセル • Cancel"
                        font.pixelSize: 10; font.family: "Noto Sans CJK JP"; color: "#a6adc8"
                    }
                    MouseArea {
                        id: cancelMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        onClicked: root.powerMenuOpen = false
                    }
                }
            }
        }
    }
}
