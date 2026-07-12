pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import "../GeneralQml"
import "../AppQml"
import "Exercise_Screen_Logic.js" as Logic

BaseScreen {
    id: basescreen
    anchors.fill: parent
    loadRectangles: false
    property bool isPreview: Qt.application.arguments.indexOf("--qmlpreview") !== -1
    property int actualTraining: 0
    property var rutine: []

    ListModel {
        id: dataModel
    }

    Component.onCompleted: {
        if (isPreview) {
            Logic.loadPreviewData(dataModel, basescreen);
        } else {
            ThreadManager.getExerciseData();
        }
    }

    Loader {
        active: !basescreen.isPreview
        sourceComponent: Connections {
            target: ThreadManager
            function onGotExerciseData(exercise, records) {
                Logic.gotExerciseData(exercise, records, dataModel, basescreen);
            }
        }
    }

    Loader {
        active: !basescreen.isPreview
        sourceComponent: Connections {
            target: ThreadManager
            function onCompletedExercise(dayCompleted) {
                console.log("received signal with: " + dayCompleted);
                if (dayCompleted) {
                    ScreenManager.goTo("ScreensQml/Main_Screen.qml");
                } else {
                    ScreenManager.reload();
                }
            }
        }
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
                roleValue: "1Label"
                Item {
                    id: root0
                    required property var model

                    height: col1root0.implicitHeight
                    width: ListView.view.width
                    Layout.fillWidth: true
                    AppLabel {
                        id: col1root0
                        width: parent.width

                        p_text: root0.model.col1text != "" ? root0.model.col1text : "Place Holder"
                        p_textBold: root0.model.isBold
                        p_textSize: root0.model.fontSize > 0 ? root0.model.fontSize : 16

                        p_borderArray: (root0.model && root0.model.borderArray) ? JSON.parse(root0.model.borderArray) : [1, 0, 1, 1]
                        p_radiusArray: (root0.model && root0.model.radiusArray) ? JSON.parse(root0.model.radiusArray) : [0, 0, 0, 0]
                    }
                }
            }

            DelegateChoice {
                roleValue: "Spacer"
                Item {
                    id: root1
                    required property real rowHeight
                    height: rowHeight
                    width: ListView.view.width
                    Layout.fillWidth: true
                    MyRectangle {
                        id: col1root1
                        width: parent.width
                        height: root1.rowHeight
                        p_rectangleColor: Colors.light
                    }
                }
            }

            DelegateChoice {
                roleValue: "3Label"
                Item {
                    id: root2
                    required property var model
                    width: ListView.view.width
                    height: Math.max(col1root2.implicitHeight, col2root2.implicitHeight, col3root2.implicitHeight)
                    RowLayout {
                        width: parent.width
                        height: parent.height
                        spacing: 0
                        AppLabel {
                            id: col1root2
                            Layout.fillWidth: true
                            Layout.preferredWidth: 0
                            Layout.fillHeight: true

                            p_textMargins: 8

                            p_text: root2.model.col1text != "" ? root2.model.col1text : "Place Holder"
                            p_textBold: root2.model.isBold
                            p_textSize: root2.model.fontSize > 0 ? root2.model.fontSize : 16

                            p_borderArray: (root2.model && root2.model.borderArray1) ? JSON.parse(root2.model.borderArray1) : [1, 0, 1, 0]
                            p_radiusArray: (root2.model && root2.model.radiusArray1) ? JSON.parse(root2.model.radiusArray1) : [0, 0, 0, 0]
                        }

                        AppLabel {
                            id: col2root2
                            Layout.fillWidth: true
                            Layout.preferredWidth: 0
                            Layout.fillHeight: true
                            p_textMargins: 8

                            p_text: root2.model.col2text != "" ? root2.model.col2text : "Place Holder"
                            p_textBold: root2.model.isBold
                            p_textSize: root2.model.fontSize > 0 ? root2.model.fontSize : 16

                            p_borderArray: (root2.model && root2.model.borderArray2) ? JSON.parse(root2.model.borderArray2) : [1, 0, 1, 0]
                            p_radiusArray: (root2.model && root2.model.radiusArray2) ? JSON.parse(root2.model.radiusArray2) : [0, 0, 0, 0]
                        }

                        AppLabel {
                            id: col3root2
                            Layout.fillWidth: true
                            Layout.preferredWidth: 0
                            Layout.fillHeight: true
                            p_textMargins: 8

                            p_text: root2.model.col3text != "" ? root2.model.col3text : "Place Holder"
                            p_textBold: root2.model.isBold
                            p_textSize: root2.model.fontSize > 0 ? root2.model.fontSize : 16

                            p_borderArray: (root2.model && root2.model.borderArray3) ? JSON.parse(root2.model.borderArray3) : [1, 0, 1, 1]
                            p_radiusArray: (root2.model && root2.model.radiusArray3) ? JSON.parse(root2.model.radiusArray3) : [0, 0, 0, 0]
                        }
                    }
                }
            }
            DelegateChoice {
                roleValue: "2Fields1Label"
                Item {
                    id: root3
                    required property var model
                    required property int index
                    width: ListView.view.width
                    height: Math.max(col1root3.implicitHeight, col2root3.implicitHeight, col3root3.implicitHeight)
                    RowLayout {
                        width: parent.width
                        spacing: 0

                        AppTextField {
                            id: col1root3
                            Layout.fillWidth: true
                            Layout.preferredWidth: 0
                            Layout.fillHeight: true
                            p_textMargins: 8

                            text: dataModel.get(root3.index).resistance ?? ""
                            p_placeHolderText: "Add Resistance"

                            onTextChanged: {
                                dataModel.setProperty(root3.index, "resistance", text);
                            }

                            p_borderArray: (root3.model && root3.model.borderArray1) ? JSON.parse(root3.model.borderArray1) : [1, 0, 1, 0]
                            p_radiusArray: (root3.model && root3.model.radiusArray1) ? JSON.parse(root3.model.radiusArray1) : [0, 0, 0, 0]
                        }

                        AppTextField {
                            id: col2root3
                            Layout.fillWidth: true
                            Layout.preferredWidth: 0
                            Layout.fillHeight: true
                            p_textMargins: 8

                            text: dataModel.get(root3.index).reps ?? ""
                            p_placeHolderText: "Add Reps"

                            onTextChanged: {
                                dataModel.setProperty(root3.index, "reps", text);
                            }
                            p_borderArray: (root3.model && root3.model.borderArray1) ? JSON.parse(root3.model.borderArray1) : [1, 0, 1, 0]
                            p_radiusArray: (root3.model && root3.model.radiusArray1) ? JSON.parse(root3.model.radiusArray1) : [0, 0, 0, 0]
                        }

                        AppLabel {
                            id: col3root3

                            p_text: root3.model.col3text
                            Layout.fillWidth: true
                            Layout.preferredWidth: 0
                            Layout.fillHeight: true
                            p_textMargins: 8

                            p_borderArray: (root3.model && root3.model.borderArray1) ? JSON.parse(root3.model.borderArray1) : [1, 0, 1, 1]
                            p_radiusArray: (root3.model && root3.model.radiusArray1) ? JSON.parse(root3.model.radiusArray1) : [0, 0, 0, 0]
                        }
                    }
                }
            }
            DelegateChoice {
                roleValue: "1Field"
                Item {
                    id: root4

                    required property var model
                    required property int index
                    height: col1root4.implicitHeight
                    width: ListView.view.width

                    AppTextField {
                        id: col1root4
                        anchors.left: parent.left
                        anchors.right: parent.right

                        text: dataModel.get(root4.index).notes ?? ""
                        p_placeHolderText: "Add Notes"

                        onTextChanged: {
                            dataModel.setProperty(root4.index, "notes", text);
                        }

                        p_borderArray: (root4.model && root4.model.borderArray1) ? JSON.parse(root4.model.borderArray1) : [1, 1, 1, 1]
                        p_radiusArray: (root4.model && root4.model.radiusArray1) ? JSON.parse(root4.model.radiusArray1) : [0, 0, 1, 1]
                    }
                }
            }

            DelegateChoice {
                roleValue: "1Button"
                Item {
                    id: root5

                    required property var model
                    height: col1root5.implicitHeight
                    width: ListView.view.width

                    AppButton {
                        id: col1root5
                        p_text: root5.model.col1text
                        width: parent.width
                        onClicked: {
                            if (basescreen.isPreview) {
                                Logic.completePreview(dataModel, basescreen);
                            } else {
                                Logic.completeExercise(dataModel, basescreen, ThreadManager);
                            }
                        }
                    }
                }
            }

            // space

        }
    }
}
