import QtQuick
import QtQuick.Layouts

// Battery Dropdown — rich info with bar, charging estimate, Japanese labels
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
    readonly property string statusText: {
        if (charging) return "充電中"
        if (batteryPercent <= 15) return "低バッテリー！"
        if (batteryPercent <= 30) return "バッテリー少"
        return "バッテリー使用中"
    }
    readonly property string statusEn: {
        if (charging) return "Charging"
        if (batteryPercent <= 15) return "Critical"
        if (batteryPercent <= 30) return "Low"
        return "On Battery"
    }

    implicitWidth: 240
    implicitHeight: 185

    Rectangle {
        anchors.fill: parent; radius: 14
        color: "#f0181825"
        border.color: Qt.rgba(
            parseInt(root.batColor.slice(1,3),16)/255,
            parseInt(root.batColor.slice(3,5),16)/255,
            parseInt(root.batColor.slice(5,7),16)/255, 0.7)
        border.width: 1.5

        Rectangle {
            anchors { top: parent.top; topMargin: 1; left: parent.left; leftMargin: 16; right: parent.right; rightMargin: 16 }
            height: 1; color: "#40ffffff"; radius: 1
        }

        ColumnLayout {
            anchors.fill: parent; anchors.margins: 16; spacing: 12

            // Header
            RowLayout {
                Text { text: "󰁹"; font.pixelSize: 16; color: root.batColor }
                ColumnLayout { spacing: 1
                    Text { text: "バッテリー"; font.pixelSize: 12; font.bold: true; font.family: "Noto Sans CJK JP"; color: "#cdd6f4" }
                    Text { text: "Battery"; font.pixelSize: 9; color: "#585b70" }
                }
                Item { Layout.fillWidth: true }
                // Big percent
                Text {
                    text: root.batteryPercent + "%"
                    font.pixelSize: 24; font.bold: true; font.family: "JetBrainsMono Nerd Font"
                    color: root.batColor
                }
            }

            // Status
            Rectangle {
                Layout.fillWidth: true; height: 30; radius: 8
                color: Qt.rgba(
                    parseInt(root.batColor.slice(1,3),16)/255,
                    parseInt(root.batColor.slice(3,5),16)/255,
                    parseInt(root.batColor.slice(5,7),16)/255, 0.12)
                border.color: Qt.rgba(
                    parseInt(root.batColor.slice(1,3),16)/255,
                    parseInt(root.batColor.slice(3,5),16)/255,
                    parseInt(root.batColor.slice(5,7),16)/255, 0.3)
                border.width: 1

                RowLayout {
                    anchors.fill: parent; anchors.leftMargin: 10; anchors.rightMargin: 10
                    Text { text: root.bigIcon; font.pixelSize: 18; color: root.batColor }
                    Text { text: root.statusText; font.pixelSize: 11; font.family: "Noto Sans CJK JP"; color: root.batColor }
                    Item { Layout.fillWidth: true }
                    Text { text: root.statusEn; font.pixelSize: 10; color: "#7f849c" }
                }
            }

            // Battery level bar (segmented style)
            Item {
                Layout.fillWidth: true; height: 16

                Row {
                    anchors.fill: parent; spacing: 2
                    Repeater {
                        model: 10
                        Rectangle {
                            width: (parent.parent.width - 18) / 10; height: parent.parent.height; radius: 3
                            color: (index * 10) < root.batteryPercent
                                ? Qt.rgba(
                                    parseInt(root.batColor.slice(1,3),16)/255,
                                    parseInt(root.batColor.slice(3,5),16)/255,
                                    parseInt(root.batColor.slice(5,7),16)/255, 1)
                                : "#20313244"
                        }
                    }
                }
            }

            // Power profile buttons
            RowLayout {
                Layout.fillWidth: true; spacing: 6
                Repeater {
                    model: [
                        { icon: "󰌪", label: "省電力", profile: "power-saver" },
                        { icon: "󰾅", label: "バランス", profile: "balanced" },
                        { icon: "󰓅", label: "性能", profile: "performance" }
                    ]
                    Rectangle {
                        Layout.fillWidth: true; height: 28; radius: 7
                        color: profMa.containsMouse ? "#30cba6f7" : "#20313244"
                        border.color: profMa.containsMouse ? "#cba6f7" : "#20585b70"; border.width: 1
                        Column {
                            anchors.centerIn: parent; spacing: 0
                            Text { text: modelData.icon; font.pixelSize: 10; color: "#cba6f7"; anchors.horizontalCenter: parent.horizontalCenter }
                            Text { text: modelData.label; font.pixelSize: 8; font.family: "Noto Sans CJK JP"; color: "#7f849c"; anchors.horizontalCenter: parent.horizontalCenter }
                        }
                        MouseArea { id: profMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                            onClicked: Quickshell.execDetached(["powerprofilesctl", "set", modelData.profile]) }
                    }
                }
            }
        }
    }
}
