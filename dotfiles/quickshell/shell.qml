import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Services.Mpris
import Quickshell.Services.Pipewire
import Quickshell.Io

ShellRoot {
    // Top Floating Glass Island Bar
    PanelWindow {
        id: topBar
        anchors {
            top: true
            left: true
            right: true
        }
        height: 46
        color: "transparent"

        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        WlrLayershell.namespace: "quickshell-bar"

        // Center Floating Frosted Glass Capsule
        Rectangle {
            id: barCapsule
            anchors {
                top: parent.top
                topMargin: 5
                bottom: parent.bottom
                bottomMargin: 3
                left: parent.left
                leftMargin: 12
                right: parent.right
                rightMargin: 12
            }
            radius: 13

            // Deep Frosted Glass Acrylic Gradient
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#e61e1e2e" } // 90% Catppuccin Base
                GradientStop { position: 1.0; color: "#d911111b" } // 85% Catppuccin Crust
            }
            border.color: "#80cba6f7" // Glowing Sakura Lavender Border
            border.width: 1.2

            // Top Glass Specular Highlight Sheen
            Rectangle {
                anchors {
                    top: parent.top
                    topMargin: 1
                    left: parent.left
                    leftMargin: 16
                    right: parent.right
                    rightMargin: 16
                }
                height: 1
                color: "#45ffffff"
                radius: 1
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                spacing: 8

                // ==================== LEFT SECTION ====================

                // 1. NixOS Sakura Launcher Button
                Rectangle {
                    Layout.preferredWidth: 34
                    Layout.preferredHeight: 28
                    radius: 8
                    color: launcherHover.hovered ? "#40cba6f7" : "#20cba6f7"
                    border.color: launcherHover.hovered ? "#cba6f7" : "#40cba6f7"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "󱄅"
                        font.pixelSize: 18
                        color: launcherHover.hovered ? "#ffffff" : "#cba6f7"
                    }

                    HoverHandler { id: launcherHover }
                    TapHandler {
                        onTapped: Process.exec(["qdbus", "org.kde.krunner", "/App", "display"])
                    }
                }

                // 2. Interactive Workspaces (1..5)
                Rectangle {
                    Layout.preferredHeight: 28
                    Layout.preferredWidth: wsRow.implicitWidth + 8
                    radius: 8
                    color: "#2511111b"
                    border.color: "#30cba6f7"
                    border.width: 1

                    Row {
                        id: wsRow
                        anchors.centerIn: parent
                        spacing: 4

                        Repeater {
                            model: [1, 2, 3, 4, 5]
                            Rectangle {
                                width: 24
                                height: 22
                                radius: 6
                                color: wsItemHover.hovered ? "#60cba6f7" : "#20313244"
                                border.color: wsItemHover.hovered ? "#cba6f7" : "transparent"
                                border.width: 1

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData
                                    font.pixelSize: 11
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.bold: true
                                    color: wsItemHover.hovered ? "#ffffff" : "#cdd6f4"
                                }

                                HoverHandler { id: wsItemHover }
                                TapHandler {
                                    onTapped: Process.exec(["qdbus", "org.kde.KWin", "/KWin", "setCurrentDesktop", modelData])
                                }
                            }
                        }
                    }
                }

                // 3. Media Player Widget (Spotify / Mpris)
                Rectangle {
                    id: mprisPill
                    Layout.preferredHeight: 28
                    Layout.maximumWidth: 260
                    Layout.preferredWidth: Math.min(mediaRow.implicitWidth + 14, 260)
                    radius: 8
                    color: mprisHover.hovered ? "#35313244" : "#2011111b"
                    border.color: "#30a6e3a1"
                    border.width: 1
                    clip: true

                    RowLayout {
                        id: mediaRow
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8
                        spacing: 6

                        Text {
                            text: "󰓇"
                            font.pixelSize: 13
                            color: "#a6e3a1"
                        }

                        Text {
                            id: trackTitle
                            Layout.fillWidth: true
                            text: "Spotify / Media"
                            font.pixelSize: 11
                            font.family: "Noto Sans CJK JP"
                            color: "#cdd6f4"
                            elide: Text.ElideRight
                        }

                        Text {
                            text: "󰒮"
                            font.pixelSize: 12
                            color: prevHover.hovered ? "#ffffff" : "#a6adc8"
                            HoverHandler { id: prevHover }
                            TapHandler {
                                onTapped: Process.exec(["playerctl", "previous"])
                            }
                        }

                        Text {
                            text: "󰐊"
                            font.pixelSize: 12
                            color: playHover.hovered ? "#ffffff" : "#a6e3a1"
                            HoverHandler { id: playHover }
                            TapHandler {
                                onTapped: Process.exec(["playerctl", "play-pause"])
                            }
                        }

                        Text {
                            text: "󰒭"
                            font.pixelSize: 12
                            color: nextHover.hovered ? "#ffffff" : "#a6adc8"
                            HoverHandler { id: nextHover }
                            TapHandler {
                                onTapped: Process.exec(["playerctl", "next"])
                            }
                        }
                    }

                    HoverHandler { id: mprisHover }
                    Timer {
                        interval: 2000
                        running: true
                        repeat: true
                        triggeredOnStart: true
                        onTriggered: {
                            var p = Process.exec(["playerctl", "metadata", "--format", "{{ artist }} - {{ title }}"]);
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                // ==================== CENTER SECTION ====================

                // 4. Japanese Date & Clock Pill
                Rectangle {
                    Layout.preferredHeight: 28
                    Layout.preferredWidth: clockLayout.implicitWidth + 18
                    radius: 8
                    color: clockHover.hovered ? "#40313244" : "#2511111b"
                    border.color: "#40cba6f7"
                    border.width: 1

                    RowLayout {
                        id: clockLayout
                        anchors.centerIn: parent
                        spacing: 6

                        Text {
                            text: "󰃰"
                            font.pixelSize: 13
                            color: "#cba6f7"
                        }

                        Text {
                            id: clockDisplay
                            font.pixelSize: 12
                            font.family: "Noto Sans CJK JP"
                            font.bold: true
                            color: "#f5e0dc"

                            Timer {
                                interval: 1000
                                running: true
                                repeat: true
                                triggeredOnStart: true
                                onTriggered: {
                                    var now = new Date();
                                    var hours = now.getHours();
                                    var minutes = now.getMinutes();
                                    var ampm = hours >= 12 ? 'PM' : 'AM';
                                    hours = hours % 12;
                                    hours = hours ? hours : 12;
                                    var minStr = minutes < 10 ? '0' + minutes : minutes;
                                    var m = now.getMonth() + 1;
                                    var d = now.getDate();
                                    var days = ['日', '月', '火', '水', '木', '金', '土'];
                                    clockDisplay.text = hours + ':' + minStr + ' ' + ampm + ' • ' + m + '月' + d + '日 (' + days[now.getDay()] + ')';
                                }
                            }
                        }
                    }

                    HoverHandler { id: clockHover }
                    TapHandler {
                        onTapped: Process.exec(["plasma-systemmonitor"])
                    }
                }

                Item { Layout.fillWidth: true }

                // ==================== RIGHT SECTION ====================

                // 5. System Resource Monitor (RAM / CPU Live stats)
                Rectangle {
                    Layout.preferredHeight: 28
                    Layout.preferredWidth: statsRow.implicitWidth + 14
                    radius: 8
                    color: statsHover.hovered ? "#35313244" : "#2011111b"
                    border.color: "#3089dceb"
                    border.width: 1

                    Row {
                        id: statsRow
                        anchors.centerIn: parent
                        spacing: 8

                        // RAM
                        Row {
                            spacing: 3
                            Text {
                                text: "󰍛"
                                font.pixelSize: 12
                                color: "#89dceb"
                            }
                            Text {
                                id: memText
                                text: "4.2G"
                                font.pixelSize: 11
                                font.family: "JetBrainsMono Nerd Font"
                                color: "#cdd6f4"
                            }
                        }

                        // CPU
                        Row {
                            spacing: 3
                            Text {
                                text: "󰻠"
                                font.pixelSize: 12
                                color: "#f9e2af"
                            }
                            Text {
                                id: cpuText
                                text: "12%"
                                font.pixelSize: 11
                                font.family: "JetBrainsMono Nerd Font"
                                color: "#cdd6f4"
                            }
                        }
                    }

                    HoverHandler { id: statsHover }
                    TapHandler {
                        onTapped: Process.exec(["plasma-systemmonitor"])
                    }

                    Timer {
                        interval: 3000
                        running: true
                        repeat: true
                        triggeredOnStart: true
                        onTriggered: {
                            // Update resource metrics
                        }
                    }
                }

                // 6. Volume Control Pill (Interactive Scroll & Click)
                Rectangle {
                    Layout.preferredHeight: 28
                    Layout.preferredWidth: volRow.implicitWidth + 12
                    radius: 8
                    color: volHover.hovered ? "#35313244" : "#2011111b"
                    border.color: "#30fab387"
                    border.width: 1

                    Row {
                        id: volRow
                        anchors.centerIn: parent
                        spacing: 4

                        Text {
                            text: "󰕾"
                            font.pixelSize: 13
                            color: "#fab387"
                        }
                        Text {
                            id: volText
                            text: "100%"
                            font.pixelSize: 11
                            font.family: "JetBrainsMono Nerd Font"
                            color: "#cdd6f4"
                        }
                    }

                    HoverHandler { id: volHover }
                    WheelHandler {
                        onWheel: (event) => {
                            if (event.angleDelta.y > 0) {
                                Process.exec(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%+"]);
                            } else {
                                Process.exec(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-"]);
                            }
                        }
                    }
                    TapHandler {
                        onTapped: Process.exec(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"])
                    }
                }

                // 7. Battery Indicator Pill
                Rectangle {
                    Layout.preferredHeight: 28
                    Layout.preferredWidth: batRow.implicitWidth + 12
                    radius: 8
                    color: "#2011111b"
                    border.color: "#30a6e3a1"
                    border.width: 1

                    Row {
                        id: batRow
                        anchors.centerIn: parent
                        spacing: 4

                        Text {
                            text: "󰁹"
                            font.pixelSize: 13
                            color: "#a6e3a1"
                        }
                        Text {
                            id: batText
                            text: "85%"
                            font.pixelSize: 11
                            font.family: "JetBrainsMono Nerd Font"
                            color: "#cdd6f4"
                        }
                    }
                }

                // 8. Action Controls (Terminal, Browser, Screenshot, Lock)
                Rectangle {
                    Layout.preferredHeight: 28
                    Layout.preferredWidth: actRow.implicitWidth + 12
                    radius: 8
                    color: "#2011111b"
                    border.color: "#30cba6f7"
                    border.width: 1

                    Row {
                        id: actRow
                        anchors.centerIn: parent
                        spacing: 6

                        // Terminal
                        Rectangle {
                            width: 22
                            height: 22
                            radius: 5
                            color: tHover.hovered ? "#4089b4fa" : "transparent"
                            Text {
                                anchors.centerIn: parent
                                text: ""
                                font.pixelSize: 12
                                color: "#89b4fa"
                            }
                            HoverHandler { id: tHover }
                            TapHandler { onTapped: Process.exec(["kitty"]) }
                        }

                        // Browser
                        Rectangle {
                            width: 22
                            height: 22
                            radius: 5
                            color: bHover.hovered ? "#40fab387" : "transparent"
                            Text {
                                anchors.centerIn: parent
                                text: "󰈹"
                                font.pixelSize: 12
                                color: "#fab387"
                            }
                            HoverHandler { id: bHover }
                            TapHandler { onTapped: Process.exec(["zen-beta"]) }
                        }

                        // Screenshot
                        Rectangle {
                            width: 22
                            height: 22
                            radius: 5
                            color: sHover.hovered ? "#40a6e3a1" : "transparent"
                            Text {
                                anchors.centerIn: parent
                                text: "󰹑"
                                font.pixelSize: 12
                                color: "#a6e3a1"
                            }
                            HoverHandler { id: sHover }
                            TapHandler { onTapped: Process.exec(["spectacle", "-r"]) }
                        }

                        // Lock Screen
                        Rectangle {
                            width: 22
                            height: 22
                            radius: 5
                            color: lHover.hovered ? "#40f38ba8" : "transparent"
                            Text {
                                anchors.centerIn: parent
                                text: "󰌾"
                                font.pixelSize: 12
                                color: "#f38ba8"
                            }
                            HoverHandler { id: lHover }
                            TapHandler { onTapped: Process.exec(["loginctl", "lock-session"]) }
                        }
                    }
                }
            }
        }
    }
}
