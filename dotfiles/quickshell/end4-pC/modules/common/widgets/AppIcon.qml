import QtQuick
import Quickshell.Widgets
import qs.services
import qs.modules.common

IconImage {
    id: root
    
    property real implicitSize: 26
    property bool animated: true
    property bool roundToIconSize: false
    implicitWidth: implicitSize
    implicitHeight: implicitSize
}