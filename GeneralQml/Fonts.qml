pragma Singleton
import QtQuick

QtObject {
    property FontLoader lexend: FontLoader {
        property bool isDev: Qt.application.arguments.indexOf("--qmlpreview") !== -1
        property string path: "/Fonts/Lexend-VariableFont_wght.ttf"
        source: isDev ? "file:." + path : "qrc:" + path
    }
}
