pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import "../GeneralQml"
import "../AppQml"
// import "../PreviewQml"
import "Exercise_Screen_Logic.js" as Logic

BaseScreen {
    id: basescreen

    // Base screen configuration
    anchors.fill: parent
    loadRectangles: false

    // Basic variables for list view operations
    property int actualTraining: 0
    property var routine: []

    // Model to store the rows with the exercise data
    ListModel {
        id: exerciseModel
    }

    // Model to store the rows with the records data
    ListModel {
        id: recordsModel
    }

    // Load the rows data for the list view
    Component.onCompleted: {
        ThreadManager.getExerciseData();
    }

    // Connection to the signal from c++ to confirm that the data from the database
    // was collected
    Connections {
        target: ThreadManager
        function onGotExerciseData(exercise, records, routine) {
            basescreen.routine = routine;
            Logic.appendExerciseData(exercise, exerciseModel);
            Logic.appendRecordsData(records, recordsModel, basescreen);
        }
    }

    // Connection to the signal from c++ that confirms that the exercise data has
    // been saved and confirms also if the routine of the day has been completed
    Connections {
        target: ThreadManager
        function onCompletedExercise(dayCompleted) {
            if (dayCompleted) {
                ScreenManager.goTo("Main_Screen");
            } else {
                ScreenManager.reload();
            }
        }
    }

    MyRectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.topbar2.bottom

        p_gradientEnabled: true
        p_gradientColor1: Colors.primary
        p_gradientColor2: Colors.secondary
    }

    MouseArea {
        anchors.top: basescreen.topbar2.top
        anchors.bottom: basescreen.topbar2.bottom
        anchors.left: basescreen.topbar2.left
        width: height
        SvgIcon {
            source: ":/SVG/left-arrow.svg"
            anchors.fill: parent
            anchors.margins: 12

            svgFillColor: Colors.dark
        }

        onClicked: {
            ScreenManager.goTo("Main_Screen");
        }
    }

    // Column with the exercise data
    Column {
        id: exerciseDataView
        z: 2

        anchors.top: basescreen.topbar2.bottom
        anchors.left: basescreen.leftbar.right
        anchors.right: basescreen.rightbar.left
        anchors.topMargin: 32

        Repeater {
            model: exerciseModel

            AppLabel {
                required property var model
                width: parent.width

                p_text: model.text != "" ? model.text.replace(/\\n/g, "\n") : " "

                p_textBold: model.isTitle
                p_textSize: model.isTitle ? 20 : 14
                p_textColor: model.isTitle ? "white" : Colors.dark
                p_isLink: (model && model.isLink) ? model.isLink : false

                p_rectangleColor: model.isTitle ? Colors.dark : "white"
                p_gradientEnabled: model.isTitle

                p_textMargins: model.isTitle ? 14 : 8

                p_borderArray: (model && model.borderArray) ? JSON.parse(model.borderArray) : [1, 0, 1, 1]
                p_radiusArray: (model && model.radiusArray) ? JSON.parse(model.radiusArray) : [0, 0, 0, 0]
            }
        }
    }

    // This rectangle hides the destruction of the list view elements and makes
    // the dissapearence of them look smooth at the top
    MyRectangle {
        id: exerciseSpacer

        z: 1
        anchors.top: exerciseDataView.bottom
        anchors.left: basescreen.leftbar.left
        anchors.right: basescreen.rightbar.right
        anchors.topMargin: -20

        height: 56

        p_gradientEnabled: true
        p_gradient: LinearGradient {
            x1: exerciseSpacer.width / 2
            y1: 0
            x2: exerciseSpacer.width / 2
            y2: exerciseSpacer.height
            GradientStop {
                position: 0.75
                color: Colors.light
            }
            GradientStop {
                position: 1.0
                color: "transparent"
            }
        }
    }

    ListView {
        id: recordsDataView

        anchors.top: exerciseDataView.bottom
        anchors.left: basescreen.leftbar.right
        anchors.right: basescreen.rightbar.left
        anchors.bottom: basescreen.bottombar1.top

        model: recordsModel

        // Header to make the list view to render over the spacer that has the
        // transparent gradient to make the dissapearing of the elements look
        // smooth
        header: Item {
            height: 40
        }

        // Delegates that will manage the data obtained on the records of the
        // exercise, each delgate has a self explanatory name, and the data is
        // passed by the default model variable
        delegate: DelegateChooser {
            role: "rowType"

            DelegateChoice {
                roleValue: "Training"

                Column {
                    id: recordColumn
                    property bool detailsVisible: false
                    required property var model
                    width: recordsDataView.width

                    AppLabel {
                        width: parent.width
                        property var model: recordColumn.model

                        p_text: model.text
                        p_textSize: 16
                        p_textMargins: 12
                        p_textBold: true
                        p_textColor: "white"

                        p_rectangleColor: Colors.primary

                        p_borderArray: {
                            if (model.isLast && !recordColumn.detailsVisible) {
                                return [1, 1, 1, 1];
                            } else {
                                return [1, 0, 1, 1];
                            }
                        }
                        p_radiusArray: {
                            if (model.isFirst) {
                                return [1, 1, 0, 0];
                            } else if (model.isLast && !recordColumn.detailsVisible) {
                                return [0, 0, 1, 1];
                            } else {
                                return [0, 0, 0, 0];
                            }
                        }

                        onClicked: {
                            recordColumn.detailsVisible = !recordColumn.detailsVisible;
                        }
                    }

                    Column {
                        visible: recordColumn.detailsVisible
                        width: recordsDataView.width

                        Repeater {
                            model: recordColumn.model.recordModel
                            RowLayout {
                                id: recordRow
                                required property var model
                                width: recordsDataView.width
                                spacing: 0

                                AppLabel {
                                    property var model: recordRow.model
                                    Layout.fillWidth: true
                                    Layout.preferredWidth: 1
                                    Layout.fillHeight: true

                                    p_textMargins: 8

                                    p_text: model.text1
                                    p_textColor: model.isTitle ? "white" : Colors.dark
                                    p_rectangleColor: model.isTitle ? Colors.primary : "white"
                                    p_textBold: model.isTitle
                                    p_borderArray: {
                                        if (recordColumn.model.notes.text == "" & model.isEnd) {
                                            return [1, 1, 1, 0];
                                        } else {
                                            return [1, 0, 1, 0];
                                        }
                                    }
                                    p_radiusArray: {
                                        if (recordColumn.model.notes.text == "" & model.isEnd) {
                                            return [0, 0, 1, 0];
                                        } else {
                                            return [0, 0, 0, 0];
                                        }
                                    }
                                }
                                AppLabel {
                                    property var model: recordRow.model
                                    Layout.fillWidth: true
                                    Layout.preferredWidth: 1
                                    Layout.fillHeight: true

                                    p_textMargins: 8

                                    p_textBold: model.isTitle
                                    p_text: model.text2
                                    p_textColor: model.isTitle ? "white" : Colors.dark
                                    p_rectangleColor: model.isTitle ? Colors.primary : "white"
                                    p_borderArray: {
                                        if (recordColumn.model.notes.text == "" & model.isEnd) {
                                            return [1, 1, 1, 0];
                                        } else {
                                            return [1, 0, 1, 0];
                                        }
                                    }
                                }
                                AppLabel {
                                    property var model: recordRow.model
                                    Layout.fillWidth: true
                                    Layout.preferredWidth: 1
                                    Layout.fillHeight: true

                                    p_textMargins: 8

                                    p_textBold: model.isTitle
                                    p_text: model.text3
                                    p_textColor: model.isTitle ? "white" : Colors.dark
                                    p_rectangleColor: model.isTitle ? Colors.primary : "white"
                                    p_borderArray: {
                                        if (recordColumn.model.notes.text == "" & model.isEnd) {
                                            return [1, 1, 1, 1];
                                        } else {
                                            return [1, 0, 1, 1];
                                        }
                                    }
                                    p_radiusArray: {
                                        if (recordColumn.model.notes.text == "" & model.isEnd) {
                                            return [0, 0, 0, 1];
                                        } else {
                                            return [0, 0, 0, 0];
                                        }
                                    }
                                }
                            }
                        }
                        Loader {
                            active: recordColumn.model.notes.text != ""
                            sourceComponent: AppLabel {
                                property var model: recordColumn.model.notes

                                width: recordsDataView.width

                                // This is done because for some reason the data received from the
                                // sqldatabase sends \\n instead of \n
                                p_text: model.text.replace(/\\n/g, "\n")
                                p_textSize: 14
                                p_textMargins: 8
                                p_textColor: Colors.dark
                                p_rectangleColor: "white"

                                p_borderArray: recordColumn.model.isLast ? [1, 1, 1, 1] : [1, 0, 1, 1]
                                p_radiusArray: recordColumn.model.isLast ? [0, 0, 1, 1] : [0, 0, 0, 0]
                            }
                        }
                    }
                }
            }
            DelegateChoice {
                roleValue: "1Label"
                AppLabel {
                    required property var model

                    width: recordsDataView.width

                    // This is done because for some reason the data received from the
                    // sqldatabase sends \\n instead of \n
                    p_text: model.text.replace(/\\n/g, "\n")
                    p_textSize: model.isTitle ? 16 : 14
                    p_textMargins: model.isTitle ? 12 : 8
                    p_textBold: model.isTitle
                    p_textColor: model.isTitle ? "white" : Colors.dark

                    p_rectangleColor: model.isTitle ? Colors.primary : "white"

                    p_borderArray: [1, 0, 1, 1]
                    p_radiusArray: [1, 1, 0, 0]
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
                roleValue: "2Field1Label"
                RowLayout {
                    id: field2Label1
                    required property var model
                    required property int index
                    width: recordsDataView.width
                    spacing: 0

                    AppTextField {
                        property int index: field2Label1.index
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        Layout.fillHeight: true

                        p_textMargins: 8
                        p_placeHolderText: "Add the resistance"
                        // This is the best way that I have found to save the data from the
                        // delegates even though the list is far away from them
                        text: recordsModel.get(index).resistance ?? ""

                        onTextChanged: {
                            recordsModel.setProperty(index, "resistance", text);
                        }

                        p_textColor: Colors.dark
                        p_rectangleColor: "white"
                        p_borderArray: [1, 0, 1, 0]
                    }
                    AppTextField {
                        property int index: field2Label1.index
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        Layout.fillHeight: true

                        p_textMargins: 8
                        p_placeHolderText: "Add the reps"
                        text: recordsModel.get(index).reps ?? ""

                        onTextChanged: {
                            recordsModel.setProperty(index, "reps", text);
                        }

                        p_textColor: Colors.dark
                        p_rectangleColor: "white"
                        p_borderArray: [1, 0, 1, 0]
                    }
                    AppLabel {
                        property var model: field2Label1.model

                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        Layout.fillHeight: true

                        p_textMargins: 8

                        p_text: model.text3
                        p_textColor: Colors.dark
                        p_rectangleColor: "white"
                        p_borderArray: [1, 0, 1, 1]
                    }
                }
            }

            DelegateChoice {
                roleValue: "1Field"
                AppTextField {
                    required property int index

                    width: recordsDataView.width

                    p_textMargins: 12
                    p_placeHolderText: "Add your notes"
                    text: recordsModel.get(index).todayNotes ?? ""

                    onTextChanged: {
                        recordsModel.setProperty(index, "todayNotes", text);
                    }

                    p_textColor: Colors.dark
                    p_rectangleColor: "white"
                    p_borderArray: [1, 1, 1, 1]
                    p_radiusArray: [0, 0, 1, 1]
                }
            }

            DelegateChoice {
                roleValue: "1Button"
                AppButton {
                    width: recordsDataView.width
                    p_text: "Complete Training"

                    onClicked: {
                        Logic.completeExercise(recordsModel, basescreen, ThreadManager);
                    }
                }
            }

            // End of the DelegateChooser
        }

        footer: Item {
            height: 40
        }
    }

    // This rectangle hides the destruction of the list view elements and makes
    // the dissapearence of them look smooth at the bottom
    MyRectangle {
        id: bottomSpacer

        z: 1
        anchors.top: basescreen.bottombar1.top
        anchors.left: basescreen.left
        anchors.right: basescreen.right
        anchors.bottom: basescreen.bottombar1.bottom

        anchors.topMargin: -20

        p_gradientEnabled: true
        p_gradient: LinearGradient {
            x1: exerciseSpacer.width / 2
            y1: exerciseSpacer.height
            x2: exerciseSpacer.width / 2
            y2: 0
            GradientStop {
                position: 0.75
                color: Colors.light
            }
            GradientStop {
                position: 1.0
                color: "transparent"
            }
        }
    }
}
