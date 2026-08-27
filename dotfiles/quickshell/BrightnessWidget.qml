import QtQuick
import QtQuick.Layouts

// Brightness widget — shows current brightness %, scroll to change
Item {
    id: root
    property int brightnessPercent: 80
    signal scroll(bool up)

    implicitWidth: brightRow.implicitWidth + 14
    implicitHeight: 28

    Rectangle {
        anchors.fill: parent
        radius: 7
        color: ma.containsMouse ? "#3c313244" : "#2011111b"
        border.color: "#28f9e2af"
        border.width: 1
        Behavior on color { ColorAnimation { duration: 120 } }

        Row {
            id: brightRow
            anchors.centerIn: parent
            spacing: 4

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.brightnessPercent > 70 ? "󰃠" : root.brightnessPercent > 30 ? "󰃟" : "󰃞"
                font.pixelSize: 13
                color: "#f9e2af"
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.brightnessPercent + "%"
                font.pixelSize: 11
                font.family: "JetBrainsMono Nerd Font"
                color: "#cdd6f4"
            }
        }

        MouseArea {
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.SizeVerCursor
            onWheel: (wheel) => root.scroll(wheel.angleDelta.y > 0)
        }
    }
}
