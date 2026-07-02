import QtQuick

/**
 * Item container that defines a layout with colored bars
 * on all four sides (top, bottom, left, right).
 * Bars are loaded dynamically via Loader components so they
 * can be toggled on/off with the `loadRectangles` property.
 * The objective of this root container is to be an anchor
 * of different elements of the application
 */
Item {
    id: root

    /** Primary color used for most bars */
    property color color1: "red"

    /** Secondary color used for alternate bars */
    property color color2: "green"

    /** Controls whether the bar rectangles are loaded */
    property bool loadRectangles: true

    /** Left vertical bar, 32px wide */
    Item {
        id: leftbar
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 32

        Loader {
            anchors.fill: parent
            active: loadRectangles
            sourceComponent: Rectangle {
                anchors.fill: parent
                color: color1
            }
        }
    }

    /** Right vertical bar, 32px wide */
    Item {
        id: rightbar
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: 32

        Loader {
            anchors.fill: parent
            active: loadRectangles
            sourceComponent: Rectangle {
                anchors.fill: parent
                color: color1
            }
        }
    }

    /** Top bar #1, 44px tall*/
    Item {
        id: topbar1
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 44

        Loader {
            anchors.fill: parent
            active: loadRectangles
            sourceComponent: Rectangle {
                anchors.fill: parent
                color: color1
            }
        }
    }

    /** Top bar #2, stacked below topbar1, 60px tall*/
    Item {
        id: topbar2
        anchors.top: topbar1.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 60

        Loader {
            anchors.fill: parent
            active: loadRectangles
            sourceComponent: Rectangle {
                anchors.fill: parent
                color: color2
            }
        }
    }

    /** Bottom bar #1, 22px tall*/
    Item {
        id: bottombar1
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 22


        anchors.bottomMargin: Qt.inputMethod.visible ?
                                  Qt.inputMethod.keyboardRectangle.height/Screen.devicePixelRatio
                                  :
                                  0

        Behavior on anchors.bottomMargin {
                NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
            }

        Loader {
            anchors.fill: parent
            active: loadRectangles
            sourceComponent: Rectangle {
                anchors.fill: parent
                color: color1
            }
        }
    }

    /** Bottom bar #2, stacked above bottombar1, 60px tall*/
    Item {
        id: bottombar2
        anchors.bottom: bottombar1.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 60

        Loader {
            anchors.fill: parent
            active: loadRectangles
            sourceComponent: Rectangle {
                anchors.fill: parent
                color: color2
            }
        }
    }

    /** Background MouseArea: set up to reset the focus of the
      app when clicking out of any object
    */
    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.forceActiveFocus()
        }
    }

    /** Aliases to expose bar items outside this component
      this to anchor different objects to them
      */
    property alias bottombar1: bottombar1
    property alias bottombar2: bottombar2
    property alias topbar1: topbar1
    property alias topbar2: topbar2
    property alias leftbar: leftbar
    property alias rightbar: rightbar
}
