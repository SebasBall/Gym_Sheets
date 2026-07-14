.pragma library

// The name explains what the function does pretty much
function appendExerciseData(exercise, exerciseModel) {
	// It appends every exercise component check the naming
	// and it explains itself pretty well
	exerciseModel.append({
		isTitle: true,
		isLink: false,
		text: exercise.name,
		borderArray: JSON.stringify([1, 0, 1, 1]),
		radiusArray: JSON.stringify([1, 1, 0, 0])
	});
	exerciseModel.append({
		text: exercise.video,
		isLink: true
	});
	exerciseModel.append({
		text: exercise.guide
	});
	exerciseModel.append({
		text: exercise.notes,
		borderArray: JSON.stringify([1, 1, 1, 1]),
		radiusArray: JSON.stringify([0, 0, 1, 1])
	});
}

// The name explains what the function does pretty much
function appendRecordsData(records, recordsModel, basescreen) {
	var training = 0;
	var notes = "";

	// Loop to go around all the records
	for (var i = 0; i < records.length; i++) {

		// |If| to break on the training changes (1 to 2, 2 to 3, ...)
		if (training != records[i].training) {
			training = records[i].training;

			// Add the notes of the previous training
			if (notes != "") {
				recordsModel.append({
					rowType: "1Label",
					text: notes,
				})
			}
			notes = "";

			// Add the title label to every training and since the
			// first one is also the first element on the list
			// making sure it has the correct radius on the borders
			if (training == 1) {
				recordsModel.append({
					rowType: "1Label",
					text: "Training " + training,
					isTitle: true,
					radiusArray: JSON.stringify([1, 1, 0, 0])
				});
			} else {
				recordsModel.append({
					rowType: "1Label",
					text: "Training " + training,
					isTitle: true,
				});
			}

			// Adding the default titles of every training
			recordsModel.append({
				rowType: "3Label",
				isTitle: true,
				text1: "Resistance",
				text2: "Reps",
				text3: "Effort"
			});
		}

		// Adding the current records and checking if they are the last 
		// element  as it has to have round borders
		notes += records[i].notes;
		if (i + 1 == records.length && notes == "") {
			recordsModel.append({
				rowType: "3Label",
				text1: records[i].resistance,
				text2: records[i].reps,
				text3: records[i].effort,
				isEnd: true
			});
		} else {
			recordsModel.append({
				rowType: "3Label",
				text1: records[i].resistance,
				text2: records[i].reps,
				text3: records[i].effort,
			});
		}
	}
	// Adding notes if they are the last element
	if (notes != "") {
		recordsModel.append({
			rowType: "1Label",
			text: notes,
			borderArray: JSON.stringify([1, 1, 1, 1]),
			radiusArray: JSON.stringify([0, 0, 1, 1])
		})
	}

	// Spacer between the records and the textfields
	recordsModel.append({
		rowType: "Spacer",
		height: 40
	});

	// Title of today training
	recordsModel.append({
		rowType: "1Label",
		text: "Today Training",
		isTitle: true,
		radiusArray: JSON.stringify([1, 1, 0, 0])
	});

	// Loop with the efforts of this training
	for (i = 0; i < basescreen.routine.length; i++) {
		recordsModel.append({
			rowType: "2Field1Label",
			text3: basescreen.routine[i]
		})
	}

	// Add the notes text field
	recordsModel.append({
		rowType: "1Field"
	});

	// Spacer between the today training and the complete training
	// button
	recordsModel.append({
		rowType: "Spacer",
		height: 40
	});

	recordsModel.append({
		rowType: "1Button"
	});

	// Save what is the actual training
	basescreen.actualTraining = training + 1
}


function collectInputs(recordsModel) {
	var results = [];
	for (var i = 0; i < recordsModel.count; i++) {
		var item = recordsModel.get(i);
		if (item.rowType === "2Field1Label") {
			results.push(item.resistance, item.reps);
		} else if (item.rowType === "1Field") {
			results.push(item.notes);
		}
	}
	return results;
}

function completeExercise(recordsModel, basescreen, ThreadManager) {
	var inputs = collectInputs(recordsModel);
	var records = [];
	for (var i = 0; i < basescreen.routine.length; i++) {
		var record = [];
		record.push(inputs[i * 2]);
		record.push(inputs[i * 2 + 1]);
		if (i + 1 === basescreen.routine.length) {
			record.push(inputs[inputs.length - 1]);
		} else {
			record.push("");
		}
		record.push(basescreen.actualTraining);
		records.push(record);
	}
	ThreadManager.completeExercise(records);
}

function loadPreviewData(exerciseModel, recordsModel, basescreen) {
	basescreen.routine = ["RIR 2", "RIR 1", "FALLO"];

	var exercise = {
		id: 1,
		name: "Press Inclinado con Mancuernas",
		video: "https://youtu.be/J_x6MEFk3DM",
		guide: "[6 - 8]",
		notes: "Asiento nivel 6 \\n Test segunda linea"
	};

	appendExerciseData(exercise, exerciseModel);

	var records = [
		{ training: 1, resistance: "20kg", reps: "7", effort: "RIR 2", notes: "" },
		{ training: 1, resistance: "20kg", reps: "8", effort: "RIR 1", notes: "" },
		{ training: 1, resistance: "22.5kg", reps: "8 RP x (1 parcial)", effort: "FALLO", notes: "" },

		{ training: 2, resistance: "22.5kg", reps: "6", effort: "RIR 2", notes: "" },
		{ training: 2, resistance: "22.5kg", reps: "7", effort: "RIR 1", notes: "" },
		{ training: 2, resistance: "25kg", reps: "4", effort: "FALLO", notes: "" },

		{ training: 3, resistance: "22.5kg", reps: "7", effort: "RIR 2", notes: "" },
		{ training: 3, resistance: "22.5kg", reps: "7 (1 parcial)", effort: "RIR 1", notes: "" },
		{
			training: 3, resistance: "20kg", reps: "7 RP x 4 RP x 3", effort: "FALLO",
			notes: "No se porque pero hoy no pude con 25 Kg y las de 22.5 estaban cogidas entonces me tocó con las de 20kg"
		},

		{ training: 4, resistance: "20kg", reps: "8", effort: "RIR 2", notes: "" },
		{ training: 4, resistance: "22.5kg", reps: "6", effort: "RIR 1", notes: "" },
		{
			training: 4, resistance: "22.5kg", reps: "8", effort: "FALLO",
			notes: "No pude hacer RP, cuando me intenté volver a poner las mancuernas no pude mantenerlas"
		},

		{ training: 5, resistance: "22.5kg", reps: "6", effort: "RIR 2", notes: "" },
		{ training: 5, resistance: "22.5kg", reps: "7", effort: "RIR 1", notes: "" },
		{ training: 5, resistance: "25kg", reps: "4", effort: "FALLO", notes: "" }
	];

	appendRecordsData(records, recordsModel, basescreen);
}

function completePreview(dataModel, basescreen) {
	var inputs = collectInputs(dataModel);
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
	console.log(records);
}
