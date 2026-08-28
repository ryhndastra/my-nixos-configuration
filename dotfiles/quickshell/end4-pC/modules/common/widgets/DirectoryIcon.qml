import QtQuick
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root
    required property var fileModelData
    property size sourceSize: Qt.size(0, 0)

    MaterialSymbol {
        anchors.centerIn: parent
        iconSize: Math.min(parent.width, parent.height) * 0.55
        color: Appearance.colors.colPrimary
        text: {
            const name = fileModelData.fileName.toLowerCase();
            if (name.includes("picture") || name.includes("photo") || name.includes("wall")) return "photo_library";
            if (name.includes("music") || name.includes("audio")) return "library_music";
            if (name.includes("video") || name.includes("movie")) return "movie";
            if (name.includes("download")) return "download";
            if (name.includes("doc")) return "description";
            if (name.includes("desktop")) return "desktop_windows";
            if (name.includes("template")) return "layers";
            if (name.includes("public")) return "public";
            if (name.includes("project") || name.includes("code")) return "code";
            return "folder";
        }
    }
}
