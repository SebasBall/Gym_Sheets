import QtQuick
import QtQuick.Controls
import "GeneralQml"

Window {
    width: 390
    height: 844
    visible: true
    title: "Gym_Sheets"

    color: Colors.light

    Loader {
        id: screenLoader
        active: true
        anchors.fill: parent
        focus: true
        source: "ScreensQml/Main_Screen.qml"
        Component.onCompleted: {
            ScreenManager.setLoader(screenLoader);
        }
    }
}
