import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
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
        height: 46
        color: "transparent"

        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        WlrLayershell.namespace: "quickshell-bar"

        // Outer Shadow / Glow
        Rectangle {
            anchors.centerIn: barCapsule
            width: barCapsule.width + 4
            height: barCapsule.height + 4
            radius: 16
            color: "#40000000"
        }

        // Center Floating Frosted Glass Capsule Island
        Rectangle {
            id: barCapsule
            anchors {
                top: parent.top
                topMargin: 6
                bottom: parent.bottom
                bottomMargin: 4
                horizontalCenter: parent.horizontalCenter
            }
            width: Math.min(parent.width - 32, 1340)
            radius: 14

            // Multi-layered Acrylic Frosted Glass Effect
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#d01e1e2e" } // Catppuccin Base with 82% opacity
                GradientStop { position: 1.0; color: "#b811111b" } // Catppuccin Crust with 72% opacity
            }
            border.color: "#80cba6f7" // Glowing Sakura Lavender Border
            border.width: 1.2

            // Top Glass Highlight Specular Sheen
            Rectangle {
                anchors {
                    top: parent.top
                    topMargin: 1
                    left: parent.left
                    leftMargin: 14
                    right: parent.right
                    rightMargin: 14
                }
                height: 1
                color: "#50ffffff"
                radius: 1
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 14
                anchors.rightMargin: 14
                spacing: 12

                // Left: NixOS Sakura Launcher Button
                Rectangle {
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 28
                    radius: 8
                    color: launcherHover.hovered ? "#40cba6f7" : "#20cba6f7"
                    border.color: launcherHover.hovered ? "#cba6f7" : "#30cba6f7"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "󱄅" // NixOS Logo
                        font.pixelSize: 17
                        color: "#cba6f7"
                    }

                    HoverHandler { id: launcherHover }
                    TapHandler {
                        onTapped: {
                            Process.exec(["qdbus", "org.kde.plasma.kickoff", "/kickoff", "org.kde.plasma.kickoff.toggle"])
                        }
                    }
                }

                // Workspaces (1..5) with Frosted Pill Container
                Rectangle {
                    Layout.preferredHeight: 28
                    Layout.preferredWidth: wsRow.implicitWidth + 8
                    radius: 8
                    color: "#3011111b"
                    border.color: "#30cba6f7"
                    border.width: 1

                    Row {
                        id: wsRow
                        anchors.centerIn: parent
                        spacing: 4

                        Repeater {
                            model: [1, 2, 3, 4, 5]
                            Rectangle {
                                width: 22
                                height: 22
                                radius: 6
                                color: wsHover.hovered ? "#60cba6f7" : "#25313244"
                                border.color: wsHover.hovered ? "#cba6f7" : "transparent"
                                border.width: 1

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData
                                    font.pixelSize: 11
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.bold: true
                                    color: wsHover.hovered ? "#ffffff" : "#cdd6f4"
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
                }

                Item { Layout.fillWidth: true }

                // Center: Frosted Japanese Date & Time Capsule
                Rectangle {
                    Layout.preferredHeight: 28
                    Layout.preferredWidth: clockText.implicitWidth + 24
                    radius: 8
                    color: "#3011111b"
                    border.color: "#35cba6f7"
                    border.width: 1

                    Text {
                        id: clockText
                        anchors.centerIn: parent
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
                                var minutesStr = minutes < 10 ? '0' + minutes : minutes;
                                var monthStr = (now.getMonth() + 1);
                                var dateStr = now.getDate();
                                var days = ['日', '月', '火', '水', '木', '金', '土'];
                                var dayStr = days[now.getDay()];
                                clockText.text = hours + ':' + minutesStr + ' ' + ampm + ' • ' + monthStr + '月' + dateStr + '日 (' + dayStr + ')';
                            }
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                // Right: Quick Action Controls Capsule
                Rectangle {
                    Layout.preferredHeight: 28
                    Layout.preferredWidth: actionsRow.implicitWidth + 12
                    radius: 8
                    color: "#3011111b"
                    border.color: "#30cba6f7"
                    border.width: 1

                    Row {
                        id: actionsRow
                        anchors.centerIn: parent
                        spacing: 6

                        // Terminal Quick Launch
                        Rectangle {
                            width: 24
                            height: 24
                            radius: 6
                            color: termHover.hovered ? "#4089b4fa" : "transparent"

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
                            width: 24
                            height: 24
                            radius: 6
                            color: webHover.hovered ? "#40fab387" : "transparent"

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

                        // Lock Screen
                        Rectangle {
                            width: 24
                            height: 24
                            radius: 6
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
}
