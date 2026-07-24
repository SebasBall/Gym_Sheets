pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import "../GeneralQml"
import "../AppQml"
import "CompleteDay_Screen_Logic.js" as Logic

// import "../PreviewQml"

BaseScreen {
    id: basescreen

    // Base screen configuration
    anchors.fill: parent
    loadRectangles: false

    Component.onCompleted: {
        ThreadManager.getTodayRecords();
    }

    Connections {
        target: ThreadManager
        function onGotTodayRecords(todayData) {
            console.log(todayData);
            Logic.appendTodayRecords(todayData, listModel);
        }
    }

    Connections {
        target: ThreadManager
        function onCompletedTraining() {
            ScreenManager.goTo("Main_Screen");
        }
    }

    ListModel {
        id: listModel
    }

    ListView {
        id: todayRecordsView

        anchors.top: basescreen.topbar2.bottom
        anchors.left: basescreen.leftbar.right
        anchors.right: basescreen.rightbar.left
        anchors.bottom: basescreen.bottombar2.top

        model: listModel

        delegate: DelegateChooser {
            role: "rowType"
            DelegateChoice {
                roleValue: "1Label"
                AppLabel {
                    required property var model

                    width: todayRecordsView.width

                    // This is done because for some reason the data received from the
                    // sqldatabase sends \\n instead of \n
                    p_text: model.text.replace(/\\n/g, "\n")
                    p_textSize: model.isTitle ? 16 : 14
                    p_textMargins: model.isTitle ? 12 : 8
                    p_textBold: model.isTitle
                    p_textColor: model.isTitle ? "white" : Colors.dark

                    p_rectangleColor: model.isTitle ? Colors.primary : "white"

                    p_borderArray: {
                        if (model.isEnd == true) {
                            return [1, 1, 1, 1];
                        } else {
                            return [1, 0, 1, 1];
                        }
                    }
                    p_radiusArray: {
                        if (model.isStart == true) {
                            return [1, 1, 0, 0];
                        } else if (model.isEnd == true) {
                            return [0, 0, 1, 1];
                        } else {
                            return [0, 0, 0, 0];
                        }
                    }
                }
            }

            DelegateChoice {
                roleValue: "3Label"
                RowLayout {
                    id: label3
                    required property var model
                    width: todayRecordsView.width
                    spacing: 0

                    AppLabel {
                        property var model: label3.model
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        Layout.fillHeight: true

                        p_textMargins: 8

                        p_text: model.text1
                        p_textColor: model.isTitle ? "white" : Colors.dark
                        p_rectangleColor: model.isTitle ? Colors.primary : "white"
                        p_textBold: model.isTitle
                        p_borderArray: {
                            if (model.notes == "" && model.isEnd) {
                                return [1, 1, 1, 0];
                            } else {
                                return [1, 0, 1, 0];
                            }
                        }
                        p_radiusArray: {
                            if (model.notes == "" && model.isEnd) {
                                return [0, 0, 1, 0];
                            } else {
                                return [0, 0, 0, 0];
                            }
                        }
                    }
                    AppLabel {
                        property var model: label3.model
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        Layout.fillHeight: true

                        p_textMargins: 8

                        p_textBold: model.isTitle
                        p_text: model.text2
                        p_textColor: model.isTitle ? "white" : Colors.dark
                        p_rectangleColor: model.isTitle ? Colors.primary : "white"
                        p_borderArray: {
                            if (model.notes == "" && model.isEnd) {
                                return [1, 1, 1, 0];
                            } else {
                                return [1, 0, 1, 0];
                            }
                        }
                    }
                    AppLabel {
                        property var model: label3.model
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        Layout.fillHeight: true

                        p_textMargins: 8

                        p_textBold: model.isTitle
                        p_text: model.text3
                        p_textColor: model.isTitle ? "white" : Colors.dark
                        p_rectangleColor: model.isTitle ? Colors.primary : "white"
                        p_borderArray: {
                            if (model.notes == "" && model.isEnd) {
                                return [1, 1, 1, 1];
                            } else {
                                return [1, 0, 1, 1];
                            }
                        }
                        p_radiusArray: {
                            if (model.notes == "" && model.isEnd) {
                                return [0, 0, 0, 1];
                            } else {
                                return [0, 0, 0, 0];
                            }
                        }
                    }
                }
            }

            DelegateChoice {
                roleValue: "Spacer"
                Item {
                    required property var model
                    height: model.height
                }
            }

            DelegateChoice {
                roleValue: "1Button"
                AppButton {
                    width: todayRecordsView.width
                    p_text: "Complete Training"

                    onClicked: {
                        ThreadManager.completeTraining();
                    }
                }
            }
        }
    }
}
