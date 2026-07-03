import QtQuick
import QtQuick.Controls
import "GeneralQml"

ApplicationWindow {
    width: 400
    height: 892
    visible: true
    title: "Gym_Sheets"

    color: Colors.lightdark

    Component.onCompleted: console.log(ThreadManager)

    Loader {
        id: screensLoader
        active: true
        anchors.fill: parent
        focus: true
        source: "ScreensQml/Exercise_Screen.qml"
    }
}
