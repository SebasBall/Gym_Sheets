pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

Item {
    id: root

    signal clicked
    signal entered
    signal pressed
    signal released
    signal exited

    property color p_rectangleColor: "Yellow"
    property bool p_rectangleEnabled: true
    property bool p_gradientEnabled: false

    property real p_borderSize: 0
    property var p_borderArray: [1, 1, 1, 1]
    property color p_borderColor: "black"

    property real p_radius: 0
    property var p_radiusArray: [1, 1, 1, 1]

    property color p_gradientColor1: "red"
    property color p_gradientColor2: "blue"
    property LinearGradient p_gradient: LinearGradient {
        x1: 0
        y1: 0
        x2: root.width
        y2: root.height
        GradientStop {
            position: 0.0
            color: root.p_gradientColor1
        }
        GradientStop {
            position: 1.0
            color: root.p_gradientColor2
        }
    }

    property bool p_borderGradientEnabled: false
    property color p_borderGradientColor1: "green"
    property color p_borderGradientColor2: "yellow"
    property LinearGradient p_borderGradient: LinearGradient {
        x1: 0
        y1: 0
        x2: root.width
        y2: root.height
        GradientStop {
            position: 0.0
            color: root.p_borderGradientColor1
        }
        GradientStop {
            position: 1.0
            color: root.p_borderGradientColor2
        }
    }

    property bool p_shadowEnabled: false
    property color p_shadowColor: p_rectangleColor
    property int p_shadowOffset: 5

    function borderMargin(index) {
        return root.p_borderArray[index] == true ? root.p_borderSize : 0;
    }

    function cornerRadiusInside(cornerIndex, side1Index, side2Index) {
        var radius = root.p_radiusArray[cornerIndex] == 1 ? root.p_radius : 0;
        var hasBorder = root.p_borderArray[side1Index] == 1 || root.p_borderArray[side2Index] == 1;
        var radiusDifference = hasBorder ? root.p_borderSize : 0;
        return Math.max(0, radius - radiusDifference);
    }

    function cornerRadiusOutside(index) {
        return root.p_radiusArray[index] == 1 ? root.p_radius : 0;
    }

    Loader {
        id: rectangleLoader
        active: root.p_rectangleEnabled
        anchors.fill: parent
        z: 1

        sourceComponent: Shape {
            id: rectangleShape

            anchors.fill: parent

            anchors.topMargin: root.borderMargin(0)
            anchors.bottomMargin: root.borderMargin(1)
            anchors.leftMargin: root.borderMargin(2)
            anchors.rightMargin: root.borderMargin(3)

            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                fillColor: !root.p_gradientEnabled ? root.p_rectangleColor : null
                fillGradient: root.p_gradientEnabled ? root.p_gradient : null

                strokeWidth: -1
                PathRectangle {
                    width: rectangleShape.width
                    height: rectangleShape.height

                    topLeftRadius: root.cornerRadiusInside(0, 0, 2)
                    topRightRadius: root.cornerRadiusInside(1, 0, 3)
                    bottomLeftRadius: root.cornerRadiusInside(2, 1, 2)
                    bottomRightRadius: root.cornerRadiusInside(3, 1, 3)
                }
            }
        }
    }

    Loader {
        id: borderLoader
        active: root.p_borderSize > 0
        anchors.fill: parent
        z: 0

        sourceComponent: Shape {
            id: borderShape

            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                fillColor: !root.p_borderGradientEnabled ? root.p_borderColor : null
                fillGradient: root.p_borderGradientEnabled ? root.p_borderGradient : null

                strokeWidth: -1
                PathRectangle {
                    width: borderShape.width
                    height: borderShape.height

                    topLeftRadius: root.cornerRadiusOutside(0)
                    topRightRadius: root.cornerRadiusOutside(1)
                    bottomLeftRadius: root.cornerRadiusOutside(2)
                    bottomRightRadius: root.cornerRadiusOutside(3)
                }
            }
        }
    }

    Loader {
        id: shadowLoader

        active: root.p_shadowEnabled
        anchors.fill: parent
        z: -2
        sourceComponent: RectangularShadow {
            anchors.fill: parent
            offset.x: root.p_shadowOffset
            offset.y: root.p_shadowOffset
            radius: root.p_radius
            color: Qt.darker(root.p_shadowColor, 1.6)
        }
    }

    MouseArea {
        id: mouseAreaId

        z: 3
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            root.forceActiveFocus();
            root.clicked();
        }
        onPressed: {
            root.pressed();
        }
        onReleased: {
            root.released();
        }
        onEntered: {
            root.entered();
        }
        onExited: {
            root.exited();
        }
    }
}
