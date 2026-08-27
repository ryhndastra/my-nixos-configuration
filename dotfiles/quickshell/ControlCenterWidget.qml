import QtQuick
import QtQuick.Layouts

// Noctalia Master Control Center Pill Widget on the Bar
Item {
    id: root
    property int volumePercent: 80
    property bool volumeMuted: false
    property int batteryPercent: 85
    property bool batteryCharging: false
    property string netType: "ethernet"
    property bool isOpen: false
    signal clicked()

    implicitWidth: ccRow.implicitWidth + 16
    implicitHeight: 28

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: ma.containsMouse ? "#3c313244" : (root.isOpen ? "#40cba6f7" : "#2011111b")
        border.color: root.isOpen ? "#cba6f7" : "#30cba6f7"
        border.width: 1.2
        Behavior on color { ColorAnimation { duration: 120 } }

        Row {
            id: ccRow
            anchors.centerIn: parent
            spacing: 6

            // Net icon
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.netType === "wifi" ? "󰤨" : (root.netType === "ethernet" ? "󰈀" : "󰤭")
                font.pixelSize: 12
                color: "#89b4fa"
            }

            // Volume icon
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.volumeMuted ? "󰖁" : (root.volumePercent > 60 ? "󰕾" : (root.volumePercent > 20 ? "󰖀" : "󰕿"))
                font.pixelSize: 12
                color: root.volumeMuted ? "#f38ba8" : "#fab387"
            }

            // Battery icon + %
            Row {
                spacing: 3
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.batteryCharging ? "󰂄" : (root.batteryPercent >= 80 ? "󰁹" : (root.batteryPercent >= 40 ? "󰁾" : "󰁺"))
                    font.pixelSize: 12
                    color: root.batteryCharging ? "#a6e3a1" : (root.batteryPercent <= 20 ? "#f38ba8" : "#a6e3a1")
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.batteryPercent + "%"
                    font.pixelSize: 10
                    font.bold: true
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
