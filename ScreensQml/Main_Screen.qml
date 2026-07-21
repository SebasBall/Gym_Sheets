import QtQuick
import "../GeneralQml"
import "../AppQml"

// import "../PreviewQml"

BaseScreen {
    id: basescreen
    anchors.fill: parent
    loadRectangles: false
    property bool onTraining

    Component.onCompleted: {
        ThreadManager.getOnTraining();
    }

    Connections {
        target: ThreadManager
        function onGotOnTraining(onTraining) {
            console.log("Received: " + onTraining);
            basescreen.onTraining = onTraining;
        }
    }

    Connections {
        target: ThreadManager
        function onStartedDay() {
            ScreenManager.goTo("Exercise_Screen");
        }
    }

    MyRectangle {
        id: logo
        anchors.top: basescreen.topbar1.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 32
        width: 132
        height: width
        p_shadowEnabled: true
        p_shadowColor: Colors.primary

        p_gradientEnabled: true
        p_gradientColor1: Colors.primary
        p_gradientColor2: Colors.secondary
        p_radius: 30

        SvgIcon {
            z: 1
            source: ":SVG/gym.svg"
            anchors.fill: parent
            anchors.margins: 16
            svgFillColor: Colors.light
        }
    }

    MyLabel {
        id: title
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: logo.bottom
        anchors.topMargin: 16
        p_rectangleEnabled: false

        p_textFontName: Fonts.lexend.name
        p_textSize: 24
        p_textBold: true
        p_textColor: Colors.dark

        p_text: "GYM SHEETS"
    }

    Column {
        id: buttomsColumn

        anchors.top: title.bottom
        anchors.topMargin: 56
        anchors.left: basescreen.leftbar.right
        anchors.right: basescreen.rightbar.left
        anchors.bottom: basescreen.bottombar1.top

        spacing: 24

        AppButton {
            width: parent.width

            p_text: basescreen.onTraining ? "Start Day" : "Continue Day"

            onClicked: {
                if (basescreen.onTraining) {
                    ThreadManager.startDay();
                } else {
                    ScreenManager.goTo("Exercise_Screen");
                }
            }
        }

        AppButton {
            width: parent.width

            p_text: "Records"

            onClicked: {}
        }
    }
}
