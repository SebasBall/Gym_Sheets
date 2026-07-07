import QtQuick
import QtQuick.Controls
import "GeneralQml"

ApplicationWindow {
    width: 400
    height: 892
    visible: true
    title: "Gym_Sheets"

    color: Colors.lightdark

    Loader {
        id: screenLoader
        active: true
        anchors.fill: parent
        focus: true
        source: "ScreensQml/Exercise_Screen.qml"
        Component.onCompleted: ScreenManager.setLoader(screenLoader)
    }
}
