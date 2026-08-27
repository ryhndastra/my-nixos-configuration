import QtQuick
import QtQuick.Layouts

// Media Player Widget
// Detects any MPRIS player and shows dynamic icon: Spotify, browser, mpv/vlc, etc.
// Shows: [icon] artist — title  [prev] [play/pause] [next]
Item {
    id: root
    property string playerIcon: "󰎆"
    property string playerName: ""
    property bool isPlaying: false
    property string trackTitle: "No Media"
    property string trackArtist: ""

    signal prev()
    signal playPause()
    signal next()

    visible: playerName !== ""
    implicitWidth: mediaRow.implicitWidth + 14
    implicitHeight: 28

    Rectangle {
        anchors.fill: parent
        radius: 7
        color: "#2011111b"
        border.color: "#28a6e3a1"
        border.width: 1
        clip: true

        RowLayout {
            id: mediaRow
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            spacing: 5

            // Player icon (dynamic based on playerName)
            Text {
                Layout.alignment: Qt.AlignVCenter
                text: root.playerIcon
                font.pixelSize: 13
                color: "#a6e3a1"
            }

            // Scrolling track info
            Item {
                Layout.alignment: Qt.AlignVCenter
                Layout.maximumWidth: 160
                Layout.minimumWidth: 60
                height: 18
                clip: true

                Text {
                    id: trackText
                    property string fullText: root.trackArtist !== "" 
                        ? root.trackArtist + " — " + root.trackTitle 
                        : root.trackTitle
                    text: fullText
                    font.pixelSize: 11
                    font.family: "Noto Sans CJK JP"
                    color: "#cdd6f4"
                    anchors.verticalCenter: parent.verticalCenter
                    // Scroll if text overflows
                    SequentialAnimation on x {
                        loops: Animation.Infinite
                        running: trackText.implicitWidth > 160
                        PauseAnimation { duration: 2000 }
                        NumberAnimation { to: -(trackText.implicitWidth - 160 + 10); duration: trackText.implicitWidth * 18; easing.type: Easing.Linear }
                        PauseAnimation { duration: 1500 }
                        NumberAnimation { to: 0; duration: 500 }
                    }
                }
            }

            // Prev
            Text {
                Layout.alignment: Qt.AlignVCenter
                text: "󰒮"
                font.pixelSize: 11
                color: prevMa.containsMouse ? "#ffffff" : "#7f849c"
                MouseArea {
                    id: prevMa
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.prev()
                }
            }

            // Play / Pause
            Text {
                Layout.alignment: Qt.AlignVCenter
                text: root.isPlaying ? "󰏤" : "󰐊"
                font.pixelSize: 13
                color: ppMa.containsMouse ? "#ffffff" : "#a6e3a1"
                MouseArea {
                    id: ppMa
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.playPause()
                }
            }

            // Next
            Text {
                Layout.alignment: Qt.AlignVCenter
                text: "󰒭"
                font.pixelSize: 11
                color: nextMa.containsMouse ? "#ffffff" : "#7f849c"
                MouseArea {
                    id: nextMa
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.next()
                }
            }
        }
    }
}
