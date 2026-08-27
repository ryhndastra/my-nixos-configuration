import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland

// Taskbar / Running & Minimized Windows Widget
Item {
    id: root
    implicitWidth: taskRow.implicitWidth + (taskRepeater.count > 0 ? 8 : 0)
    implicitHeight: 28
    visible: taskRepeater.count > 0

    Rectangle {
        anchors.fill: parent
        radius: 7
        color: "#1811111b"
        border.color: "#20cba6f7"
        border.width: 1

        Row {
            id: taskRow
            anchors.centerIn: parent
            spacing: 4

            Repeater {
                id: taskRepeater
                model: ToplevelManager.toplevels

                Rectangle {
                    width: modelData.activated ? 32 : (modelData.minimized ? 22 : 26)
                    height: 20
                    radius: 5
                    color: modelData.activated ? "#35cba6f7" : (modelData.minimized ? "#10585b70" : "#18313244")
                    border.color: modelData.activated ? "#cba6f7" : (modelData.minimized ? "#25585b70" : "#3045475a")
                    border.width: 1

                    Behavior on width { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
                    Behavior on color { ColorAnimation { duration: 120 } }

                    Text {
                        anchors.centerIn: parent
                        text: {
                            var id = (modelData.appId || "").toLowerCase()
                            if (id.includes("kitty")) return "󰄛"
                            if (id.includes("zen") || id.includes("firefox")) return "󰈹"
                            if (id.includes("discord") || id.includes("vesktop")) return "󰙯"
                            if (id.includes("code") || id.includes("antigravity")) return "󰨞"
                            if (id.includes("spotify")) return "󰓇"
                            if (id.includes("dolphin")) return "󰉋"
                            if (id.includes("spectacle")) return "󰹑"
                            return modelData.title ? modelData.title.slice(0, 1).toUpperCase() : "󰘔"
                        }
                        font.pixelSize: 11
                        font.family: "JetBrainsMono Nerd Font"
                        color: modelData.activated ? "#cba6f7" : (modelData.minimized ? "#585b70" : "#a6adc8")
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            modelData.activate()
                        }
                    }
                }
            }
        }
    }
}
