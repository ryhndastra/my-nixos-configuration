import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import Quickshell.Widgets

// System Tray — chevron that opens a dropdown panel below the bar
Item {
    id: root
    property bool isOpen: false
    signal clicked()

    implicitWidth: chevPill.implicitWidth + 10
    implicitHeight: 28

    Rectangle {
        id: chevPill
        anchors.fill: parent
        radius: 7
        color: ma.containsMouse ? "#3c313244" : (root.isOpen ? "#40cba6f7" : "#2011111b")
        border.color: root.isOpen ? "#cba6f7" : "#28cba6f7"
        border.width: 1
        Behavior on color { ColorAnimation { duration: 100 } }

        Row {
            anchors.centerIn: parent
            spacing: 4

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.isOpen ? "󰅃" : "󰅀"
                font.pixelSize: 11
                color: "#7f849c"
            }

            // Badge count
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: SystemTray.items.values.length.toString()
                font.pixelSize: 9
                font.bold: true
                font.family: "JetBrainsMono Nerd Font"
                color: root.isOpen ? "#cba6f7" : "#7f849c"
                visible: SystemTray.items.values.length > 0
            }
        }

        MouseArea {
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.clicked()
        }
    }
}
