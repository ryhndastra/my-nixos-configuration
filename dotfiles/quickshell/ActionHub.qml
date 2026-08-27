import QtQuick
import QtQuick.Layouts

// Action Hub — quick launch buttons and power menu trigger
Item {
    id: root
    signal launchKitty()
    signal launchBrowser()
    signal screenshot()
    signal lockScreen()
    signal powerMenu()   // triggers centered power menu overlay

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
            spacing: 5

            Repeater {
                model: [
                    // Kitty uses the cat icon (nerd font)
                    { icon: "󰄛", color: "#89b4fa",  sig: "kitty"   },
                    { icon: "󰈹", color: "#fab387", sig: "browser"  },
                    { icon: "󰹑", color: "#a6e3a1", sig: "shot"     },
                    { icon: "󰌾", color: "#f38ba8", sig: "lock"     },
                    { icon: "󰐥", color: "#cba6f7", sig: "power"    }
                ]

                Rectangle {
                    width: 22; height: 22; radius: 5
                    color: btnMa.containsMouse ? Qt.rgba(
                        parseInt(modelData.color.slice(1,3),16)/255,
                        parseInt(modelData.color.slice(3,5),16)/255,
                        parseInt(modelData.color.slice(5,7),16)/255, 0.28) : "transparent"
                    Behavior on color { ColorAnimation { duration: 100 } }

                    Text {
                        anchors.centerIn: parent
                        text: modelData.icon; font.pixelSize: 13
                        color: modelData.color
                    }

                    MouseArea {
                        id: btnMa; anchors.fill: parent; hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if      (modelData.sig === "kitty")   root.launchKitty()
                            else if (modelData.sig === "browser") root.launchBrowser()
                            else if (modelData.sig === "shot")    root.screenshot()
                            else if (modelData.sig === "lock")    root.lockScreen()
                            else if (modelData.sig === "power")   root.powerMenu()
                        }
                    }
                }
            }
        }
    }
}
