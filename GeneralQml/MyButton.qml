import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

Item {
    id: root

    /** Margin around the Text content */
    property real p_Margins: 16
    property real p_VMargins: p_Margins
    property real p_HMargins:  p_Margins
    /** Border thickness in pixels */
    property real p_borderSize: 0
    /** Corner radius for rounded borders/backgrounds */
    property real p_radius: 0

    property real p_shadowOpacity: 1

    /** Font size for input text */
    property int p_fontSize: 16

    /** Background fill color */
    property color p_mainColor: "white"
    /** Border color */
    property color p_borderColor: "black"
    /** Color of optional text border rectangle */
    property color p_textBorderColor: "yellow"
    /** Text color for input content */
    property color p_textColor: "black"

    property color p_gradientTopColor: "green"

    property color p_gradientBottomColor: "blue"

    property color p_shadowColor: "black"

    /** Whether to load the background rectangle */
    property bool p_loadBackgroundRect: true
    /** Show a border around the text content if true */
    property bool p_showTextBorder: false

    property bool p_gradientButton: false

    property bool p_shadowEnabled: false

    /** Bold font for input text */
    property bool p_fontBold: false
    /** Italic font for input text */
    property bool p_fontItalic: false
    /** Underlined font for input text */
    property bool p_underline: false

    property bool p_mouseAreaEnabled: true

    /** Font family list for input text */
    property string p_fontName: "Roboto,Segoe UI,San Francisco,DejaVu Sans"
    property string p_text: "Place Holder"

    /** Horizontal alignment for text (left, right, center, justify) */
    property int p_horizontalAlign: Text.AlignLeft

    signal clicked()
    signal hovered()
    signal pressed()
    signal released()
    signal exited()

    // Height is based on implicit text height plus margins
    height: buttonText.implicitHeight + (p_VMargins * 2)
    width: buttonText.implicitWidth + (p_HMargins * 2)


    Loader{
        id: shadowLoader
        anchors.fill: parent
        active: p_shadowEnabled
        sourceComponent: RectangularShadow{
            anchors.fill: parent
            radius: p_radius
            opacity: p_shadowOpacity
            color: p_shadowColor
            anchors.margins: 1
            offset:  Qt.vector2d(1,1)
        }
    }

    /** Loader for border rectangle (optional, controlled by p_borderSize) */
    Loader {
        id: borderLoader
        anchors.fill: parent
        active: p_borderSize > 0 && p_loadBackgroundRect && !p_gradientButton
        sourceComponent: Rectangle {
            anchors.fill: parent
            color: p_borderColor
            radius: p_radius
        }
    }

    /** Loader for background rectangle (optional, controlled by p_loadBackgroundRect) */
    Loader {
        id: rectangleLoader
        anchors.fill: parent
        active: p_loadBackgroundRect && !p_gradientButton
        sourceComponent: Rectangle {
            anchors.fill: parent
            anchors.margins: p_borderSize
            color: p_mainColor
            radius: p_radius - p_borderSize
        }
    }

    Loader {
        id: gradientRectangleLoader
        anchors.fill: parent
        active: p_gradientButton
        sourceComponent: Item{

            Loader{
                id: gradientRectangleBorderLoader
                active: p_borderSize > 0
                anchors.fill: parent
                sourceComponent: Rectangle{
                    anchors.fill: parent
                    color: p_borderColor
                    radius: p_radius
                }
            }

            id: gradientRectangle
            anchors.fill: parent

            Shape {
                id: rectangleShape
                anchors.fill: parent
                anchors.margins: p_borderSize
                layer.enabled: true
                layer.samples: 6

                ShapePath {
                    strokeWidth: 0
                    fillGradient: LinearGradient {
                        x1: 0; y1: rectangleShape.height
                        x2: rectangleShape.width; y2: 0
                        GradientStop { position: 0; color: p_gradientBottomColor}
                        GradientStop { position: 1; color: p_gradientTopColor}
                    }

                    PathRectangle {
                        id: rectangleShapePath
                        x: 0; y: 0
                        width: rectangleShape.width
                        height: rectangleShape.height
                        radius: p_radius - p_borderSize
                    }
                }
            }
        }
    }

    Text {
        id: buttonText
        text: p_text

        anchors.fill: parent
        anchors.topMargin: p_VMargins
        anchors.bottomMargin: p_VMargins
        anchors.rightMargin: p_HMargins
        anchors.leftMargin: p_HMargins

        font.pixelSize: p_fontSize
        font.family: p_fontName
        color: p_textColor
        horizontalAlignment: p_horizontalAlign

        font.bold: p_fontBold
        font.italic: p_fontItalic
        font.underline: p_underline

        Loader {
            id: textBorderLoader
            active: p_showTextBorder
            anchors.fill: parent
            sourceComponent: Rectangle {
                anchors.fill: parent
                border.color: p_textBorderColor
                border.width: 2
                color: "transparent"
            }
        }
    }

    transform: Scale{
        id: rootScale
        origin.x: root.width/2
        origin.y: root.height/2
        xScale: 1
        yScale: 1
    }

    /** MouseArea to emit button signals */
    MouseArea {
        id: mouseArea
        enabled: p_mouseAreaEnabled
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            root.focus = true
            root.clicked()
        }
        onPressed: {
            rootScale.xScale = 0.95
            rootScale.yScale = 0.95
            root.pressed()
        }
        onReleased: {
            rootScale.xScale = 1
            rootScale.yScale = 1
            root.released()
        }
        onEntered: {
            rootScale.xScale = 0.95
            rootScale.yScale = 0.95
            root.hovered()
        }
        onExited: {
            rootScale.xScale = 1
            rootScale.yScale = 1
            root.exited()
        }
    }

}
