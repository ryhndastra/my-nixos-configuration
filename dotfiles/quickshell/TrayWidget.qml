import QtQuick
import Quickshell.Services.SystemTray

// System Tray Widget — sleek pill button with chevron & active items badge count
Item {
    id: root
    property bool isOpen: false
    signal clicked()

    implicitWidth: trayRow.implicitWidth + 14
    implicitHeight: 28

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: ma.containsMouse ? "#3c313244" : (root.isOpen ? "#40cba6f7" : "#2011111b")
        border.color: root.isOpen ? "#cba6f7" : (ma.containsMouse ? "#80cba6f7" : "#28cba6f7")
        border.width: 1
        Behavior on color { ColorAnimation { duration: 100 } }
        Behavior on border.color { ColorAnimation { duration: 100 } }

        Row {
            id: trayRow
            anchors.centerIn: parent
            spacing: 4

            // Tray chevron icon
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.isOpen ? "󰅃" : "󰅀"
                font.pixelSize: 11
                color: root.isOpen ? "#cba6f7" : (ma.containsMouse ? "#cba6f7" : "#a6adc8")
            }

            // Active items badge count
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: SystemTray.items.values.length.toString()
                font.pixelSize: 10
                font.bold: true
                font.family: "JetBrainsMono Nerd Font"
                color: root.isOpen ? "#cba6f7" : (ma.containsMouse ? "#cba6f7" : "#cdd6f4")
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
