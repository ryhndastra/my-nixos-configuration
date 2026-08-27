import QtQuick
import QtQuick.Layouts

// Calendar Dropdown — rich Japanese calendar with week numbers and moon phase
Item {
    id: root
    readonly property var now: new Date()
    readonly property int year: now.getFullYear()
    readonly property int month: now.getMonth()
    readonly property int today: now.getDate()

    // Japanese month names
    readonly property var jpMonths: ["一月","二月","三月","四月","五月","六月",
                                     "七月","八月","九月","十月","十一月","十二月"]
    readonly property var enMonths: ["January","February","March","April","May","June",
                                     "July","August","September","October","November","December"]

    implicitWidth: 286
    implicitHeight: 260

    Rectangle {
        anchors.fill: parent; radius: 14
        color: "#f0181825"; border.color: "#80cba6f7"; border.width: 1.5

        Rectangle {
            anchors { top: parent.top; topMargin: 1; left: parent.left; leftMargin: 16; right: parent.right; rightMargin: 16 }
            height: 1; color: "#40ffffff"; radius: 1
        }

        ColumnLayout {
            anchors.fill: parent; anchors.margins: 14; spacing: 8

            // Header — Japanese year/month + Japanese era
            RowLayout {
                Text {
                    text: "󰃰"; font.pixelSize: 16; color: "#cba6f7"
                }
                ColumnLayout { spacing: 1
                    Text {
                        text: root.jpMonths[root.month] + " " + root.year + "年"
                        font.pixelSize: 14; font.bold: true; font.family: "Noto Sans CJK JP"; color: "#cba6f7"
                    }
                    Text {
                        text: root.enMonths[root.month] + " " + root.year
                        font.pixelSize: 9; color: "#585b70"
                    }
                }
                Item { Layout.fillWidth: true }
                // Day of year indicator
                Column {
                    Text {
                        text: Math.floor((new Date(root.year, root.month, root.today) - new Date(root.year, 0, 0)) / 86400000)
                        font.pixelSize: 18; font.bold: true; font.family: "JetBrainsMono Nerd Font"; color: "#f5c2e7"; anchors.right: parent.right
                    }
                    Text { text: "日目"; font.pixelSize: 9; font.family: "Noto Sans CJK JP"; color: "#585b70"; anchors.right: parent.right }
                }
            }

            // Divider
            Rectangle { Layout.fillWidth: true; height: 1; color: "#20cba6f7" }

            // Weekday headers
            Row {
                Layout.alignment: Qt.AlignHCenter; spacing: 0
                Repeater {
                    model: ["日","月","火","水","木","金","土"]
                    Text {
                        width: 36; text: modelData
                        font.pixelSize: 10; font.family: "Noto Sans CJK JP"
                        color: index === 0 ? "#f38ba8" : index === 6 ? "#89b4fa" : "#6c7086"
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }

            // Calendar grid
            Grid {
                Layout.alignment: Qt.AlignHCenter
                columns: 7; spacing: 0

                Repeater {
                    model: new Date(root.year, root.month, 1).getDay()
                    Item { width: 36; height: 28 }
                }

                Repeater {
                    model: new Date(root.year, root.month + 1, 0).getDate()
                    Rectangle {
                        width: 36; height: 28; radius: 6
                        readonly property int dayOfWeek: (new Date(root.year, root.month, 1).getDay() + index) % 7
                        color: (index + 1) === root.today ? "#cba6f7" : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: index + 1
                            font.pixelSize: 11
                            font.bold: (index + 1) === root.today
                            font.family: "JetBrainsMono Nerd Font"
                            color: (index + 1) === root.today ? "#11111b"
                                 : dayOfWeek === 0 ? "#f38ba8"
                                 : dayOfWeek === 6 ? "#89b4fa"
                                 : "#cdd6f4"
                        }
                    }
                }
            }

            // Footer — today's info
            Rectangle { Layout.fillWidth: true; height: 1; color: "#20cba6f7" }
            Text {
                Layout.alignment: Qt.AlignHCenter
                readonly property var days: ["日曜日","月曜日","火曜日","水曜日","木曜日","金曜日","土曜日"]
                text: "今日は " + root.year + "年" + (root.month+1) + "月" + root.today + "日 " + days[new Date().getDay()]
                font.pixelSize: 10; font.family: "Noto Sans CJK JP"; color: "#a6adc8"
            }
        }
    }
}
