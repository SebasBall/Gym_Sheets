pragma ComponentBehavior: Bound
import QtQuick

MyRectangle {
    id: root

    property string p_text: "Place Holder"
    property real p_textMargins: 16
    property real p_textMarginsV: p_textMargins
    property real p_textMarginsH: p_textMargins
    property int p_textSize: 16
    property bool p_textBold: false
    property bool p_textItalic: false
    property bool p_textUnderline: false
    property string p_textFontName: "Roboto,Segoe UI,San Francisco,DejaVu Sans"
    property color p_textColor: "black"
    property int p_textAlign: Text.AlignLeft
    property bool p_showTextBorder: false
    property int p_textWrap: Text.Wrap
    property int p_textVerticalAlign: Text.AlignVCenter

    height: text.implicitHeight + (p_textMarginsV * 2) + root.borderMargin(0) + root.borderMargin(1)
    width: text.implicitWidth + (p_textMarginsH * 2) + root.borderMargin(2) + root.borderMargin(3)

    implicitHeight: text.implicitHeight + (p_textMarginsV * 2) + root.borderMargin(0) + root.borderMargin(1)
    implicitWidth: text.implicitWidth + (p_textMarginsH * 2) + root.borderMargin(2) + root.borderMargin(3)

    Text {
        id: text

        z: 2
        anchors.fill: parent
        anchors.topMargin: root.p_textMarginsV + root.borderMargin(0)
        anchors.bottomMargin: root.p_textMarginsV + root.borderMargin(1)
        anchors.leftMargin: root.p_textMarginsH + root.borderMargin(2)
        anchors.rightMargin: root.p_textMarginsH + root.borderMargin(3)
        text: root.p_text

        font.pixelSize: root.p_textSize
        font.family: root.p_textFontName
        color: root.p_textColor
        horizontalAlignment: root.p_textAlign
        verticalAlignment: root.p_textVerticalAlign

        font.bold: root.p_textBold
        font.italic: root.p_textItalic
        font.underline: root.p_textUnderline
        wrapMode: root.p_textWrap

        Loader {
            id: textBorderLoader
            active: root.p_showTextBorder
            anchors.fill: parent
            sourceComponent: Rectangle {
                anchors.fill: parent
                border.color: "red"
                border.width: 2
                color: "transparent"
            }
        }
    }
}
