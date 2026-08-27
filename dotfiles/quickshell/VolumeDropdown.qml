import QtQuick
import QtQuick.Layouts

// Volume Dropdown — custom slider and mute toggle, no KDE audio app
Item {
    id: root
    property int volumePercent: 80
    property bool muted: false
    signal scroll(bool up)
    signal muteToggle()

    implicitWidth: 220
    implicitHeight: 110

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: "#e0181825"
        border.color: "#60fab387"
        border.width: 1.2

        Rectangle {
            anchors { top: parent.top; topMargin: 1; left: parent.left; leftMargin: 14; right: parent.right; rightMargin: 14 }
            height: 1; color: "#30ffffff"; radius: 1
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 10

            // Header
            RowLayout {
                Text {
                    text: root.muted ? "󰖁" : root.volumePercent > 60 ? "󰕾" : root.volumePercent > 20 ? "󰖀" : "󰕿"
                    font.pixelSize: 16
                    color: root.muted ? "#f38ba8" : "#fab387"
                }
                Text {
                    Layout.fillWidth: true
                    text: "Volume"
                    font.pixelSize: 12
                    font.bold: true
                    color: "#cdd6f4"
                    leftPadding: 6
                }
                Text {
                    text: root.muted ? "Muted" : root.volumePercent + "%"
                    font.pixelSize: 12
                    font.bold: true
                    color: root.muted ? "#f38ba8" : "#fab387"
                    font.family: "JetBrainsMono Nerd Font"
                }
            }

            // Volume bar (visual only — scroll on bar to change)
            Item {
                Layout.fillWidth: true
                height: 8

                Rectangle {
                    anchors.fill: parent
                    radius: 4
                    color: "#30313244"
                }
                Rectangle {
                    width: parent.width * (root.muted ? 0 : root.volumePercent / 100)
                    height: parent.height
                    radius: 4
                    color: root.muted ? "#f38ba8" : "#fab387"
                    Behavior on width { NumberAnimation { duration: 150 } }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.SizeHorCursor
                    onWheel: (wheel) => root.scroll(wheel.angleDelta.y > 0)
                }
            }

            // Mute toggle
            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                width: 100
                height: 24
                radius: 7
                color: muteMa.containsMouse ? "#30f38ba8" : "#20313244"
                border.color: root.muted ? "#f38ba8" : "#30313244"
                border.width: 1
                Behavior on color { ColorAnimation { duration: 100 } }

                Text {
                    anchors.centerIn: parent
                    text: root.muted ? "  Unmute" : "  Mute"
                    font.pixelSize: 11
                    color: root.muted ? "#f38ba8" : "#7f849c"
                }

                MouseArea {
                    id: muteMa
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.muteToggle()
                }
            }
        }
    }
}
