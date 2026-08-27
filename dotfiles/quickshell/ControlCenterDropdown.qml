import QtQuick
import QtQuick.Layouts
import Quickshell

// Noctalia / Niri-style Master Control Center Dropdown
Item {
    id: root
    property int    volumePercent:     80
    property bool   muted:             false
    property int    brightnessPercent: 100
    property int    cpuPercent:        0
    property int    ramPercent:        0
    property string ramDetail:         "--"
    property int    batteryPercent:    85
    property bool   batteryCharging:   false
    property string netType:           "ethernet"
    property string netSpeed:          "0 KB/s"
    property string netSSID:           ""

    // MPRIS
    property string playerName:  ""
    property string playerIcon:  "󰎆"
    property string trackTitle:  ""
    property string trackArtist: ""
    property bool   isPlaying:   false

    // Quick toggles state
    property bool wifiEnabled: true
    property bool dndEnabled: false

    signal volumeChange(int pct)
    signal muteToggle()
    signal brightnessChange(int pct)
    signal prevTrack()
    signal playPauseTrack()
    signal nextTrack()
    signal openPowerMenu()

    implicitWidth: 360
    implicitHeight: 460

    Rectangle {
        anchors.fill: parent
        radius: 16
        color: "#f5181825"
        border.color: "#90cba6f7"
        border.width: 1.5

        // Top specular glass sheen
        Rectangle {
            anchors { top: parent.top; topMargin: 1; left: parent.left; leftMargin: 18; right: parent.right; rightMargin: 18 }
            height: 1; color: "#45ffffff"; radius: 1
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 10

            // ── Header: User profile & Power ─────────────────
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Rectangle {
                    width: 38; height: 38; radius: 19
                    color: "#28cba6f7"
                    border.color: "#80cba6f7"; border.width: 1.2
                    Text {
                        anchors.centerIn: parent
                        text: "🌸"
                        font.pixelSize: 18
                    }
                }

                ColumnLayout {
                    spacing: 1
                    Text {
                        text: "sho @ nixos"
                        font.pixelSize: 13
                        font.bold: true
                        font.family: "JetBrainsMono Nerd Font"
                        color: "#cdd6f4"
                    }
                    Text {
                        text: "コントロールセンター • Control Hub"
                        font.pixelSize: 9
                        font.family: "Noto Sans CJK JP"
                        color: "#6c7086"
                    }
                }

                Item { Layout.fillWidth: true }

                // Quick Power Button
                Rectangle {
                    width: 28; height: 28; radius: 8
                    color: pwrMa.containsMouse ? "#40f38ba8" : "#20313244"
                    border.color: pwrMa.containsMouse ? "#f38ba8" : "#3545475a"; border.width: 1
                    Text { anchors.centerIn: parent; text: "󰐥"; font.pixelSize: 13; color: "#f38ba8" }
                    MouseArea {
                        id: pwrMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        onClicked: root.openPowerMenu()
                    }
                }
            }

            // ── Fast Toggles Grid ────────────────────────────
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                // Wi-Fi / Net toggle
                Rectangle {
                    Layout.fillWidth: true; height: 38; radius: 10
                    color: root.netType !== "none" ? "#3089b4fa" : "#18313244"
                    border.color: root.netType !== "none" ? "#89b4fa" : "#3045475a"; border.width: 1
                    RowLayout {
                        anchors.centerIn: parent; spacing: 6
                        Text { text: root.netType === "wifi" ? "󰤨" : "󰈀"; font.pixelSize: 14; color: root.netType !== "none" ? "#89b4fa" : "#6c7086" }
                        Text { text: root.netSSID !== "" ? root.netSSID : (root.netType === "ethernet" ? "有線LAN" : "オフライン"); font.pixelSize: 10; font.bold: true; font.family: "Noto Sans CJK JP"; color: "#cdd6f4" }
                    }
                }

                // DND / Notification toggle
                Rectangle {
                    Layout.fillWidth: true; height: 38; radius: 10
                    color: root.dndEnabled ? "#30f38ba8" : "#18313244"
                    border.color: root.dndEnabled ? "#f38ba8" : "#3045475a"; border.width: 1
                    RowLayout {
                        anchors.centerIn: parent; spacing: 6
                        Text { text: root.dndEnabled ? "󰂛" : "󰂚"; font.pixelSize: 14; color: root.dndEnabled ? "#f38ba8" : "#a6adc8" }
                        Text { text: root.dndEnabled ? "サイレント" : "通知オン"; font.pixelSize: 10; font.bold: true; font.family: "Noto Sans CJK JP"; color: "#cdd6f4" }
                    }
                    MouseArea {
                        anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        onClicked: root.dndEnabled = !root.dndEnabled
                    }
                }
            }

            // ── Volume Slider Card ───────────────────────────
            Rectangle {
                Layout.fillWidth: true; height: 50; radius: 10
                color: "#18313244"; border.color: "#25fab387"; border.width: 1

                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 8; spacing: 4

                    RowLayout {
                        Text { text: root.muted ? "󰖁" : "󰕾"; font.pixelSize: 12; color: root.muted ? "#f38ba8" : "#fab387" }
                        Text { text: "音量 / Volume"; font.pixelSize: 10; font.family: "Noto Sans CJK JP"; color: "#a6adc8" }
                        Item { Layout.fillWidth: true }
                        Text { text: root.muted ? "消音" : root.volumePercent + "%"; font.pixelSize: 10; font.bold: true; font.family: "JetBrainsMono Nerd Font"; color: root.muted ? "#f38ba8" : "#fab387" }
                    }

                    // Track
                    Item {
                        id: volTrack
                        Layout.fillWidth: true; height: 10
                        Rectangle { anchors.fill: parent; radius: 5; color: "#2545475a" }
                        Rectangle {
                            width: Math.max(8, volTrack.width * Math.min(root.volumePercent / 100, 1))
                            height: parent.height; radius: 5
                            color: root.muted ? "#80f38ba8" : "#fab387"
                        }
                        MouseArea {
                            anchors.fill: parent; cursorShape: Qt.SizeHorCursor
                            onPositionChanged: (mouse) => {
                                if (mouse.buttons & Qt.LeftButton) {
                                    var pct = Math.round(Math.max(0, Math.min(100, mouse.x / volTrack.width * 100)))
                                    root.volumeChange(pct)
                                }
                            }
                            onPressed: (mouse) => {
                                var pct = Math.round(Math.max(0, Math.min(100, mouse.x / volTrack.width * 100)))
                                root.volumeChange(pct)
                            }
                        }
                    }
                }
            }

            // ── Brightness Slider Card ───────────────────────
            Rectangle {
                Layout.fillWidth: true; height: 50; radius: 10
                color: "#18313244"; border.color: "#25f9e2af"; border.width: 1

                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 8; spacing: 4

                    RowLayout {
                        Text { text: "󰃠"; font.pixelSize: 12; color: "#f9e2af" }
                        Text { text: "画面輝度 / Brightness"; font.pixelSize: 10; font.family: "Noto Sans CJK JP"; color: "#a6adc8" }
                        Item { Layout.fillWidth: true }
                        Text { text: root.brightnessPercent + "%"; font.pixelSize: 10; font.bold: true; font.family: "JetBrainsMono Nerd Font"; color: "#f9e2af" }
                    }

                    // Track
                    Item {
                        id: brightTrack
                        Layout.fillWidth: true; height: 10
                        Rectangle { anchors.fill: parent; radius: 5; color: "#2545475a" }
                        Rectangle {
                            width: Math.max(8, brightTrack.width * Math.min(root.brightnessPercent / 100, 1))
                            height: parent.height; radius: 5
                            color: "#f9e2af"
                        }
                        MouseArea {
                            anchors.fill: parent; cursorShape: Qt.SizeHorCursor
                            onPositionChanged: (mouse) => {
                                if (mouse.buttons & Qt.LeftButton) {
                                    var pct = Math.round(Math.max(5, Math.min(100, mouse.x / brightTrack.width * 100)))
                                    root.brightnessChange(pct)
                                }
                            }
                            onPressed: (mouse) => {
                                var pct = Math.round(Math.max(5, Math.min(100, mouse.x / brightTrack.width * 100)))
                                root.brightnessChange(pct)
                            }
                        }
                    }
                }
            }

            // ── Media Playback Card ──────────────────────────
            Rectangle {
                Layout.fillWidth: true; height: 54; radius: 10
                color: root.playerName !== "" ? "#20a6e3a1" : "#14313244"
                border.color: root.playerName !== "" ? "#60a6e3a1" : "#2045475a"; border.width: 1

                RowLayout {
                    anchors.fill: parent; anchors.margins: 8; spacing: 8

                    Text { text: root.playerIcon; font.pixelSize: 22; color: "#a6e3a1" }

                    ColumnLayout {
                        Layout.fillWidth: true; spacing: 1
                        Text {
                            text: root.trackTitle !== "" ? root.trackTitle : "メディア停止中 (No media)"
                            font.pixelSize: 11; font.bold: true; color: "#cdd6f4"
                            elide: Text.ElideRight; Layout.fillWidth: true
                        }
                        Text {
                            text: root.trackArtist !== "" ? root.trackArtist : "再生中の曲はありません"
                            font.pixelSize: 9; color: "#7f849c"
                            elide: Text.ElideRight; Layout.fillWidth: true
                        }
                    }

                    // Media Buttons
                    RowLayout {
                        spacing: 4
                        visible: root.playerName !== ""
                        Text {
                            text: "󰒮"; font.pixelSize: 13; color: "#a6adc8"
                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.prevTrack() }
                        }
                        Text {
                            text: root.isPlaying ? "󰏤" : "󰐊"; font.pixelSize: 16; color: "#a6e3a1"
                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.playPauseTrack() }
                        }
                        Text {
                            text: "󰒭"; font.pixelSize: 13; color: "#a6adc8"
                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.nextTrack() }
                        }
                    }
                }
            }

            // ── Hardware Metrics Mini-Grid ───────────────────
            RowLayout {
                Layout.fillWidth: true; spacing: 6

                // CPU
                Rectangle {
                    Layout.fillWidth: true; height: 42; radius: 8; color: "#18313244"
                    Column {
                        anchors.centerIn: parent; spacing: 1
                        Text { text: "󰻠 CPU"; font.pixelSize: 9; color: "#89b4fa"; anchors.horizontalCenter: parent.horizontalCenter }
                        Text { text: root.cpuPercent + "%"; font.pixelSize: 11; font.bold: true; font.family: "JetBrainsMono Nerd Font"; color: "#cdd6f4"; anchors.horizontalCenter: parent.horizontalCenter }
                    }
                }

                // RAM
                Rectangle {
                    Layout.fillWidth: true; height: 42; radius: 8; color: "#18313244"
                    Column {
                        anchors.centerIn: parent; spacing: 1
                        Text { text: "󰍛 RAM"; font.pixelSize: 9; color: "#89dceb"; anchors.horizontalCenter: parent.horizontalCenter }
                        Text { text: root.ramPercent + "%"; font.pixelSize: 11; font.bold: true; font.family: "JetBrainsMono Nerd Font"; color: "#cdd6f4"; anchors.horizontalCenter: parent.horizontalCenter }
                    }
                }

                // Battery
                Rectangle {
                    Layout.fillWidth: true; height: 42; radius: 8; color: "#18313244"
                    Column {
                        anchors.centerIn: parent; spacing: 1
                        Text { text: root.batteryCharging ? "󰂄 BAT" : "󰁹 BAT"; font.pixelSize: 9; color: "#a6e3a1"; anchors.horizontalCenter: parent.horizontalCenter }
                        Text { text: root.batteryPercent + "%"; font.pixelSize: 11; font.bold: true; font.family: "JetBrainsMono Nerd Font"; color: "#cdd6f4"; anchors.horizontalCenter: parent.horizontalCenter }
                    }
                }

                // Net Speed
                Rectangle {
                    Layout.fillWidth: true; height: 42; radius: 8; color: "#18313244"
                    Column {
                        anchors.centerIn: parent; spacing: 1
                        Text { text: "󰛳 速度"; font.pixelSize: 9; font.family: "Noto Sans CJK JP"; color: "#cba6f7"; anchors.horizontalCenter: parent.horizontalCenter }
                        Text { text: root.netSpeed; font.pixelSize: 10; font.bold: true; font.family: "JetBrainsMono Nerd Font"; color: "#cdd6f4"; anchors.horizontalCenter: parent.horizontalCenter }
                    }
                }
            }

            // ── Power Profile Selector ───────────────────────
            RowLayout {
                Layout.fillWidth: true; spacing: 6
                Repeater {
                    model: [
                        { icon: "󰌪", label: "省電力", profile: "power-saver" },
                        { icon: "⚖", label: "バランス", profile: "balanced" },
                        { icon: "⚡", label: "パフォーマンス", profile: "performance" }
                    ]
                    Rectangle {
                        Layout.fillWidth: true; height: 26; radius: 6
                        color: pfMa.containsMouse ? "#30cba6f7" : "#18313244"
                        border.color: pfMa.containsMouse ? "#cba6f7" : "#2045475a"; border.width: 1
                        Row {
                            anchors.centerIn: parent; spacing: 4
                            Text { text: modelData.icon; font.pixelSize: 10; color: "#cba6f7"; anchors.verticalCenter: parent.verticalCenter }
                            Text { text: modelData.label; font.pixelSize: 9; font.family: "Noto Sans CJK JP"; color: "#cdd6f4"; anchors.verticalCenter: parent.verticalCenter }
                        }
                        MouseArea {
                            id: pfMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                            onClicked: Quickshell.execDetached(["powerprofilesctl", "set", modelData.profile])
                        }
                    }
                }
            }
        }
    }
}
