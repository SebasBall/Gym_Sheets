import QtQuick
import QtQuick.Layouts
import "../GeneralQml"

BaseScreen {
    id: basescreen
    anchors.fill: parent
    loadRectangles: false

    Connections {
        target: ThreadManager
        function onStartedDay() {
            ScreenManager.goTo("ScreensQml/Exercise_Screen.qml");
        }
    }

    MyButton {
        id: startDayButton

        anchors.centerIn: parent
        p_text: "test"

        onClicked: {
            ThreadManager.startDay();
        }
    }
}
