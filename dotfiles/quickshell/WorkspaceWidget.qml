import QtQuick

// Workspace indicator pills
// Shows active/inactive state visually using high-contrast crisp numbers (1-5)
// Active: vibrant lavender filled pill; Inactive: clear high-contrast text with sleek capsule
Item {
    id: root
    property int activeDesktop: 1
    signal desktopClicked(int desktop)

    implicitWidth: wsRow.implicitWidth + 12
    implicitHeight: 28

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: "#1c181825"
        border.color: "#30cba6f7"
        border.width: 1

        Row {
            id: wsRow
            anchors.centerIn: parent
            spacing: 4

            Repeater {
                model: ["1", "2", "3", "4", "5"]

                Rectangle {
                    width: root.activeDesktop === (index + 1) ? 26 : 20
                    height: 20
                    radius: 5
                    color: root.activeDesktop === (index + 1) ? "#cba6f7" : (wsMa.containsMouse ? "#25cba6f7" : "#18313244")
                    border.color: root.activeDesktop === (index + 1) ? "#cba6f7" : (wsMa.containsMouse ? "#80cba6f7" : "#3045475a")
                    border.width: 1

                    Behavior on width { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
                    Behavior on color { ColorAnimation { duration: 120 } }

                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        font.pixelSize: 10
                        font.bold: true
                        font.family: "JetBrainsMono Nerd Font"
                        color: root.activeDesktop === (index + 1) ? "#11111b" : (wsMa.containsMouse ? "#cba6f7" : "#cdd6f4")
                    }

                    MouseArea {
                        id: wsMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.desktopClicked(index + 1)
                    }
                }
            }
        }
    }
}
