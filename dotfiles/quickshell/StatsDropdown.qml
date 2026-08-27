import QtQuick
import QtQuick.Layouts

// System Stats Dropdown — shows CPU and RAM usage bars in detail
Item {
    id: root
    property int cpuPercent: 0
    property string ramText: "--"
    property int ramUsedMB: 0
    property int ramTotalMB: 24000

    implicitWidth: 240
    implicitHeight: 140

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: "#e0181825"
        border.color: "#6089dceb"
        border.width: 1.2

        Rectangle {
            anchors { top: parent.top; topMargin: 1; left: parent.left; leftMargin: 14; right: parent.right; rightMargin: 14 }
            height: 1; color: "#30ffffff"; radius: 1
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            // Header
            Text {
                text: "󰓅  System Resources"
                font.pixelSize: 12
                font.bold: true
                color: "#89dceb"
            }

            // CPU bar
            ColumnLayout {
                spacing: 4
                RowLayout {
                    Text { text: "󰻠  CPU"; font.pixelSize: 11; color: "#cdd6f4" }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: root.cpuPercent + "%"
                        font.pixelSize: 11
                        font.family: "JetBrainsMono Nerd Font"
                        color: root.cpuPercent > 80 ? "#f38ba8" : root.cpuPercent > 50 ? "#f9e2af" : "#a6e3a1"
                    }
                }
                Item {
                    Layout.fillWidth: true
                    height: 6
                    Rectangle { anchors.fill: parent; radius: 3; color: "#30313244" }
                    Rectangle {
                        width: parent.width * (root.cpuPercent / 100)
                        height: parent.height; radius: 3
                        color: root.cpuPercent > 80 ? "#f38ba8" : root.cpuPercent > 50 ? "#f9e2af" : "#a6e3a1"
                        Behavior on width { NumberAnimation { duration: 300 } }
                    }
                }
            }

            // RAM bar
            ColumnLayout {
                spacing: 4
                RowLayout {
                    Text { text: "󰍛  RAM"; font.pixelSize: 11; color: "#cdd6f4" }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: root.ramText
                        font.pixelSize: 11
                        font.family: "JetBrainsMono Nerd Font"
                        color: "#89dceb"
                    }
                }
                Item {
                    Layout.fillWidth: true
                    height: 6
                    Rectangle { anchors.fill: parent; radius: 3; color: "#30313244" }
                    Rectangle {
                        width: parent.width * Math.min(root.ramUsedMB / Math.max(root.ramTotalMB, 1), 1)
                        height: parent.height; radius: 3; color: "#89dceb"
                        Behavior on width { NumberAnimation { duration: 300 } }
                    }
                }
            }
        }
    }
}
