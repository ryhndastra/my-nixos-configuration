import QtQuick
import QtQuick.Layouts

// Noctalia Master Control Center Sakura Button on the Bar
// Uses a clean Sakura flower Nerd Font glyph colored in Sakura Pink (#f5c2e7)
Item {
    id: root
    property bool isOpen: false
    signal clicked()

    implicitWidth: 32
    implicitHeight: 28

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: ma.containsMouse ? "#30f5c2e7" : (root.isOpen ? "#40f5c2e7" : "#2011111b")
        border.color: root.isOpen ? "#f5c2e7" : (ma.containsMouse ? "#90f5c2e7" : "#35f5c2e7")
        border.width: 1.2
        Behavior on color { ColorAnimation { duration: 120 } }
        Behavior on border.color { ColorAnimation { duration: 120 } }

        // Sakura Flower Glyph in Sakura Pink (#f5c2e7)
        Text {
            anchors.centerIn: parent
            text: "󰉉"
            font.pixelSize: 14
            font.family: "JetBrainsMono Nerd Font"
            color: root.isOpen ? "#f5c2e7" : (ma.containsMouse ? "#ffffff" : "#f5c2e7")
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
