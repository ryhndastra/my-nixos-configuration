import QtQuick
import QtQuick.Layouts

// System Stats Widget — shows realtime RAM and CPU usage
// Click to open stats dropdown
Item {
    id: root
    property int cpuPercent: 0
    property string ramText: "--"
    property bool isOpen: false
    signal clicked()

    implicitWidth: statsRow.implicitWidth + 14
    implicitHeight: 28

    Rectangle {
        anchors.fill: parent
        radius: 7
        color: ma.containsMouse ? "#3c313244" : (root.isOpen ? "#3089dceb" : "#2011111b")
        border.color: root.isOpen ? "#89dceb" : "#2889dceb"
        border.width: 1
        Behavior on color { ColorAnimation { duration: 120 } }

        Row {
            id: statsRow
            anchors.centerIn: parent
            spacing: 8

            // RAM
            Row {
                spacing: 3
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "󰍛"
                    font.pixelSize: 12
                    color: "#89dceb"
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.ramText
                    font.pixelSize: 11
                    font.family: "JetBrainsMono Nerd Font"
                    color: "#cdd6f4"
                }
            }

            // CPU
            Row {
                spacing: 3
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "󰻠"
                    font.pixelSize: 12
                    color: root.cpuPercent > 80 ? "#f38ba8" : root.cpuPercent > 50 ? "#f9e2af" : "#a6e3a1"
                    Behavior on color { ColorAnimation { duration: 300 } }
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.cpuPercent + "%"
                    font.pixelSize: 11
                    font.family: "JetBrainsMono Nerd Font"
                    color: "#cdd6f4"
                }
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
