import QtQuick
import QtQuick.Layouts
import "../GeneralQml"
import "../AppQml"

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
                ScreenManager.goTo("Exercise_Screen");
            }
        }
    }

    AppButton {
        id: startDayButton

        anchors.centerIn: parent
        p_text: "test"

        onClicked: {
            if (basescreen.isPreview) {
                ScreenManager.goTo("Exercise_Screen");
            } else {
                ThreadManager.startDay();
            }
        }
    }
}
