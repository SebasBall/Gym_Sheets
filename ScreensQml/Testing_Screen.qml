import QtQuick
import "../GeneralQml"
import "../AppQml"

BaseScreen {
    id: basescreen
    anchors.fill: parent
    loadRectangles: false

    AppButton {
        anchors.centerIn: parent
    }
}
