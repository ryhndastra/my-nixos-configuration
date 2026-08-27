import QtQuick
import QtQuick.Layouts

// Calendar Dropdown — custom mini calendar, no KDE Calendar app needed
Item {
    id: root

    readonly property var now: new Date()
    readonly property int year: now.getFullYear()
    readonly property int month: now.getMonth()
    readonly property int today: now.getDate()

    implicitWidth: 260
    implicitHeight: 230

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: "#e0181825"
        border.color: "#60cba6f7"
        border.width: 1.2

        // Top specular
        Rectangle {
            anchors { top: parent.top; topMargin: 1; left: parent.left; leftMargin: 14; right: parent.right; rightMargin: 14 }
            height: 1; color: "#30ffffff"; radius: 1
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 8

            // Month & Year Header
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: ["January","February","March","April","May","June","July","August","September","October","November","December"][root.month] + " " + root.year
                font.pixelSize: 13
                font.bold: true
                color: "#cba6f7"
            }

            // Weekday headers
            Row {
                Layout.alignment: Qt.AlignHCenter
                spacing: 0
                Repeater {
                    model: ["Su","Mo","Tu","We","Th","Fr","Sa"]
                    Text {
                        width: 32
                        text: modelData
                        font.pixelSize: 9
                        color: index === 0 || index === 6 ? "#f38ba8" : "#585b70"
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }

            // Calendar grid
            Grid {
                Layout.alignment: Qt.AlignHCenter
                columns: 7
                spacing: 0

                // Leading empty cells
                Repeater {
                    model: new Date(root.year, root.month, 1).getDay()
                    Item { width: 32; height: 26 }
                }

                // Day cells
                Repeater {
                    model: new Date(root.year, root.month + 1, 0).getDate()
                    Rectangle {
                        width: 32
                        height: 26
                        radius: 5
                        color: (index + 1) === root.today ? "#cba6f7" : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: index + 1
                            font.pixelSize: 10
                            font.bold: (index + 1) === root.today
                            color: (index + 1) === root.today ? "#11111b" : "#cdd6f4"
                        }
                    }
                }
            }
        }
    }
}
