import QtQuick

// Battery Widget — realtime battery % with charging icon, click for dropdown
Item {
    id: root
    property int batteryPercent: 85
    property bool charging: false
    property bool isOpen: false
    signal clicked()

    // Pick icon based on level + charging state
    readonly property string batIcon: {
        if (charging) return "󰂄"
        if (batteryPercent >= 90) return "󰁹"
        if (batteryPercent >= 70) return "󰂀"
        if (batteryPercent >= 50) return "󰁾"
        if (batteryPercent >= 30) return "󰁼"
        if (batteryPercent >= 10) return "󰁺"
        return "󰂃"
    }
    readonly property string batColor: {
        if (charging) return "#a6e3a1"
        if (batteryPercent <= 15) return "#f38ba8"
        if (batteryPercent <= 30) return "#f9e2af"
        return "#a6e3a1"
    }

    implicitWidth: batRow.implicitWidth + 14
    implicitHeight: 28

    Rectangle {
        anchors.fill: parent
        radius: 7
        color: ma.containsMouse ? "#3c313244" : (root.isOpen ? "#30a6e3a1" : "#2011111b")
        border.color: root.isOpen ? root.batColor : "#28a6e3a1"
        border.width: 1
        Behavior on color { ColorAnimation { duration: 120 } }

        Row {
            id: batRow
            anchors.centerIn: parent
            spacing: 4

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.batIcon
                font.pixelSize: 13
                color: root.batColor
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.batteryPercent + "%"
                font.pixelSize: 11
                font.family: "JetBrainsMono Nerd Font"
                color: "#cdd6f4"
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
