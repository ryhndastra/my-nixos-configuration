import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import Quickshell.Widgets

// System Tray Dropdown — sleek panel showing all tray icons
Item {
    id: root
    implicitWidth: 240
    implicitHeight: trayContent.implicitHeight + 24

    Rectangle {
        anchors.fill: parent
        radius: 14
        color: "#e8181825"
        border.color: "#80cba6f7"
        border.width: 1.5

        Rectangle {
            anchors { top: parent.top; topMargin: 1; left: parent.left; leftMargin: 16; right: parent.right; rightMargin: 16 }
            height: 1; color: "#40ffffff"; radius: 1
        }

        ColumnLayout {
            id: trayContent
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            // Header
            RowLayout {
                Text { text: "󰆍"; font.pixelSize: 14; color: "#cba6f7" }
                ColumnLayout {
                    spacing: 1
                    Text { text: "システムトレイ"; font.pixelSize: 11; font.bold: true; font.family: "Noto Sans CJK JP"; color: "#cdd6f4" }
                    Text { text: "System Tray • " + SystemTray.items.values.length + " items"; font.pixelSize: 8; color: "#585b70" }
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: "#20cba6f7" }

            // Tray items grid
            Flow {
                Layout.fillWidth: true
                spacing: 6

                Repeater {
                    model: SystemTray.items

                    Rectangle {
                        width: 44; height: 44; radius: 8
                        color: trayItemMa.containsMouse ? "#30cba6f7" : "#18313244"
                        border.color: trayItemMa.containsMouse ? "#cba6f7" : "#2045475a"
                        border.width: 1
                        Behavior on color { ColorAnimation { duration: 80 } }

                        IconImage {
                            anchors.centerIn: parent
                            width: 22; height: 22
                            source: modelData.icon
                        }

                        MouseArea {
                            id: trayItemMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            onClicked: (mouse) => {
                                if (modelData.hasMenu) {
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

            // Empty state
            Text {
                visible: SystemTray.items.values.length === 0
                text: "トレイアイテムなし"
                font.pixelSize: 10
                font.family: "Noto Sans CJK JP"
                color: "#585b70"
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
