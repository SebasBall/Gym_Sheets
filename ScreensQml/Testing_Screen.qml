import QtQuick
import "../GeneralQml"
import "../AppQml"

BaseScreen {
    id: basescreen
    anchors.fill: parent
    loadRectangles: false

    Column {
        anchors.top: basescreen.topbar2.bottom
        anchors.bottom: basescreen.bottombar2.top
        anchors.left: basescreen.leftbar.right
        anchors.right: basescreen.rightbar.left

        Column {
            id: column
            property bool detailsVisible: false
            width: parent.width
            AppLabel {
                width: parent.width
                p_text: "test"

                onClicked: {
                    column.detailsVisible = !column.detailsVisible;
                }
            }

            Column {
                visible: column.detailsVisible
                width: parent.width

                AppLabel {
                    width: parent.width
                    p_text: "Detail 1"
                }
                AppLabel {
                    width: parent.width
                    p_text: "Detail 2"
                }
                AppLabel {
                    width: parent.width
                    p_text: "Detail 3"
                }
            }
        }

        Column {
            id: column2
            property bool detailsVisible: false
            width: parent.width
            AppLabel {
                width: parent.width
                p_text: "test"

                onClicked: {
                    column2.detailsVisible = !column2.detailsVisible;
                }
            }

            Column {
                visible: column2.detailsVisible
                width: parent.width

                AppLabel {
                    width: parent.width
                    p_text: "Detail 1"
                }
                AppLabel {

                    width: parent.width

                    p_text: "Detail 2"
                }
                AppLabel {
                    width: parent.width
                    p_text: "Detail 3"
                }
            }
        }
    }
}
