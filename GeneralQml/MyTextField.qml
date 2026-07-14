pragma ComponentBehavior: Bound
import QtQuick

MyRectangle {
    id: root

    clip: true
    property string p_placeHolderText: "Place Holder"
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
    property var p_activeValidator: noSpaceStart
    property bool p_isPassword: false
    property color p_placeHolderColor: "gray"
    property bool p_placeHolderBold: false
    property bool p_placeHolderItalic: false
    property bool p_placeHolderUnderline: false
    property int p_textVerticalAlign: Text.AlignVCenter
    property bool p_placeHolderActive: textInput.text === "" && !textInput.activeFocus && root.p_placeHolderText != ""

    signal focused

    height: (p_placeHolderActive ? placeHolderLoader.implicitHeight : textInput.implicitHeight) + (p_textMarginsV * 2) + root.borderMargin(0) + root.borderMargin(1)
    width: (p_placeHolderActive ? placeHolderLoader.implicitWidth : textInput.implicitWidth) + (p_textMarginsH * 2) + root.borderMargin(2) + root.borderMargin(3)

    implicitHeight: (p_placeHolderActive ? placeHolderLoader.implicitHeight : textInput.implicitHeight) + (p_textMarginsV * 2) + root.borderMargin(0) + root.borderMargin(1)
    implicitWidth: (p_placeHolderActive ? placeHolderLoader.implicitWidth : textInput.implicitWidth) + (p_textMarginsH * 2) + root.borderMargin(2) + root.borderMargin(3)

    TextInput {
        id: textInput

        z: 2
        anchors.fill: parent
        anchors.topMargin: root.p_textMarginsV + root.borderMargin(0)
        anchors.bottomMargin: root.p_textMarginsV + root.borderMargin(1)
        anchors.leftMargin: root.p_textMarginsH + root.borderMargin(2)
        anchors.rightMargin: root.p_textMarginsH + root.borderMargin(3)

        font.pixelSize: root.p_textSize
        font.family: root.p_textFontName
        color: root.p_textColor
        horizontalAlignment: root.p_textAlign
        verticalAlignment: root.p_textVerticalAlign

        font.bold: root.p_textBold
        font.italic: root.p_textItalic
        font.underline: root.p_textUnderline
        wrapMode: root.p_textWrap

        validator: root.p_activeValidator
        echoMode: root.p_isPassword ? TextInput.Password : TextInput.Normal

        Loader {
            id: placeHolderLoader

            anchors.fill: parent
            active: root.p_placeHolderActive

            sourceComponent: Text {
                anchors.fill: parent

                text: root.p_placeHolderText

                font.pixelSize: root.p_textSize
                font.family: root.p_textFontName
                color: root.p_placeHolderColor

                font.bold: root.p_placeHolderBold
                font.italic: root.p_placeHolderItalic
                font.underline: root.p_placeHolderUnderline

                horizontalAlignment: root.p_textAlign
                verticalAlignment: root.p_textVerticalAlign
                wrapMode: root.p_textWrap
            }
        }

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

    onClicked: {
        textInput.forceActiveFocus();
    }

    /** Validator: disallow all spaces */
    RegularExpressionValidator {
        id: noSpaces
        regularExpression: /^\S*$/
    }

    /** Validator: disallow leading spaces */
    RegularExpressionValidator {
        id: noSpaceStart
        regularExpression: /^\S.*$/
    }

    RegularExpressionValidator {
        id: onlyNumbers
        regularExpression: /^[0-9]+$/
    }

    property alias text: textInput.text
    property alias noSpaces: noSpaces
    property alias noSpaceStart: noSpaceStart
    property alias onlyNumbers: onlyNumbers
}
