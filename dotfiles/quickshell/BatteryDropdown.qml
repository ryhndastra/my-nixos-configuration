import QtQuick
import QtQuick.Layouts

// Battery Info Dropdown — shows battery level bar, charging status, and icon
Item {
    id: root
    property int batteryPercent: 85
    property bool charging: false

    readonly property string batColor: {
        if (charging) return "#a6e3a1"
        if (batteryPercent <= 15) return "#f38ba8"
        if (batteryPercent <= 30) return "#f9e2af"
        return "#a6e3a1"
    }
    readonly property string bigIcon: {
        if (charging) return "󰂄"
        if (batteryPercent >= 90) return "󰁹"
        if (batteryPercent >= 70) return "󰂀"
        if (batteryPercent >= 50) return "󰁾"
        if (batteryPercent >= 30) return "󰁼"
        return "󰁺"
    }

    implicitWidth: 200
    implicitHeight: 120

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: "#e0181825"
        border.color: Qt.rgba(
            parseInt(root.batColor.slice(1,3),16)/255,
            parseInt(root.batColor.slice(3,5),16)/255,
            parseInt(root.batColor.slice(5,7),16)/255,
            0.6
        )
        border.width: 1.2

        Rectangle {
            anchors { top: parent.top; topMargin: 1; left: parent.left; leftMargin: 14; right: parent.right; rightMargin: 14 }
            height: 1; color: "#30ffffff"; radius: 1
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 10

            // Big battery icon + percent
            RowLayout {
                Text {
                    text: root.bigIcon
                    font.pixelSize: 28
                    color: root.batColor
                }
                ColumnLayout {
                    spacing: 2
                    Text {
                        text: root.batteryPercent + "%"
                        font.pixelSize: 18
                        font.bold: true
                        font.family: "JetBrainsMono Nerd Font"
                        color: root.batColor
                    }
                    Text {
                        text: root.charging ? "Charging" : batteryPercent <= 15 ? "Low Battery!" : "On Battery"
                        font.pixelSize: 10
                        color: "#7f849c"
                    }
                }
            }

            // Battery bar
            Item {
                Layout.fillWidth: true
                height: 8
                Rectangle { anchors.fill: parent; radius: 4; color: "#30313244" }
                Rectangle {
                    width: parent.width * (root.batteryPercent / 100)
                    height: parent.height; radius: 4
                    color: root.batColor
                    Behavior on width { NumberAnimation { duration: 300 } }
                }
            }
        }
    }
}
