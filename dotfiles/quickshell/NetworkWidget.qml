import QtQuick
import QtQuick.Layouts

// Network status widget — shows connection type, speed, and SSID
Item {
    id: root
    property string netType: "ethernet"  // "ethernet"|"wifi"|"none"
    property string netSpeed: "0 KB/s"
    property string netSSID: ""

    implicitWidth: netRow.implicitWidth + 14
    implicitHeight: 28

    Rectangle {
        anchors.fill: parent
        radius: 7
        color: ma.containsMouse ? "#3c313244" : "#2011111b"
        border.color: root.netType === "none" ? "#28f38ba8" : "#2889b4fa"
        border.width: 1
        Behavior on color { ColorAnimation { duration: 120 } }

        Row {
            id: netRow
            anchors.centerIn: parent
            spacing: 4

            // Connection type icon
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.netType === "wifi" ? "󰤨" : root.netType === "ethernet" ? "󰈀" : "󰤭"
                font.pixelSize: 13
                color: root.netType === "none" ? "#f38ba8" : "#89b4fa"
            }

            // Speed or SSID
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.netType === "none" ? "Off" : root.netSpeed
                font.pixelSize: 11
                font.family: "JetBrainsMono Nerd Font"
                color: "#cdd6f4"
            }
        }

        MouseArea {
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: { /* Could open network manager, for now noop */ }
        }
    }
}
