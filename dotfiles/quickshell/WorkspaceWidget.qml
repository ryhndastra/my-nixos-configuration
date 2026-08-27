import QtQuick

// Workspace indicator pills
// Shows active/inactive state visually using Roman numerals
// Active: filled lavender pill; Inactive: transparent dim pill
Item {
    id: root
    property int activeDesktop: 1
    signal desktopClicked(int desktop)

    implicitWidth: wsRow.implicitWidth + 16
    implicitHeight: 28

    Rectangle {
        anchors.fill: parent
        radius: 7
        color: "#2011111b"
        border.color: "#28cba6f7"
        border.width: 1

        Row {
            id: wsRow
            anchors.centerIn: parent
            spacing: 3

            Repeater {
                model: ["I","II","III","IV","V"]
                Rectangle {
                    width: root.activeDesktop === (index + 1) ? 28 : 20
                    height: 20
                    radius: 5
                    color: root.activeDesktop === (index + 1) ? "#cba6f7" : "transparent"

                    Behavior on width { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
                    Behavior on color { ColorAnimation { duration: 120 } }

                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        font.pixelSize: root.activeDesktop === (index + 1) ? 9 : 8
                        font.bold: root.activeDesktop === (index + 1)
                        font.family: "JetBrainsMono Nerd Font"
                        color: root.activeDesktop === (index + 1) ? "#11111b" : "#585b70"
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.desktopClicked(index + 1)
                        Rectangle {
                            anchors.fill: parent
                            radius: parent.parent.radius
                            color: parent.containsMouse && root.activeDesktop !== (index + 1) ? "#20cba6f7" : "transparent"
                        }
                    }
                }
            }
        }
    }
}
