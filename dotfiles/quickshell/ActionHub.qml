import QtQuick
import QtQuick.Layouts

// Action Hub — quick launch buttons for common apps
Item {
    id: root
    signal launchKitty()
    signal launchBrowser()
    signal screenshot()
    signal lockScreen()
    signal logout()

    implicitWidth: actRow.implicitWidth + 12
    implicitHeight: 28

    Rectangle {
        anchors.fill: parent
        radius: 7
        color: "#1c11111b"
        border.color: "#20cba6f7"
        border.width: 1

        Row {
            id: actRow
            anchors.centerIn: parent
            spacing: 4

            Repeater {
                model: [
                    { icon: "", color: "#89b4fa", signal: "launchKitty" },
                    { icon: "󰈹", color: "#fab387", signal: "launchBrowser" },
                    { icon: "󰹑", color: "#a6e3a1", signal: "screenshot" },
                    { icon: "󰌾", color: "#f38ba8", signal: "lockScreen" },
                    { icon: "󰐥", color: "#f38ba8", signal: "logout" }
                ]

                Rectangle {
                    width: 20
                    height: 20
                    radius: 5
                    color: btnMa.containsMouse ? Qt.rgba(
                        parseInt(modelData.color.slice(1,3),16)/255,
                        parseInt(modelData.color.slice(3,5),16)/255,
                        parseInt(modelData.color.slice(5,7),16)/255,
                        0.25
                    ) : "transparent"
                    Behavior on color { ColorAnimation { duration: 100 } }

                    Text {
                        anchors.centerIn: parent
                        text: modelData.icon
                        font.pixelSize: 12
                        color: modelData.color
                    }

                    MouseArea {
                        id: btnMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (modelData.signal === "launchKitty") root.launchKitty()
                            else if (modelData.signal === "launchBrowser") root.launchBrowser()
                            else if (modelData.signal === "screenshot") root.screenshot()
                            else if (modelData.signal === "lockScreen") root.lockScreen()
                            else if (modelData.signal === "logout") root.logout()
                        }
                    }
                }
            }
        }
    }
}
