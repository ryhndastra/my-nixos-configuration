import QtQuick
import QtQuick.Layouts

// Japanese Clock Widget — clickable, shows calendar dropdown when clicked
Item {
    id: root
    property bool isOpen: false
    signal clicked()

    implicitWidth: clockRow.implicitWidth + 18
    implicitHeight: 28

    Rectangle {
        anchors.fill: parent
        radius: 7
        color: ma.containsMouse ? "#3c313244" : (root.isOpen ? "#50cba6f7" : "#2811111b")
        border.color: root.isOpen ? "#cba6f7" : "#40cba6f7"
        border.width: 1
        Behavior on color { ColorAnimation { duration: 120 } }

        RowLayout {
            id: clockRow
            anchors.centerIn: parent
            spacing: 6

            Text {
                Layout.alignment: Qt.AlignVCenter
                text: "󰃰"
                font.pixelSize: 12
                color: "#cba6f7"
            }

            Text {
                id: clockDisplay
                Layout.alignment: Qt.AlignVCenter
                font.pixelSize: 12
                font.family: "Noto Sans CJK JP"
                font.bold: true
                color: "#f5e0dc"

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    triggeredOnStart: true
                    onTriggered: {
                        var now = new Date()
                        var h = now.getHours()
                        var m = now.getMinutes()
                        var ampm = h >= 12 ? "PM" : "AM"
                        h = h % 12; h = h ? h : 12
                        var ms = m < 10 ? "0" + m : "" + m
                        var days = ["日","月","火","水","木","金","土"]
                        clockDisplay.text = h + ":" + ms + " " + ampm + " • " + (now.getMonth()+1) + "月" + now.getDate() + "日 (" + days[now.getDay()] + ")"
                    }
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
