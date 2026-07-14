pragma Singleton
import QtQuick

/**
 * This file contains the main colors for the app.
 * Use Theme.primary, Theme.secondary, etc. for consistent styling.
 */
QtObject {
    /** Primary brand color */
    property color primary: Qt.hsla(191 / 360, 0.75, 0.60, 1.0)

    property color primarylight: Qt.hsla(191 / 360, 0.84, 0.75, 1.0)

    /** Secondary accent color */
    property color secondary: Qt.hsla(191 / 360, 0.84, 0.45, 1.0)

    property color logoContrast: Qt.hsla(186 / 360, 0.84, 0.60, 1.0)

    /** Very light variant */
    property color light: Qt.hsla(191 / 360, 0.84, 0.96, 1.0)

    /** Light‑dark variant */
    property color lightdark: Qt.hsla(191 / 360, 0.20, 0.70, 1.0)

    /** Very light variant */
    property color errorlight: Qt.hsla(0 / 360, 0.84, 0.96, 1.0)

    /** Light‑dark variant */
    property color errorlightdark: Qt.hsla(0 / 360, 0.20, 0.70, 1.0)

    property color errordark: Qt.hsla(0 / 360, 0.40, 0.30, 1.0)

    /** Dark variant */
    property color dark: Qt.hsla(191 / 360, 0.20, 0.20, 1.0)

    /** Holder colors for temporary highlights */
    property color colorholder1: "#ff0000"
    property color colorholder2: "#c70000"

    /** Transparent placeholder */
    property color transparent: "#00000000"
}
