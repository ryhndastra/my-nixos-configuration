import QtQuick
import QtQuick.Layouts

// Volume Dropdown — interactive draggable slider, mute, Japanese labels
Item {
    id: root
    property int volumePercent: 80
    property bool muted: false
    signal volumeChange(int pct)
    signal muteToggle()

    implicitWidth: 240
    implicitHeight: 140

    Rectangle {
        anchors.fill: parent
        radius: 14
        color: "#f0181825"
        border.color: "#80fab387"; border.width: 1.5

        Rectangle {
            anchors { top: parent.top; topMargin: 1; left: parent.left; leftMargin: 16; right: parent.right; rightMargin: 16 }
            height: 1; color: "#40ffffff"; radius: 1
        }

        ColumnLayout {
            anchors.fill: parent; anchors.margins: 16; spacing: 10

            // Header row
            RowLayout {
                Text { text: root.muted ? "󰖁" : root.volumePercent > 60 ? "󰕾" : root.volumePercent > 20 ? "󰖀" : "󰕿"
                    font.pixelSize: 18; color: root.muted ? "#f38ba8" : "#fab387" }
                ColumnLayout { spacing: 1
                    Text { text: "音量"; font.pixelSize: 12; font.bold: true; font.family: "Noto Sans CJK JP"; color: "#cdd6f4" }
                    Text { text: "Volume"; font.pixelSize: 9; color: "#585b70" }
                }
                Item { Layout.fillWidth: true }
                Text {
                    text: root.muted ? "消音" : root.volumePercent + "%"
                    font.pixelSize: 16; font.bold: true; font.family: "JetBrainsMono Nerd Font"
                    color: root.muted ? "#f38ba8" : "#fab387"
                }
            }

            // Draggable slider
            Item {
                id: sliderTrack
                Layout.fillWidth: true; height: 12

                // Track background
                Rectangle { anchors.fill: parent; radius: 6; color: "#30313244" }

                // Fill bar
                Rectangle {
                    width: Math.max(12, sliderTrack.width * Math.min(root.volumePercent / 100, 1))
                    height: parent.height; radius: 6
                    color: root.muted ? "#80f38ba8" : "#fab387"
                    Behavior on width { NumberAnimation { duration: 80 } }

                    // Thumb knob
                    Rectangle {
                        anchors { right: parent.right; verticalCenter: parent.verticalCenter }
                        width: 14; height: 14; radius: 7
                        color: "#ffffff"
                        border.color: root.muted ? "#f38ba8" : "#fab387"; border.width: 2
                    }
                }

                // Drag interaction
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.SizeHorCursor
                    onPositionChanged: (mouse) => {
                        if (mouse.buttons & Qt.LeftButton) {
                            var pct = Math.round(Math.max(0, Math.min(100, mouse.x / sliderTrack.width * 100)))
                            root.volumeChange(pct)
                        }
                    }
                    onPressed: (mouse) => {
                        var pct = Math.round(Math.max(0, Math.min(100, mouse.x / sliderTrack.width * 100)))
                        root.volumeChange(pct)
                    }
                    onWheel: (wheel) => {
                        var pct = Math.max(0, Math.min(100, root.volumePercent + (wheel.angleDelta.y > 0 ? 5 : -5)))
                        root.volumeChange(pct)
                    }
                }
            }

            // Mute toggle
            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                width: 110; height: 26; radius: 8
                color: muteMa.containsMouse ? "#30f38ba8" : "#20313244"
                border.color: root.muted ? "#f38ba8" : "#30585b70"; border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: root.muted ? "󰕾  ミュート解除" : "󰖁  ミュート"
                    font.pixelSize: 10; font.family: "Noto Sans CJK JP"
                    color: root.muted ? "#f38ba8" : "#7f849c"
                }
                MouseArea { id: muteMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.muteToggle() }
            }
        }
    }
}
