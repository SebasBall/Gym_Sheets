pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import "../GeneralQml"

BaseScreen {
    id: basescreen
    anchors.fill: parent
    loadRectangles: false
    property bool isPreview: Qt.application.arguments.indexOf("--qmlpreview") !== -1
    property int actualTraining: 0
    property var rutine: []

    function collectInputs() {
        var results = [];
        for (var i = 0; i < dataModel.count; i++) {
            var item = dataModel.get(i);
            if (item.rowtype === 3) {
                results.push(item.resistance, item.reps);
            } else if (item.rowtype === 4) {
                results.push(item.notes);
            }
        }
        return results;
    }

    ListModel {
        id: dataModel
    }

    Component.onCompleted: {
        if (isPreview) {
            basescreen.rutine = ["RIR 2", "RIR 1", "FALLO"];
            basescreen.actualTraining = 6;
            // --- Exercise Header Info ---
            dataModel.append({
                rowtype: 0,
                isBold: true,
                col1text: "Press Inclinado con Mancuernas"
            });
            dataModel.append({
                rowtype: 0,
                isBold: false,
                col1text: "https://youtu.be/J_x6MEFk3DM"
            });
            dataModel.append({
                rowtype: 0,
                isBold: false,
                col1text: "[6 - 8]"
            });
            dataModel.append({
                rowtype: 0,
                isBold: false,
                col1text: "Asiento nivel 6"
            });
            // --- Training 1 ---
            dataModel.append({
                rowtype: 0,
                isBold: true,
                col1text: "Training 1"
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
                col1text: "20kg",
                col2text: "'7'",
                col3text: "RIR 2"
            });
            dataModel.append({
                rowtype: 1,
                isBold: false,
                col1text: "20kg",
                col2text: "'8'",
                col3text: "RIR 1"
            });
            dataModel.append({
                rowtype: 1,
                isBold: false,
                col1text: "22.5kg",
                col2text: "8 RP x (1 parcial)",
                col3text: "FALLO"
            });
            // --- Training 2 ---
            dataModel.append({
                rowtype: 0,
                isBold: true,
                col1text: "Training 2"
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
                col1text: "22.5kg",
                col2text: "'6'",
                col3text: "RIR 2"
            });
            dataModel.append({
                rowtype: 1,
                isBold: false,
                col1text: "22.5kg",
                col2text: "'7'",
                col3text: "RIR 1"
            });
            dataModel.append({
                rowtype: 1,
                isBold: false,
                col1text: "25kg",
                col2text: "'4'",
                col3text: "FALLO"
            });

            // --- Training 3 ---
            dataModel.append({
                rowtype: 0,
                isBold: false,
                col1text: "No se porque pero hoy no pude con 25 Kg y las de 22.5 estaban cogidas entonces me tocó con las de 20kg"
            });
            dataModel.append({
                rowtype: 0,
                isBold: true,
                col1text: "Training 3"
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
                col1text: "22.5kg",
                col2text: "'7'",
                col3text: "RIR 2"
            });
            dataModel.append({
                rowtype: 1,
                isBold: false,
                col1text: "22.5kg",
                col2text: "7 (1 parcial)",
                col3text: "RIR 1"
            });
            dataModel.append({
                rowtype: 1,
                isBold: false,
                col1text: "20kg",
                col2text: "7 RP x 4 RP x 3",
                col3text: "FALLO"
            });

            // --- Training 4 ---
            dataModel.append({
                rowtype: 0,
                isBold: true,
                col1text: "Training 4"
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
                col1text: "20kg",
                col2text: "'8'",
                col3text: "RIR 2"
            });
            dataModel.append({
                rowtype: 1,
                isBold: false,
                col1text: "22.5kg",
                col2text: "'6'",
                col3text: "RIR 1"
            });
            dataModel.append({
                rowtype: 1,
                isBold: false,
                col1text: "22.5kg",
                col2text: "'8'",
                col3text: "FALLO"
            });

            // --- Training 5 ---
            dataModel.append({
                rowtype: 0,
                isBold: false,
                col1text: "No pude hacer RP, cuando me intenté volver a poner las mancuernas no pude mantenerlas"
            });
            dataModel.append({
                rowtype: 0,
                isBold: true,
                col1text: "Training 5"
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
                col1text: "22.5kg",
                col2text: "'6'",
                col3text: "RIR 2"
            });
            dataModel.append({
                rowtype: 1,
                isBold: false,
                col1text: "22.5kg",
                col2text: "'7'",
                col3text: "RIR 1"
            });
            dataModel.append({
                rowtype: 1,
                isBold: false,
                col1text: "25kg",
                col2text: "'4'",
                col3text: "FALLO"
            });

            // --- Today Training (Routine Section) ---
            dataModel.append({
                rowtype: 2,
                rowHeight: 20
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
                col3text: "RIR 2"
            });
            dataModel.append({
                rowtype: 3,
                col3text: "RIR 1"
            });
            dataModel.append({
                rowtype: 3,
                col3text: "FALLO"
            });

            // --- Footer ---
            dataModel.append({
                rowtype: 4
            });
            dataModel.append({
                rowtype: 5,
                col1text: "Complete Day"
            });
        } else {
            ThreadManager.getExerciseData();
        }
    }

    Connections {
        target: ThreadManager
        function onGotExerciseData(exercise, records) {
            dataModel.append({
                rowtype: 0,
                isBold: true,
                col1text: exercise.name
            });
            dataModel.append({
                rowtype: 0,
                isBold: false,
                col1text: exercise.video
            });
            dataModel.append({
                rowtype: 0,
                isBold: false,
                col1text: exercise.guide
            });
            dataModel.append({
                rowtype: 0,
                isBold: false,
                col1text: exercise.notes
            });
            var training = 0;
            var notes = "";
            var gotRutine = false;
            for (var i = 0; i < records.length; i++) {
                if (i + 1 === records.length) {
                    basescreen.actualTraining = records[i].training + 1;
                }
                if (training != records[i].training) {
                    if (notes != "") {
                        dataModel.append({
                            rowtype: 0,
                            isBold: false,
                            col1text: notes
                        });
                    }
                    dataModel.append({
                        rowtype: 0,
                        isBold: true,
                        col1text: "Training " + records[i].training
                    });
                    dataModel.append({
                        rowtype: 1,
                        isBold: true,
                        col1text: "Resistance",
                        col2text: "Reps",
                        col3text: "Effort"
                    });
                    training = records[i].training;
                    notes = "";
                    if (!gotRutine && basescreen.rutine.length != 0) {
                        gotRutine = true;
                    }
                }
                dataModel.append({
                    rowtype: 1,
                    isBold: false,
                    col1text: records[i].resistance,
                    col2text: records[i].reps,
                    col3text: records[i].type
                });
                notes = notes + records[i].notes;
                if (!gotRutine) {
                    basescreen.rutine.push(records[i].type);
                }
            }
            dataModel.append({
                rowtype: 2,
                rowHeight: 20
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
            for (var i = 0; i < basescreen.rutine.length; i++) {
                dataModel.append({
                    rowtype: 3,
                    col3text: basescreen.rutine[i]
                });
            }
            dataModel.append({
                rowtype: 4
            });
            dataModel.append({
                rowtype: 5,
                col1text: "Complete Day"
            });
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
                roleValue: 0
                Item {
                    id: root0
                    required property string col1text
                    required property bool isBold
                    height: col1root0.implicitHeight
                    width: ListView.view.width
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
                    width: ListView.view.width
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
                    width: ListView.view.width
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
                    required property var model
                    required property int index
                    width: ListView.view.width
                    height: Math.max(col1root3.implicitHeight, col2root3.implicitHeight, col3root3.implicitHeight)
                    RowLayout {
                        width: parent.width
                        spacing: 0
                        MyTextField {
                            id: col1root3
                            text: root3.model.userValue ?? ""
                            onTextChanged: {
                                dataModel.setProperty(root3.index, "resistance", text);
                            }
                            Layout.fillWidth: true
                            Layout.preferredWidth: 0
                            p_fontSize: 16
                            p_fontName: Fonts.lexend.name
                            p_horizontalAlign: Text.AlignHCenter
                        }
                        MyTextField {
                            id: col2root3
                            text: root3.model.userValue ?? ""
                            onTextChanged: {
                                dataModel.setProperty(root3.index, "reps", text);
                            }
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
                    required property var model
                    required property int index
                    height: col1root4.implicitHeight
                    width: ListView.view.width
                    Layout.fillWidth: true
                    MyTextField {
                        id: col1root4
                        text: root4.model.userValue ?? ""
                        onTextChanged: {
                            dataModel.setProperty(root4.index, "notes", text);
                        }
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
                    width: ListView.view.width
                    Layout.fillWidth: true
                    MyButton {
                        id: col1root5
                        p_text: root5.col1text
                        width: parent.width
                        p_fontSize: 16
                        p_fontName: Fonts.lexend.name
                        p_horizontalAlign: Text.AlignHCenter
                        onClicked: {
                            var inputs = basescreen.collectInputs();
                            var records = [];
                            for (var i = 0; i < basescreen.rutine.length; i++) {
                                var record = [];
                                record.push(inputs[i * 2]);
                                record.push(inputs[i * 2 + 1]);
                                if (i + 1 === basescreen.rutine.length) {
                                    record.push(inputs[inputs.length - 1]);
                                } else {
                                    record.push("");
                                }
                                record.push(basescreen.actualTraining);
                                records.push(record);
                            }
                            ThreadManager.completeExercise(records);
                        }
                    }
                }
            }
        }
    }
}
