pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import "../GeneralQml"

BaseScreen {
    id: basescreen
    anchors.fill: parent
    loadRectangles: false

    ListModel {
        id: dataModel
    }

    Component.onCompleted: {
        dataModel.append({
            rowtype: 0,
            isBold: true,
            col1text: "Exercise Title"
        });
        dataModel.append({
            rowtype: 0,
            isBold: false,
            col1text: "Video"
        });
        dataModel.append({
            rowtype: 0,
            isBold: false,
            col1text: "Reps Guide"
        });
        dataModel.append({
            rowtype: 0,
            isBold: false,
            col1text: "Notes"
        });
        dataModel.append({
            rowtype: 0,
            isBold: false,
            col1text: "Day"
        });
        dataModel.append({
            rowtype: 1,
            isBold: true,
            col1text: "Resistance",
            col2text: "Reps",
            col3text: "Effort"
        });
        dataModel.append({
            rowtype: 1,
            isBold: false,
            col1text: "12kg",
            col2text: "10",
            col3text: "Failure"
        });
        dataModel.append({
            rowtype: 2,
            rowHeight: 10
        });
        dataModel.append({
            rowtype: 0,
            isBold: true,
            col1text: "Today Training"
        });
        dataModel.append({
            rowtype: 1,
            isBold: true,
            col1text: "Resistance",
            col2text: "Reps",
            col3text: "Effort"
        });
        dataModel.append({
            rowtype: 3,
            col3text: "Effort"
        });
        dataModel.append({
            rowtype: 4
        });
        dataModel.append({
            rowtype: 5,
            col1text: "Complete Day"
        });
    }

    ListView {
        id: dataList

        anchors.top: basescreen.topbar2.bottom
        anchors.left: basescreen.leftbar.right
        anchors.right: basescreen.rightbar.left
        anchors.bottom: basescreen.bottombar2.top

        model: dataModel

        delegate: DelegateChooser {
            role: "rowtype"
            DelegateChoice {
                roleValue: 0
                Item {
                    id: root0
                    required property string col1text
                    required property bool isBold
                    height: col1root0.implicitHeight
                    width: parent.width
                    Layout.fillWidth: true
                    MyRectangle {
                        id: col1root0
                        p_text: root0.col1text
                        width: parent.width
                        p_fontSize: 16
                        p_fontName: Fonts.lexend.name
                        p_horizontalAlign: Text.AlignHCenter
                        p_fontBold: root0.isBold
                    }
                }
            }
            DelegateChoice {
                roleValue: 1
                Item {
                    id: root1
                    required property string col1text
                    required property string col2text
                    required property string col3text
                    required property bool isBold
                    width: parent.width
                    height: Math.max(col1root1.implicitHeight, col2root1.implicitHeight, col3root1.implicitHeight)
                    RowLayout {
                        width: parent.width
                        spacing: 0
                        MyRectangle {
                            id: col1root1
                            p_text: root1.col1text
                            Layout.fillWidth: true
                            p_fontSize: 16
                            p_fontName: Fonts.lexend.name
                            p_horizontalAlign: Text.AlignHCenter
                            p_fontBold: root1.isBold
                        }
                        MyRectangle {
                            id: col2root1
                            p_text: root1.col2text
                            Layout.fillWidth: true
                            p_fontSize: 16
                            p_fontName: Fonts.lexend.name
                            p_horizontalAlign: Text.AlignHCenter
                            p_fontBold: root1.isBold
                        }
                        MyRectangle {
                            id: col3root1
                            p_text: root1.col3text
                            Layout.fillWidth: true
                            p_fontSize: 16
                            p_fontName: Fonts.lexend.name
                            p_horizontalAlign: Text.AlignHCenter
                            p_fontBold: root1.isBold
                        }
                    }
                }
            }
            DelegateChoice {
                roleValue: 2
                Item {
                    id: root2
                    required property real rowHeight
                    height: rowHeight
                    width: parent.width
                    Layout.fillWidth: true
                    MyRectangle {
                        id: col1root2
                        width: parent.width
                        height: root2.rowHeight
                        p_textEnabled: false
                        p_rectangleColor: Colors.secondary
                    }
                }
            }
            DelegateChoice {
                roleValue: 3
                Item {
                    id: root3
                    required property string col3text
                    width: parent.width
                    height: Math.max(col1root3.implicitHeight, col2root3.implicitHeight, col3root3.implicitHeight)
                    RowLayout {
                        width: parent.width
                        spacing: 0
                        MyTextField {
                            id: col1root3
                            Layout.fillWidth: true
                            Layout.preferredWidth: 0
                            p_fontSize: 16
                            p_fontName: Fonts.lexend.name
                            p_horizontalAlign: Text.AlignHCenter
                        }
                        MyTextField {
                            id: col2root3
                            Layout.fillWidth: true
                            Layout.preferredWidth: 0
                            p_fontSize: 16
                            p_fontName: Fonts.lexend.name
                            p_horizontalAlign: Text.AlignHCenter
                        }
                        MyRectangle {
                            id: col3root3
                            p_text: root3.col3text
                            Layout.fillWidth: true
                            Layout.preferredWidth: 0
                            p_fontSize: 16
                            p_fontName: Fonts.lexend.name
                            p_horizontalAlign: Text.AlignHCenter
                        }
                    }
                }
            }
            DelegateChoice {
                roleValue: 4
                Item {
                    id: root4
                    height: col1root4.implicitHeight
                    width: parent.width
                    Layout.fillWidth: true
                    MyTextField {
                        id: col1root4
                        width: parent.width
                        p_fontSize: 16
                        p_fontName: Fonts.lexend.name
                        p_horizontalAlign: Text.AlignHCenter
                    }
                }
            }
            DelegateChoice {
                roleValue: 5
                Item {
                    id: root5
                    required property string col1text
                    height: col1root5.implicitHeight
                    width: parent.width
                    Layout.fillWidth: true
                    MyButton {
                        id: col1root5
                        p_text: root5.col1text
                        width: parent.width
                        p_fontSize: 16
                        p_fontName: Fonts.lexend.name
                        p_horizontalAlign: Text.AlignHCenter
                    }
                }
            }
        }
    }
}
