import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Io

ShellRoot {
    PanelWindow {
        id: topBar
        anchors {
            top: true
            left: true
            right: true
        }
        height: 44
        color: "transparent"

        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        WlrLayershell.namespace: "quickshell-bar"

        // Center Floating Frosted Acrylic Glass Capsule
        Rectangle {
            id: barCapsule
            anchors {
                top: parent.top
                topMargin: 4
                bottom: parent.bottom
                bottomMargin: 3
                left: parent.left
                leftMargin: 12
                right: parent.right
                rightMargin: 12
            }
            radius: 12
            color: "#66181825" // Translucent Glass Background
            border.color: "#80cba6f7" // Sakura Lavender Outline
            border.width: 1.2

            // Top Glass Specular Highlight
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
                color: "#40ffffff"
                radius: 1
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                spacing: 8

                // ==================== LEFT ====================

                // 1. NixOS Sakura Launcher
                Rectangle {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 26
                    radius: 7
                    color: launcherMouse.containsMouse ? "#40cba6f7" : "#20cba6f7"
                    border.color: launcherMouse.containsMouse ? "#cba6f7" : "#40cba6f7"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "󱄅"
                        font.pixelSize: 16
                        color: launcherMouse.containsMouse ? "#ffffff" : "#cba6f7"
                    }

                    MouseArea {
                        id: launcherMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Process.exec(["qdbus", "org.kde.krunner", "/App", "display"])
                    }
                }

                // 2. Workspaces 1..5
                Rectangle {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: 26
                    Layout.preferredWidth: wsRow.implicitWidth + 8
                    radius: 7
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
                                height: 20
                                radius: 5
                                color: wsMouse.containsMouse ? "#60cba6f7" : "#20313244"
                                border.color: wsMouse.containsMouse ? "#cba6f7" : "transparent"
                                border.width: 1

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData
                                    font.pixelSize: 11
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.bold: true
                                    color: wsMouse.containsMouse ? "#ffffff" : "#cdd6f4"
                                }

                                MouseArea {
                                    id: wsMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: Process.exec(["qdbus", "org.kde.KWin", "/KWin", "setCurrentDesktop", modelData])
                                }
                            }
                        }
                    }
                }

                // 3. Media Player Widget (Spotify / Playerctl)
                Rectangle {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: 26
                    Layout.maximumWidth: 260
                    Layout.preferredWidth: mediaRow.implicitWidth + 14
                    radius: 7
                    color: "#2511111b"
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
                            Layout.alignment: Qt.AlignVCenter
                            text: "󰓇"
                            font.pixelSize: 13
                            color: "#a6e3a1"
                        }

                        Text {
                            id: trackTitle
                            Layout.alignment: Qt.AlignVCenter
                            Layout.maximumWidth: 160
                            text: "Media Player"
                            font.pixelSize: 11
                            font.family: "Noto Sans CJK JP"
                            color: "#cdd6f4"
                            elide: Text.ElideRight
                        }

                        // Prev
                        Text {
                            Layout.alignment: Qt.AlignVCenter
                            text: "󰒮"
                            font.pixelSize: 12
                            color: prevMouse.containsMouse ? "#ffffff" : "#a6adc8"
                            MouseArea {
                                id: prevMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Process.exec(["playerctl", "previous"])
                            }
                        }

                        // Play/Pause
                        Text {
                            Layout.alignment: Qt.AlignVCenter
                            text: "󰐊"
                            font.pixelSize: 12
                            color: playMouse.containsMouse ? "#ffffff" : "#a6e3a1"
                            MouseArea {
                                id: playMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Process.exec(["playerctl", "play-pause"])
                            }
                        }

                        // Next
                        Text {
                            Layout.alignment: Qt.AlignVCenter
                            text: "󰒭"
                            font.pixelSize: 12
                            color: nextMouse.containsMouse ? "#ffffff" : "#a6adc8"
                            MouseArea {
                                id: nextMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Process.exec(["playerctl", "next"])
                            }
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                // ==================== CENTER ====================

                // 4. Japanese Date & Clock Pill
                Rectangle {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: 26
                    Layout.preferredWidth: clockLayout.implicitWidth + 18
                    radius: 7
                    color: clockMouse.containsMouse ? "#40313244" : "#2511111b"
                    border.color: "#40cba6f7"
                    border.width: 1

                    RowLayout {
                        id: clockLayout
                        anchors.centerIn: parent
                        spacing: 6

                        Text {
                            Layout.alignment: Qt.AlignVCenter
                            text: "󰃰"
                            font.pixelSize: 12
                            color: "#cba6f7"
                        }

                        Text {
                            id: clockDisplay
                            Layout.alignment: Qt.AlignVCenter
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

                    MouseArea {
                        id: clockMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Process.exec(["plasma-systemmonitor"])
                    }
                }

                Item { Layout.fillWidth: true }

                // ==================== RIGHT ====================

                // 5. System Stats (RAM & CPU)
                Rectangle {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: 26
                    Layout.preferredWidth: statsRow.implicitWidth + 14
                    radius: 7
                    color: statsMouse.containsMouse ? "#35313244" : "#2511111b"
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
                                anchors.verticalCenter: parent.verticalCenter
                                text: "󰍛"
                                font.pixelSize: 12
                                color: "#89dceb"
                            }
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: "RAM"
                                font.pixelSize: 11
                                font.family: "JetBrainsMono Nerd Font"
                                color: "#cdd6f4"
                            }
                        }

                        // CPU
                        Row {
                            spacing: 3
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: "󰻠"
                                font.pixelSize: 12
                                color: "#f9e2af"
                            }
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: "CPU"
                                font.pixelSize: 11
                                font.family: "JetBrainsMono Nerd Font"
                                color: "#cdd6f4"
                            }
                        }
                    }

                    MouseArea {
                        id: statsMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Process.exec(["plasma-systemmonitor"])
                    }
                }

                // 6. Volume Control (Scroll up/down for volume, click to mute)
                Rectangle {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: 26
                    Layout.preferredWidth: volRow.implicitWidth + 12
                    radius: 7
                    color: volMouse.containsMouse ? "#35313244" : "#2511111b"
                    border.color: "#30fab387"
                    border.width: 1

                    Row {
                        id: volRow
                        anchors.centerIn: parent
                        spacing: 4

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "󰕾"
                            font.pixelSize: 13
                            color: "#fab387"
                        }
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "VOL"
                            font.pixelSize: 11
                            font.family: "JetBrainsMono Nerd Font"
                            color: "#cdd6f4"
                        }
                    }

                    MouseArea {
                        id: volMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onWheel: (wheel) => {
                            if (wheel.angleDelta.y > 0) {
                                Process.exec(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%+"]);
                            } else {
                                Process.exec(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-"]);
                            }
                        }
                        onClicked: Process.exec(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"])
                    }
                }

                // 7. Battery Indicator
                Rectangle {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: 26
                    Layout.preferredWidth: batRow.implicitWidth + 12
                    radius: 7
                    color: "#2511111b"
                    border.color: "#30a6e3a1"
                    border.width: 1

                    Row {
                        id: batRow
                        anchors.centerIn: parent
                        spacing: 4

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "󰁹"
                            font.pixelSize: 13
                            color: "#a6e3a1"
                        }
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "BAT"
                            font.pixelSize: 11
                            font.family: "JetBrainsMono Nerd Font"
                            color: "#cdd6f4"
                        }
                    }
                }

                // 8. Action Launchers (Kitty, Zen, Screenshot, Lock)
                Rectangle {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: 26
                    Layout.preferredWidth: actRow.implicitWidth + 12
                    radius: 7
                    color: "#2511111b"
                    border.color: "#30cba6f7"
                    border.width: 1

                    Row {
                        id: actRow
                        anchors.centerIn: parent
                        spacing: 6

                        // Terminal
                        Rectangle {
                            width: 20
                            height: 20
                            radius: 5
                            color: tMouse.containsMouse ? "#4089b4fa" : "transparent"
                            Text {
                                anchors.centerIn: parent
                                text: ""
                                font.pixelSize: 12
                                color: "#89b4fa"
                            }
                            MouseArea {
                                id: tMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Process.exec(["kitty"])
                            }
                        }

                        // Browser
                        Rectangle {
                            width: 20
                            height: 20
                            radius: 5
                            color: bMouse.containsMouse ? "#40fab387" : "transparent"
                            Text {
                                anchors.centerIn: parent
                                text: "󰈹"
                                font.pixelSize: 12
                                color: "#fab387"
                            }
                            MouseArea {
                                id: bMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Process.exec(["zen-beta"])
                            }
                        }

                        // Screenshot Spectacle
                        Rectangle {
                            width: 20
                            height: 20
                            radius: 5
                            color: sMouse.containsMouse ? "#40a6e3a1" : "transparent"
                            Text {
                                anchors.centerIn: parent
                                text: "󰹑"
                                font.pixelSize: 12
                                color: "#a6e3a1"
                            }
                            MouseArea {
                                id: sMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Process.exec(["spectacle", "-r"])
                            }
                        }

                        // Lock Screen
                        Rectangle {
                            width: 20
                            height: 20
                            radius: 5
                            color: lMouse.containsMouse ? "#40f38ba8" : "transparent"
                            Text {
                                anchors.centerIn: parent
                                text: "󰌾"
                                font.pixelSize: 12
                                color: "#f38ba8"
                            }
                            MouseArea {
                                id: lMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Process.exec(["loginctl", "lock-session"])
                            }
                        }
                    }
                }
            }
        }
    }
}
