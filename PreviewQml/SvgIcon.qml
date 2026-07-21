import QtQuick

Item {
    id: root
    property string source: ""
    property color svgFillColor: "transparent"
    property real svgStrokeWidth: 0
    property color svgStrokeColor: "transparent"
    property var svgFillLinearGradient: ({})
    property var svgStrokeLinearGradient: ({})

    Rectangle {
        anchors.fill: parent
        anchors.margins: 20

        color: root.svgFillColor
        border.width: root.svgStrokeWidth
        border.color: root.svgStrokeColor
    }
}
