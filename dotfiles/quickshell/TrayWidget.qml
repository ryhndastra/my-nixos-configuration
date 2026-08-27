import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import Quickshell.Widgets

// System Tray Widget — displays apps like Vesktop, Steam, OBS, Telegram, etc.
Item {
    id: root
    implicitWidth: trayRow.implicitWidth + (trayRepeater.count > 0 ? 12 : 0)
    implicitHeight: 28
    visible: trayRepeater.count > 0

    Rectangle {
        anchors.fill: parent
        radius: 7
        color: "#2011111b"
        border.color: "#28cba6f7"
        border.width: 1

        Row {
            id: trayRow
            anchors.centerIn: parent
            spacing: 5

            Repeater {
                id: trayRepeater
                model: SystemTray.items

                Rectangle {
                    width: 22
                    height: 22
                    radius: 5
                    color: trayMa.containsMouse ? "#30cba6f7" : "transparent"
                    Behavior on color { ColorAnimation { duration: 100 } }

                    IconImage {
                        anchors.centerIn: parent
                        width: 16
                        height: 16
                        source: modelData.icon
                    }

                    MouseArea {
                        id: trayMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: (mouse) => {
                            if (mouse.button === Qt.LeftButton) {
                                modelData.activate()
                            } else if (mouse.button === Qt.RightButton) {
                                modelData.secondaryActivate()
                            }
                        }
                    }
                }
            }
        }
    }
}
