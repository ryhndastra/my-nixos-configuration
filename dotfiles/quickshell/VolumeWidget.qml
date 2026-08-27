import QtQuick
import QtQuick.Layouts

// Volume Widget — shows realtime volume %, scroll to change, click for dropdown
Item {
    id: root
    property int volumePercent: 80
    property bool muted: false
    property bool isOpen: false
    signal scroll(bool up)
    signal clicked()

    implicitWidth: volRow.implicitWidth + 14
    implicitHeight: 28

    Rectangle {
        anchors.fill: parent
        radius: 7
        color: ma.containsMouse ? "#3c313244" : (root.isOpen ? "#30fab387" : "#2011111b")
        border.color: root.isOpen ? "#fab387" : "#28fab387"
        border.width: 1
        Behavior on color { ColorAnimation { duration: 120 } }

        Row {
            id: volRow
            anchors.centerIn: parent
            spacing: 4

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.muted ? "󰖁" : root.volumePercent > 60 ? "󰕾" : root.volumePercent > 20 ? "󰖀" : "󰕿"
                font.pixelSize: 13
                color: root.muted ? "#f38ba8" : "#fab387"
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.muted ? "Muted" : root.volumePercent + "%"
                font.pixelSize: 11
                font.family: "JetBrainsMono Nerd Font"
                color: root.muted ? "#f38ba8" : "#cdd6f4"
            }
        }

        MouseArea {
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.clicked()
            onWheel: (wheel) => root.scroll(wheel.angleDelta.y > 0)
        }
    }
}
