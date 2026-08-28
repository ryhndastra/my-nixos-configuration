import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import Quickshell.Widgets

// System Tray Widget — chevron toggle for collapsed/expanded tray icons
Item {
    id: root
    property bool expanded: false

    implicitWidth: trayContainer.implicitWidth + 6
    implicitHeight: 28
    visible: trayRepeater.count > 0

    Rectangle {
        anchors.fill: parent
        radius: 7
        color: "#2011111b"
        border.color: "#28cba6f7"
        border.width: 1

        Row {
            id: trayContainer
            anchors.centerIn: parent
            spacing: 4

            // Chevron toggle
            Rectangle {
                width: 18; height: 20; radius: 4
                color: chevMa.containsMouse ? "#30cba6f7" : "transparent"
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    anchors.centerIn: parent
                    text: root.expanded ? "󰅁" : "󰅂"
                    font.pixelSize: 11
                    color: "#7f849c"
                }

                MouseArea {
                    id: chevMa; anchors.fill: parent; hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.expanded = !root.expanded
                }
            }

            // Tray icons (only visible when expanded)
            Row {
                id: trayRow
                spacing: 4
                visible: root.expanded
                anchors.verticalCenter: parent.verticalCenter

                Repeater {
                    id: trayRepeater
                    model: SystemTray.items

                    Rectangle {
                        width: 22; height: 22; radius: 5
                        color: trayMa.containsMouse ? "#30cba6f7" : "transparent"
                        Behavior on color { ColorAnimation { duration: 80 } }

                        IconImage {
                            anchors.centerIn: parent
                            width: 16; height: 16
                            source: modelData.icon
                        }

                        MouseArea {
                            id: trayMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            onClicked: (mouse) => {
                                if (modelData.hasMenu) {
                                    // Open the DBusMenu popup at click position
                                    modelData.display(root, mouse.x, mouse.y)
                                } else if (mouse.button === Qt.LeftButton) {
                                    modelData.activate()
                                } else {
                                    modelData.secondaryActivate()
                                }
                            }
                        }
                    }
                }
            }

            // Badge count when collapsed
            Text {
                visible: !root.expanded && trayRepeater.count > 0
                text: trayRepeater.count.toString()
                font.pixelSize: 9
                font.bold: true
                font.family: "JetBrainsMono Nerd Font"
                color: "#7f849c"
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
