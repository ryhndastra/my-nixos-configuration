import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import Quickshell.Services.Pipewire
import Quickshell.Io

ShellRoot {
    PanelWindow {
        id: topBar
        anchors {
            top: true
            left: true
            right: true
        }
        height: 42
        color: "transparent"

        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        WlrLayershell.namespace: "quickshell-bar"

        // Center Floating Capsule Island
        Rectangle {
            id: barCapsule
            anchors {
                top: parent.top
                topMargin: 4
                bottom: parent.bottom
                bottomMargin: 2
                horizontalCenter: parent.horizontalCenter
            }
            width: Math.min(parent.width - 24, 1300)
            radius: 12
            color: "#80181825" // Translucent Catppuccin Mocha Mantle
            border.color: "#60cba6f7" // Subtle Sakura Lavender Border
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 12

                // Left: NixOS Sakura Launcher Button
                Rectangle {
                    Layout.preferredWidth: 30
                    Layout.preferredHeight: 26
                    radius: 8
                    color: launcherHover.hovered ? "#40cba6f7" : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "󱄅" // NixOS Icon
                        font.pixelSize: 16
                        color: "#cba6f7"
                    }

                    HoverHandler { id: launcherHover }
                    TapHandler {
                        onTapped: {
                            Process.exec(["qdbus", "org.kde.plasma.kickoff", "/kickoff", "org.kde.plasma.kickoff.toggle"])
                        }
                    }
                }

                // Workspaces (1..5)
                Row {
                    spacing: 4
                    Repeater {
                        model: [1, 2, 3, 4, 5]
                        Rectangle {
                            width: 24
                            height: 22
                            radius: 6
                            color: wsHover.hovered ? "#40cba6f7" : "#20cba6f7"
                            border.color: "#40cba6f7"
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: modelData
                                font.pixelSize: 11
                                font.family: "JetBrainsMono Nerd Font"
                                font.bold: true
                                color: "#cdd6f4"
                            }

                            HoverHandler { id: wsHover }
                            TapHandler {
                                onTapped: {
                                    Process.exec(["qdbus", "org.kde.KWin", "/KWin", "setCurrentDesktop", modelData])
                                }
                            }
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                // Center: Japanese Date & Clock
                Rectangle {
                    Layout.preferredHeight: 26
                    radius: 8
                    color: "#201e1e2e"

                    Text {
                        id: clockText
                        anchors.centerIn: parent
                        font.pixelSize: 12
                        font.family: "Noto Sans CJK JP"
                        font.bold: true
                        color: "#cdd6f4"

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
                                var minutesStr = minutes < 10 ? '0' + minutes : minutes;
                                var dateStr = (now.getMonth() + 1) + '月' + now.getDate() + '日';
                                clockText.text = hours + ':' + minutesStr + ' ' + ampm + ' • ' + dateStr;
                            }
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                // Right: System Stats / Indicators
                Row {
                    spacing: 8

                    // Terminal Quick Launch
                    Rectangle {
                        width: 26
                        height: 26
                        radius: 8
                        color: termHover.hovered ? "#40cba6f7" : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: ""
                            font.pixelSize: 13
                            color: "#89b4fa"
                        }
                        HoverHandler { id: termHover }
                        TapHandler {
                            onTapped: Process.exec(["kitty"])
                        }
                    }

                    // Browser Quick Launch
                    Rectangle {
                        width: 26
                        height: 26
                        radius: 8
                        color: webHover.hovered ? "#40cba6f7" : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: "󰈹"
                            font.pixelSize: 13
                            color: "#fab387"
                        }
                        HoverHandler { id: webHover }
                        TapHandler {
                            onTapped: Process.exec(["zen-beta"])
                        }
                    }

                    // Power / Lock
                    Rectangle {
                        width: 26
                        height: 26
                        radius: 8
                        color: lockHover.hovered ? "#40f38ba8" : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: "󰌾"
                            font.pixelSize: 13
                            color: "#f38ba8"
                        }
                        HoverHandler { id: lockHover }
                        TapHandler {
                            onTapped: Process.exec(["loginctl", "lock-session"])
                        }
                    }
                }
            }
        }
    }
}
