import QtQuick
import QtQuick.Layouts
import "../GeneralQml"

BaseScreen {
    id: basescreen
    anchors.fill: parent
    loadRectangles: false
    property bool isPreview: Qt.application.arguments.indexOf("--qmlpreview") !== -1

    Loader {
        active: !basescreen.isPreview
        sourceComponent: Connections {
            target: ThreadManager
            function onStartedDay() {
                ScreenManager.goTo("ScreensQml/Exercise_Screen.qml");
            }
        }
    }

    MyButton {
        id: startDayButton

        anchors.centerIn: parent
        p_text: "test"

        onClicked: {
            if (basescreen.isPreview) {
                ScreenManager.goTo("ScreensQml/Exercise_Screen.qml");
            } else {
                ThreadManager.startDay();
            }
        }
    }
}
