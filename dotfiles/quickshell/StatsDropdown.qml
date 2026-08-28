import QtQuick
import QtQuick.Layouts
import Quickshell

// Stats Dropdown — rich CPU/RAM display with bars, Japanese labels
Item {
    id: root
    property int cpuPercent: 0
    property int ramPercent: 0
    property string ramDetail: "--"

    implicitWidth: 260
    implicitHeight: 178

    Rectangle {
        anchors.fill: parent; radius: 14
        color: "#f0181825"; border.color: "#8089dceb"; border.width: 1.5

        Rectangle {
            anchors { top: parent.top; topMargin: 1; left: parent.left; leftMargin: 16; right: parent.right; rightMargin: 16 }
            height: 1; color: "#40ffffff"; radius: 1
        }

        ColumnLayout {
            anchors.fill: parent; anchors.margins: 16; spacing: 12

            // Header
            RowLayout {
                Text { text: "󰓅"; font.pixelSize: 16; color: "#89dceb" }
                ColumnLayout { spacing: 1
                    Text { text: "システム監視"; font.pixelSize: 12; font.bold: true; font.family: "Noto Sans CJK JP"; color: "#cdd6f4" }
                    Text { text: "System Monitor"; font.pixelSize: 9; color: "#585b70" }
                }
            }

            // CPU section
            ColumnLayout { spacing: 5
                RowLayout {
                    Text { text: "󰻠  プロセッサ"; font.pixelSize: 11; font.family: "Noto Sans CJK JP"; color: "#cdd6f4" }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: root.cpuPercent + "%"
                        font.pixelSize: 13; font.bold: true; font.family: "JetBrainsMono Nerd Font"
                        color: root.cpuPercent > 80 ? "#f38ba8" : root.cpuPercent > 50 ? "#f9e2af" : "#a6e3a1"
                    }
                }
                Item { Layout.fillWidth: true; height: 8
                    Rectangle { anchors.fill: parent; radius: 4; color: "#30313244" }
                    Rectangle {
                        width: parent.width * (root.cpuPercent / 100); height: parent.height; radius: 4
                        color: root.cpuPercent > 80 ? "#f38ba8" : root.cpuPercent > 50 ? "#f9e2af" : "#a6e3a1"
                        Behavior on width { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
                    }
                }
            }

            // RAM section
            ColumnLayout { spacing: 5
                RowLayout {
                    Text { text: "󰍛  メモリ"; font.pixelSize: 11; font.family: "Noto Sans CJK JP"; color: "#cdd6f4" }
                    Item { Layout.fillWidth: true }
                    Column {
                        Text { text: root.ramPercent + "%"; font.pixelSize: 13; font.bold: true; font.family: "JetBrainsMono Nerd Font"; color: "#89dceb"; horizontalAlignment: Text.AlignRight; anchors.right: parent.right }
                        Text { text: root.ramDetail; font.pixelSize: 8; color: "#585b70"; anchors.right: parent.right }
                    }
                }
                Item { Layout.fillWidth: true; height: 8
                    Rectangle { anchors.fill: parent; radius: 4; color: "#30313244" }
                    Rectangle {
                        width: parent.width * (root.ramPercent / 100); height: parent.height; radius: 4; color: "#89dceb"
                        Behavior on width { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
                    }
                }
            }

            // Open monitor button
            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                width: 140; height: 26; radius: 8
                color: monMa.containsMouse ? "#3089dceb" : "#20313244"
                border.color: monMa.containsMouse ? "#89dceb" : "#30585b70"; border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "󰓅  システム監視を開く"
                    font.pixelSize: 10; font.family: "Noto Sans CJK JP"; color: "#89dceb"
                }
                MouseArea { id: monMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                    onClicked: Quickshell.execDetached(["plasma-systemmonitor"]) }
            }
        }
    }
}
