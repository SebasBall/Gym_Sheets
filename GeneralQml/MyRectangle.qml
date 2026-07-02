pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

Item {
    id: root

    property real p_borderSize: 0
    property real p_radius: 0

    property real p_Margins: 16
    property real p_VMargins: p_Margins
    property real p_HMargins: p_Margins

    property real p_shadowOpacity: 1
    property real p_shadowSpread: 1
    property real p_shadowBlur: 1

    property int p_fontSize: 16

    property int p_horizontalAlign: Text.AlignLeft

    property bool p_gradientEnabled: false
    /** Bold font for input text */
    property bool p_fontBold: false
    /** Italic font for input text */
    property bool p_fontItalic: false
    /** Underlined font for input text */
    property bool p_underline: false

    property bool p_showTextBorder: false

    property bool p_textEnabled: true

    property bool p_rectangleEnabled: true

    property bool p_shadowEnabled: false

    property color p_borderColor: "black"
    property color p_gradientBottom: "green"
    property color p_gradientTop: "green"
    property color p_rectangleColor: "white"
    property color p_textColor: "black"
    property color p_textBorderColor: "yellow"

    property color p_shadowColor: "black"

    property string p_text: "Place Holder"
    property string p_fontName: "Roboto,Segoe UI,San Francisco,DejaVu Sans"

    height: textLoader.implicitHeight + (p_VMargins * 2)
    width: textLoader.implicitWidth + (p_HMargins * 2)

    implicitHeight: textLoader.implicitHeight + (p_VMargins * 2)
    implicitWidth: textLoader.implicitWidth + (p_HMargins * 2)

    Loader {
        id: shadowLoader
        anchors.fill: parent
        active: root.p_shadowEnabled
        sourceComponent: RectangularShadow {
            anchors.fill: parent
            radius: root.p_radius
            opacity: root.p_shadowOpacity
            color: root.p_shadowColor
            spread: root.p_shadowSpread
            blur: root.p_shadowBlur
        }
    }

    Loader {
        id: borderLoader
        active: root.p_borderSize > 0
        anchors.fill: parent

        sourceComponent: Rectangle {
            anchors.fill: parent
            color: root.p_borderColor
            radius: root.p_radius
        }
    }

    Loader {
        active: root.p_rectangleEnabled
        anchors.fill: parent
        sourceComponent: Item {

            anchors.fill: parent
            Shape {
                id: rectangleShape
                anchors.fill: parent
                anchors.margins: root.p_borderSize
                layer.enabled: true
                layer.samples: 6

                ShapePath {
                    strokeWidth: 0

                    fillColor: !root.p_gradientEnabled ? root.p_rectangleColor : null
                    fillGradient: root.p_gradientEnabled ? linearGradient : null

                    PathRectangle {
                        id: rectangleShapePath
                        x: 0
                        y: 0
                        width: rectangleShape.width
                        height: rectangleShape.height
                        radius: root.p_radius - root.p_borderSize
                    }
                }
            }

            LinearGradient {
                id: linearGradient

                x1: 0
                y1: rectangleShape.height
                x2: rectangleShape.width
                y2: 0

                GradientStop {
                    position: 0
                    color: root.p_gradientBottom
                }

                GradientStop {
                    position: 1
                    color: root.p_gradientTop
                }
            }
        }
    }

    Loader {
        id: textLoader
        active: root.p_textEnabled
        anchors.fill: parent
        anchors.topMargin: root.p_VMargins
        anchors.bottomMargin: root.p_VMargins
        anchors.rightMargin: root.p_HMargins
        anchors.leftMargin: root.p_HMargins
        sourceComponent: Text {
            text: root.p_text

            font.pixelSize: root.p_fontSize
            font.family: root.p_fontName
            color: root.p_textColor
            horizontalAlignment: root.p_horizontalAlign

            font.bold: root.p_fontBold
            font.italic: root.p_fontItalic
            font.underline: root.p_underline
            wrapMode: Text.WrapAnywhere

            Loader {
                id: textBorderLoader
                active: root.p_showTextBorder
                anchors.fill: parent
                sourceComponent: Rectangle {
                    anchors.fill: parent
                    border.color: root.p_textBorderColor
                    border.width: 2
                    color: "transparent"
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.forceActiveFocus();
        }
    }
}
