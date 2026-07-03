import QtQuick

/**
 * Custom input component with configurable margins, borders, colors,
 * placeholder text, and font styling.
 *
 * Features:
 * - Optional border and background rectangles
 * - Customizable font family, size, bold/italic/underline
 * - Placeholder text with independent styling
 * - Optional text border highlight
 * - Validators to restrict spaces in input
 */
Item {
    id: root

    /** Margin around the TextInput content */
    property real p_margins: 16
    /** Border thickness in pixels */
    property real p_borderSize: 0
    /** Corner radius for rounded borders/backgrounds */
    property real p_radius: 0
    /** Warning time (ms) for validation feedback, if used externally */
    property real p_warningTime: 250

    /** Font size for input and placeholder text */
    property int p_fontSize: 16

    /** Background fill color */
    property color p_mainColor: "white"
    /** Border color */
    property color p_borderColor: "black"
    /** Border color when in warning state */
    property color p_warningBorderColor: "#c70000"
    /** Background color when in warning state */
    property color p_warningColor: "#fffafa"
    /** Color of optional text border rectangle */
    property color p_textBorderColor: "yellow"
    /** Text color for input content */
    property color p_textColor: "black"
    /** Placeholder text color */
    property color p_placeHolderColor: "gray"

    /** Whether to load the background rectangle */
    property bool p_loadBackgroundRect: true
    /** Show a border around the text content if true */
    property bool p_showTextBorder: false
    /** Bold font for input text */
    property bool p_fontBold: false
    /** Italic font for input text */
    property bool p_fontItalic: false
    /** Underlined font for input text */
    property bool p_underline: false
    /** Bold font for placeholder text */
    property bool p_placeHolderBold: false
    /** Italic font for placeholder text */
    property bool p_placeHolderItalic: true
    /** Underlined font for placeholder text */
    property bool p_placeHolderUnderline: false
    /** Enable placeholder rendering if true */
    property bool p_placeHolderEnabled: true

    property bool p_isPassword: false

    /** Font family list for input and placeholder */
    property string p_fontName: "Roboto,Segoe UI,San Francisco,DejaVu Sans"
    /** Placeholder text string */
    property string p_placeHolderText: "Place Holder Text"

    /** Horizontal alignment for text (left, right, center, justify) */
    property int p_horizontalAlign: Text.AlignLeft

    property RegularExpressionValidator p_activeValidator: noSpaceStart

    signal focused

    // Height is based on implicit input height plus margins
    height: input.implicitHeight + (p_margins * 2)
    implicitHeight: input.implicitHeight + (p_margins * 2)

    /** Loader for border rectangle (optional, controlled by p_borderSize) */
    Loader {
        id: borderLoader
        anchors.fill: parent
        active: p_borderSize > 0 && p_loadBackgroundRect
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
        active: p_loadBackgroundRect
        sourceComponent: Rectangle {
            anchors.fill: parent
            anchors.margins: p_borderSize
            color: p_mainColor
            radius: p_radius - p_borderSize
        }
    }

    /** Main text input field */
    TextInput {
        id: input
        anchors.fill: parent
        anchors.margins: p_margins

        clip: true
        font.pixelSize: p_fontSize
        font.family: p_fontName
        color: p_textColor
        horizontalAlignment: p_horizontalAlign

        // Choose validator depending on space rules
        validator: p_activeValidator

        echoMode: p_isPassword ? TextInput.Password : TextInput.Normal

        font.bold: p_fontBold
        font.italic: p_fontItalic
        font.underline: p_underline

        /** Loader for placeholder text (shown when empty, not focused
            and place holder enabled) */
        Loader {
            id: placeHolderLoader
            anchors.fill: parent
            active: input.text === "" && !input.activeFocus && p_placeHolderEnabled
            sourceComponent: Text {
                anchors.fill: parent
                font.pixelSize: p_fontSize
                font.family: p_fontName
                text: p_placeHolderText
                color: p_placeHolderColor
                font.bold: p_placeHolderBold
                font.italic: p_placeHolderItalic
                font.underline: p_placeHolderUnderline
                horizontalAlignment: p_horizontalAlign
            }
        }

        /** Loader for optional text border highlight */
        Loader {
            id: textBorderLoader
            active: p_showTextBorder
            anchors.fill: parent
            sourceComponent: Rectangle {
                anchors.fill: parent
                border.color: p_textBorderColor
                border.width: 2
                color: colors.transparent
            }
        }
    }

    /** MouseArea to focus the text input when clicked */
    MouseArea {
        anchors.fill: parent
        anchors.margins: p_borderSize
        onClicked: {
            input.forceActiveFocus();
            root.focused();
        }
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

    property alias text: input.text
    property alias noSpaces: noSpaces
    property alias noSpaceStart: noSpaceStart
    property alias onlyNumbers: onlyNumbers
}
