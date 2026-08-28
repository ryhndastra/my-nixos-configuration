import QtQuick
import QtQuick.Layouts
import Quickshell

// Noctalia Master Control Center — sidebar-tabbed with Home / WiFi / Audio pages
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
    property string playerName:        ""
    property string playerIcon:        "󰎆"
    property string trackTitle:        ""
    property string trackArtist:       ""
    property bool   isPlaying:         false
    property bool   wifiEnabled:       true
    property bool   dndEnabled:        false

    // WiFi scanning
    property var    wifiNetworks:      []
    property bool   wifiScanning:      false

    signal volumeChange(int pct)
    signal muteToggle()
    signal brightnessChange(int pct)
    signal prevTrack()
    signal playPauseTrack()
    signal nextTrack()
    signal openPowerMenu()
    signal scanWifi()
    signal connectWifi(string ssid)

    // Active page: "home" | "wifi" | "audio"
    property string activePage: "home"

    implicitWidth: 380
    implicitHeight: 480

    Rectangle {
        anchors.fill: parent
        radius: 16
        color: "#e8181825"
        border.color: "#90cba6f7"
        border.width: 1.5

        Rectangle {
            anchors { top: parent.top; topMargin: 1; left: parent.left; leftMargin: 18; right: parent.right; rightMargin: 18 }
            height: 1; color: "#45ffffff"; radius: 1
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 0
            spacing: 0

            // ── Sidebar Navigation ──────────────────────────
            Rectangle {
                Layout.preferredWidth: 44
                Layout.fillHeight: true
                radius: 16
                color: "#10181825"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.topMargin: 14
                    anchors.bottomMargin: 14
                    spacing: 6

                    Repeater {
                        model: [
                            { icon: "󰊠", page: "home",  tip: "ホーム" },
                            { icon: "󰤨", page: "wifi",  tip: "WiFi"  },
                            { icon: "󰕾", page: "audio", tip: "音量"  }
                        ]
                        Rectangle {
                            Layout.alignment: Qt.AlignHCenter
                            width: 32; height: 32; radius: 8
                            color: root.activePage === modelData.page ? "#35cba6f7"
                                 : sbMa.containsMouse ? "#25313244" : "transparent"
                            border.color: root.activePage === modelData.page ? "#cba6f7" : "transparent"
                            border.width: 1
                            Behavior on color { ColorAnimation { duration: 100 } }

                            Text {
                                anchors.centerIn: parent
                                text: modelData.icon
                                font.pixelSize: 14
                                color: root.activePage === modelData.page ? "#cba6f7" : "#7f849c"
                            }

                            MouseArea {
                                id: sbMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                                onClicked: root.activePage = modelData.page
                            }
                        }
                    }

                    Item { Layout.fillHeight: true }

                    // Power button at bottom
                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        width: 32; height: 32; radius: 8
                        color: pwrSbMa.containsMouse ? "#30f38ba8" : "transparent"
                        Text { anchors.centerIn: parent; text: "󰐥"; font.pixelSize: 14; color: "#f38ba8" }
                        MouseArea {
                            id: pwrSbMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                            onClicked: root.openPowerMenu()
                        }
                    }
                }
            }

            // Vertical divider
            Rectangle { Layout.preferredWidth: 1; Layout.fillHeight: true; Layout.topMargin: 10; Layout.bottomMargin: 10; color: "#20cba6f7" }

            // ── Page Content ────────────────────────────────
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                // === HOME PAGE ===
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 8
                    visible: root.activePage === "home"

                    // Header
                    RowLayout {
                        spacing: 8
                        Rectangle {
                            width: 34; height: 34; radius: 17
                            color: "#28cba6f7"
                            border.color: "#80cba6f7"; border.width: 1.2
                            Text { anchors.centerIn: parent; text: "󰀄"; font.pixelSize: 16; color: "#cba6f7" }
                            MouseArea {
                                anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                                onClicked: Quickshell.execDetached(["systemsettings", "kcm_users"])
                            }
                        }
                        ColumnLayout {
                            spacing: 1
                            Text { text: "sho @ nixos"; font.pixelSize: 12; font.bold: true; font.family: "JetBrainsMono Nerd Font"; color: "#cdd6f4" }
                            Text { text: "コントロールセンター"; font.pixelSize: 9; font.family: "Noto Sans CJK JP"; color: "#6c7086" }
                        }
                        Item { Layout.fillWidth: true }
                    }

                    // Toggles
                    RowLayout {
                        Layout.fillWidth: true; spacing: 6
                        Rectangle {
                            Layout.fillWidth: true; height: 36; radius: 8
                            color: root.netType !== "none" ? "#2889b4fa" : "#18313244"
                            border.color: root.netType !== "none" ? "#89b4fa" : "#3045475a"; border.width: 1
                            RowLayout { anchors.centerIn: parent; spacing: 4
                                Text { text: root.netType === "wifi" ? "󰤨" : "󰈀"; font.pixelSize: 12; color: root.netType !== "none" ? "#89b4fa" : "#6c7086" }
                                Text { text: root.netSSID !== "" ? root.netSSID : (root.netType === "ethernet" ? "有線" : "OFF"); font.pixelSize: 9; font.bold: true; font.family: "Noto Sans CJK JP"; color: "#cdd6f4" }
                            }
                            MouseArea { anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.activePage = "wifi" }
                        }
                        Rectangle {
                            Layout.fillWidth: true; height: 36; radius: 8
                            color: root.dndEnabled ? "#28f38ba8" : "#18313244"
                            border.color: root.dndEnabled ? "#f38ba8" : "#3045475a"; border.width: 1
                            RowLayout { anchors.centerIn: parent; spacing: 4
                                Text { text: root.dndEnabled ? "󰂛" : "󰂚"; font.pixelSize: 12; color: root.dndEnabled ? "#f38ba8" : "#a6adc8" }
                                Text { text: root.dndEnabled ? "静音" : "通知"; font.pixelSize: 9; font.bold: true; font.family: "Noto Sans CJK JP"; color: "#cdd6f4" }
                            }
                            MouseArea { anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.dndEnabled = !root.dndEnabled }
                        }
                    }

                    // Volume slider
                    Rectangle {
                        Layout.fillWidth: true; height: 46; radius: 8; color: "#14313244"; border.color: "#20fab387"; border.width: 1
                        ColumnLayout { anchors.fill: parent; anchors.margins: 8; spacing: 3
                            RowLayout {
                                Text { text: root.muted ? "󰖁" : "󰕾"; font.pixelSize: 11; color: root.muted ? "#f38ba8" : "#fab387" }
                                Text { text: "音量"; font.pixelSize: 9; font.family: "Noto Sans CJK JP"; color: "#a6adc8" }
                                Item { Layout.fillWidth: true }
                                Text { text: root.muted ? "消音" : root.volumePercent + "%"; font.pixelSize: 10; font.bold: true; font.family: "JetBrainsMono Nerd Font"; color: root.muted ? "#f38ba8" : "#fab387" }
                            }
                            Item { id: vt; Layout.fillWidth: true; height: 8
                                Rectangle { anchors.fill: parent; radius: 4; color: "#2545475a" }
                                Rectangle { width: Math.max(6, vt.width * Math.min(root.volumePercent / 100, 1)); height: parent.height; radius: 4; color: root.muted ? "#80f38ba8" : "#fab387" }
                                MouseArea { anchors.fill: parent; cursorShape: Qt.SizeHorCursor
                                    onPositionChanged: (m) => { if (m.buttons & Qt.LeftButton) root.volumeChange(Math.round(Math.max(0, Math.min(100, m.x / vt.width * 100)))) }
                                    onPressed: (m) => root.volumeChange(Math.round(Math.max(0, Math.min(100, m.x / vt.width * 100))))
                                }
                            }
                        }
                    }

                    // Brightness slider
                    Rectangle {
                        Layout.fillWidth: true; height: 46; radius: 8; color: "#14313244"; border.color: "#20f9e2af"; border.width: 1
                        ColumnLayout { anchors.fill: parent; anchors.margins: 8; spacing: 3
                            RowLayout {
                                Text { text: "󰃠"; font.pixelSize: 11; color: "#f9e2af" }
                                Text { text: "画面輝度"; font.pixelSize: 9; font.family: "Noto Sans CJK JP"; color: "#a6adc8" }
                                Item { Layout.fillWidth: true }
                                Text { text: root.brightnessPercent + "%"; font.pixelSize: 10; font.bold: true; font.family: "JetBrainsMono Nerd Font"; color: "#f9e2af" }
                            }
                            Item { id: bt; Layout.fillWidth: true; height: 8
                                Rectangle { anchors.fill: parent; radius: 4; color: "#2545475a" }
                                Rectangle { width: Math.max(6, bt.width * Math.min(root.brightnessPercent / 100, 1)); height: parent.height; radius: 4; color: "#f9e2af" }
                                MouseArea { anchors.fill: parent; cursorShape: Qt.SizeHorCursor
                                    onPositionChanged: (m) => { if (m.buttons & Qt.LeftButton) root.brightnessChange(Math.round(Math.max(5, Math.min(100, m.x / bt.width * 100)))) }
                                    onPressed: (m) => root.brightnessChange(Math.round(Math.max(5, Math.min(100, m.x / bt.width * 100))))
                                }
                            }
                        }
                    }

                    // Media card
                    Rectangle {
                        Layout.fillWidth: true; height: 50; radius: 8
                        color: root.playerName !== "" ? "#1ca6e3a1" : "#14313244"
                        border.color: root.playerName !== "" ? "#50a6e3a1" : "#2045475a"; border.width: 1
                        RowLayout { anchors.fill: parent; anchors.margins: 8; spacing: 6
                            Text { text: root.playerIcon; font.pixelSize: 18; color: "#a6e3a1" }
                            ColumnLayout { Layout.fillWidth: true; spacing: 0
                                Text { text: root.trackTitle !== "" ? root.trackTitle : "再生中の曲なし"; font.pixelSize: 10; font.bold: true; color: "#cdd6f4"; elide: Text.ElideRight; Layout.fillWidth: true }
                                Text { text: root.trackArtist !== "" ? root.trackArtist : "No media"; font.pixelSize: 8; color: "#7f849c"; elide: Text.ElideRight; Layout.fillWidth: true }
                            }
                            RowLayout { spacing: 4; visible: root.playerName !== ""
                                Text { text: "󰒮"; font.pixelSize: 12; color: "#a6adc8"; MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.prevTrack() } }
                                Text { text: root.isPlaying ? "󰏤" : "󰐊"; font.pixelSize: 14; color: "#a6e3a1"; MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.playPauseTrack() } }
                                Text { text: "󰒭"; font.pixelSize: 12; color: "#a6adc8"; MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.nextTrack() } }
                            }
                        }
                    }

                    // Hardware metrics
                    RowLayout { Layout.fillWidth: true; spacing: 5
                        Repeater {
                            model: [
                                { icon: "󰻠", label: "CPU", value: root.cpuPercent + "%", color: root.cpuPercent > 80 ? "#f38ba8" : "#89b4fa" },
                                { icon: "󰍛", label: "RAM", value: root.ramPercent + "%", color: "#89dceb" },
                                { icon: root.batteryCharging ? "󰂄" : "󰁹", label: "BAT", value: root.batteryPercent + "%", color: "#a6e3a1" },
                                { icon: "󰛳", label: "NET", value: root.netSpeed, color: "#cba6f7" }
                            ]
                            Rectangle {
                                Layout.fillWidth: true; height: 38; radius: 6; color: "#14313244"
                                Column { anchors.centerIn: parent; spacing: 0
                                    Text { text: modelData.icon + " " + modelData.label; font.pixelSize: 8; color: modelData.color; anchors.horizontalCenter: parent.horizontalCenter }
                                    Text { text: modelData.value; font.pixelSize: 10; font.bold: true; font.family: "JetBrainsMono Nerd Font"; color: "#cdd6f4"; anchors.horizontalCenter: parent.horizontalCenter }
                                }
                            }
                        }
                    }

                    // Power profiles
                    RowLayout { Layout.fillWidth: true; spacing: 5
                        Repeater {
                            model: [
                                { icon: "󰌪", label: "省電力", profile: "power-saver" },
                                { icon: "󰾅", label: "バランス", profile: "balanced" },
                                { icon: "󰓅", label: "性能", profile: "performance" }
                            ]
                            Rectangle {
                                Layout.fillWidth: true; height: 24; radius: 5
                                color: pfMa.containsMouse ? "#25cba6f7" : "#14313244"
                                border.color: pfMa.containsMouse ? "#cba6f7" : "transparent"; border.width: 1
                                Row { anchors.centerIn: parent; spacing: 3
                                    Text { text: modelData.icon; font.pixelSize: 9; color: "#cba6f7"; anchors.verticalCenter: parent.verticalCenter }
                                    Text { text: modelData.label; font.pixelSize: 8; font.family: "Noto Sans CJK JP"; color: "#cdd6f4"; anchors.verticalCenter: parent.verticalCenter }
                                }
                                MouseArea { id: pfMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                                    onClicked: Quickshell.execDetached(["powerprofilesctl", "set", modelData.profile]) }
                            }
                        }
                    }
                }

                // === WIFI PAGE ===
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 8
                    visible: root.activePage === "wifi"

                    // Header
                    RowLayout {
                        Text { text: "󰤨"; font.pixelSize: 16; color: "#89b4fa" }
                        ColumnLayout { spacing: 1
                            Text { text: "ネットワーク"; font.pixelSize: 12; font.bold: true; font.family: "Noto Sans CJK JP"; color: "#cdd6f4" }
                            Text { text: "WiFi Networks"; font.pixelSize: 8; color: "#585b70" }
                        }
                        Item { Layout.fillWidth: true }
                        // Scan button
                        Rectangle {
                            width: 60; height: 24; radius: 6
                            color: scanMa.containsMouse ? "#3089b4fa" : "#18313244"
                            border.color: scanMa.containsMouse ? "#89b4fa" : "#3045475a"; border.width: 1
                            Row { anchors.centerIn: parent; spacing: 3
                                Text { text: root.wifiScanning ? "󰑓" : "󰑐"; font.pixelSize: 10; color: "#89b4fa"; anchors.verticalCenter: parent.verticalCenter }
                                Text { text: "スキャン"; font.pixelSize: 8; font.family: "Noto Sans CJK JP"; color: "#cdd6f4"; anchors.verticalCenter: parent.verticalCenter }
                            }
                            MouseArea { id: scanMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                                onClicked: root.scanWifi() }
                        }
                    }

                    // Current connection
                    Rectangle {
                        Layout.fillWidth: true; height: 38; radius: 8
                        color: "#2089b4fa"
                        border.color: "#89b4fa"; border.width: 1
                        RowLayout { anchors.fill: parent; anchors.margins: 8; spacing: 6
                            Text { text: root.netType === "wifi" ? "󰤨" : "󰈀"; font.pixelSize: 14; color: "#89b4fa" }
                            ColumnLayout { Layout.fillWidth: true; spacing: 0
                                Text { text: root.netSSID !== "" ? root.netSSID : (root.netType === "ethernet" ? "有線LAN 接続中" : "未接続"); font.pixelSize: 10; font.bold: true; color: "#cdd6f4" }
                                Text { text: root.netSpeed + " • " + root.netType; font.pixelSize: 8; color: "#7f849c" }
                            }
                            Text { text: "接続中"; font.pixelSize: 8; font.family: "Noto Sans CJK JP"; color: "#89b4fa" }
                        }
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: "#20cba6f7" }

                    // WiFi list
                    Text {
                        visible: root.wifiNetworks.length === 0 && !root.wifiScanning
                        text: "「スキャン」を押してWiFiを検索"
                        font.pixelSize: 10; font.family: "Noto Sans CJK JP"; color: "#585b70"
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text {
                        visible: root.wifiScanning
                        text: "スキャン中..."
                        font.pixelSize: 10; font.family: "Noto Sans CJK JP"; color: "#89b4fa"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Flickable {
                        Layout.fillWidth: true; Layout.fillHeight: true
                        clip: true
                        contentHeight: wifiCol.implicitHeight
                        ColumnLayout {
                            id: wifiCol
                            width: parent.width
                            spacing: 4

                            Repeater {
                                model: root.wifiNetworks
                                Rectangle {
                                    Layout.fillWidth: true; height: 36; radius: 6
                                    color: wfMa.containsMouse ? "#2589b4fa" : "#14313244"
                                    border.color: modelData.active ? "#89b4fa" : (wfMa.containsMouse ? "#89b4fa" : "#2045475a")
                                    border.width: modelData.active ? 1.5 : 1

                                    RowLayout {
                                        anchors.fill: parent; anchors.margins: 8; spacing: 6
                                        // Signal strength icon
                                        Text {
                                            text: modelData.signal >= 80 ? "󰤨" : modelData.signal >= 60 ? "󰤥" : modelData.signal >= 40 ? "󰤢" : "󰤟"
                                            font.pixelSize: 12; color: modelData.active ? "#a6e3a1" : "#89b4fa"
                                        }
                                        ColumnLayout { Layout.fillWidth: true; spacing: 0
                                            Text { text: modelData.ssid; font.pixelSize: 10; font.bold: true; color: "#cdd6f4" }
                                            Text { text: (modelData.security !== "" ? "󰌾 " + modelData.security : "󰌿 Open") + " • " + modelData.signal + "%"; font.pixelSize: 8; color: "#7f849c" }
                                        }
                                        // Connect button (if not active)
                                        Rectangle {
                                            visible: !modelData.active
                                            width: 46; height: 20; radius: 5
                                            color: conMa.containsMouse ? "#3089b4fa" : "#18313244"
                                            border.color: conMa.containsMouse ? "#89b4fa" : "#3045475a"; border.width: 1
                                            Text { anchors.centerIn: parent; text: "接続"; font.pixelSize: 8; font.family: "Noto Sans CJK JP"; color: "#89b4fa" }
                                            MouseArea { id: conMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                                                onClicked: root.connectWifi(modelData.ssid) }
                                        }
                                        // Connected indicator
                                        Text {
                                            visible: modelData.active
                                            text: "󰄬"; font.pixelSize: 12; color: "#a6e3a1"
                                        }
                                    }

                                    MouseArea { id: wfMa; anchors.fill: parent; hoverEnabled: true; z: -1 }
                                }
                            }
                        }
                    }
                }

                // === AUDIO PAGE ===
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 10
                    visible: root.activePage === "audio"

                    // Header
                    RowLayout {
                        Text { text: "󰕾"; font.pixelSize: 16; color: "#fab387" }
                        ColumnLayout { spacing: 1
                            Text { text: "オーディオ設定"; font.pixelSize: 12; font.bold: true; font.family: "Noto Sans CJK JP"; color: "#cdd6f4" }
                            Text { text: "Audio Settings"; font.pixelSize: 8; color: "#585b70" }
                        }
                    }

                    // Big volume display
                    Rectangle {
                        Layout.fillWidth: true; height: 80; radius: 12
                        color: "#18313244"; border.color: "#25fab387"; border.width: 1
                        ColumnLayout {
                            anchors.centerIn: parent; spacing: 4
                            Text { text: root.muted ? "󰖁" : "󰕾"; font.pixelSize: 28; color: root.muted ? "#f38ba8" : "#fab387"; Layout.alignment: Qt.AlignHCenter }
                            Text { text: root.muted ? "ミュート中" : root.volumePercent + "%"; font.pixelSize: 18; font.bold: true; font.family: "JetBrainsMono Nerd Font"; color: root.muted ? "#f38ba8" : "#fab387"; Layout.alignment: Qt.AlignHCenter }
                        }
                    }

                    // Volume slider (big)
                    Item { id: avt; Layout.fillWidth: true; height: 14
                        Rectangle { anchors.fill: parent; radius: 7; color: "#2545475a" }
                        Rectangle { width: Math.max(10, avt.width * Math.min(root.volumePercent / 100, 1)); height: parent.height; radius: 7; color: root.muted ? "#80f38ba8" : "#fab387"
                            Rectangle { anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter; width: 16; height: 16; radius: 8; color: "#fff"; border.color: root.muted ? "#f38ba8" : "#fab387"; border.width: 2 }
                        }
                        MouseArea { anchors.fill: parent; cursorShape: Qt.SizeHorCursor
                            onPositionChanged: (m) => { if (m.buttons & Qt.LeftButton) root.volumeChange(Math.round(Math.max(0, Math.min(100, m.x / avt.width * 100)))) }
                            onPressed: (m) => root.volumeChange(Math.round(Math.max(0, Math.min(100, m.x / avt.width * 100))))
                        }
                    }

                    // Mute toggle
                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter; width: 120; height: 28; radius: 8
                        color: muteMa2.containsMouse ? "#30f38ba8" : "#18313244"
                        border.color: root.muted ? "#f38ba8" : "#3045475a"; border.width: 1
                        Text { anchors.centerIn: parent; text: root.muted ? "󰕾 ミュート解除" : "󰖁 ミュート"; font.pixelSize: 10; font.family: "Noto Sans CJK JP"; color: root.muted ? "#f38ba8" : "#7f849c" }
                        MouseArea { id: muteMa2; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.muteToggle() }
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: "#20fab387" }

                    // Brightness
                    ColumnLayout { spacing: 4
                        RowLayout {
                            Text { text: "󰃠"; font.pixelSize: 12; color: "#f9e2af" }
                            Text { text: "画面輝度 / Brightness"; font.pixelSize: 10; font.family: "Noto Sans CJK JP"; color: "#a6adc8" }
                            Item { Layout.fillWidth: true }
                            Text { text: root.brightnessPercent + "%"; font.pixelSize: 10; font.bold: true; font.family: "JetBrainsMono Nerd Font"; color: "#f9e2af" }
                        }
                        Item { id: abt; Layout.fillWidth: true; height: 10
                            Rectangle { anchors.fill: parent; radius: 5; color: "#2545475a" }
                            Rectangle { width: Math.max(8, abt.width * Math.min(root.brightnessPercent / 100, 1)); height: parent.height; radius: 5; color: "#f9e2af" }
                            MouseArea { anchors.fill: parent; cursorShape: Qt.SizeHorCursor
                                onPositionChanged: (m) => { if (m.buttons & Qt.LeftButton) root.brightnessChange(Math.round(Math.max(5, Math.min(100, m.x / abt.width * 100)))) }
                                onPressed: (m) => root.brightnessChange(Math.round(Math.max(5, Math.min(100, m.x / abt.width * 100))))
                            }
                        }
                    }

                    // Now playing card
                    Rectangle {
                        Layout.fillWidth: true; height: 52; radius: 8
                        color: root.playerName !== "" ? "#1ca6e3a1" : "#14313244"
                        border.color: root.playerName !== "" ? "#50a6e3a1" : "#2045475a"; border.width: 1
                        RowLayout { anchors.fill: parent; anchors.margins: 8; spacing: 6
                            Text { text: root.playerIcon; font.pixelSize: 20; color: "#a6e3a1" }
                            ColumnLayout { Layout.fillWidth: true; spacing: 0
                                Text { text: root.trackTitle !== "" ? root.trackTitle : "再生停止中"; font.pixelSize: 10; font.bold: true; color: "#cdd6f4"; elide: Text.ElideRight; Layout.fillWidth: true }
                                Text { text: root.trackArtist !== "" ? root.trackArtist : "No media playing"; font.pixelSize: 8; color: "#7f849c"; elide: Text.ElideRight; Layout.fillWidth: true }
                            }
                            RowLayout { spacing: 4; visible: root.playerName !== ""
                                Text { text: "󰒮"; font.pixelSize: 12; color: "#a6adc8"; MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.prevTrack() } }
                                Text { text: root.isPlaying ? "󰏤" : "󰐊"; font.pixelSize: 14; color: "#a6e3a1"; MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.playPauseTrack() } }
                                Text { text: "󰒭"; font.pixelSize: 12; color: "#a6adc8"; MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.nextTrack() } }
                            }
                        }
                    }
                }
            }
        }
    }
}
