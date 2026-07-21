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
	if (exercise.notes == "") {
		exerciseModel.append({
			text: exercise.guide,
			borderArray: JSON.stringify([1, 1, 1, 1]),
			radiusArray: JSON.stringify([0, 0, 1, 1])
		});
	} else {
		exerciseModel.append({
			text: exercise.guide,
		});
		exerciseModel.append({
			text: exercise.notes,
			borderArray: JSON.stringify([1, 1, 1, 1]),
			radiusArray: JSON.stringify([0, 0, 1, 1])
		});
	}
}

function appendRecordsData(records, recordsModel, basescreen) {
	var training = 1;
	var trainingModel = {}
	trainingModel.recordModel = []
	trainingModel.notes = {}
	trainingModel.notes.text = ""
	trainingModel.isFirst = true

	for (var i = 0; i < records.length; i++) {
		if (training != records[i].training) {
			trainingModel.rowType = "Training";
			trainingModel.text = "Training " + training
			trainingModel.recordModel.unshift({
				text1: "Resistance",
				text2: "Reps",
				text3: "Effort",
				isTitle: true,
				isEnd: false
			})
			recordsModel.append(trainingModel);
			training = records[i].training
			trainingModel = {}
			trainingModel.recordModel = []
			trainingModel.notes = {}
			trainingModel.notes.text = ""
		}
		trainingModel.recordModel.push({
			text1: records[i].resistance,
			text2: records[i].reps,
			text3: records[i].effort
		})
		trainingModel.notes.text += records[i].notes
		if (i + 1 == records.length) {
			trainingModel.recordModel[trainingModel.recordModel.length - 1].isEnd = true;
			trainingModel.rowType = "Training";
			trainingModel.text = "Training " + training
			trainingModel.isLast = true
			trainingModel.recordModel.unshift({
				text1: "Resistance",
				text2: "Reps",
				text3: "Effort",
				isTitle: true,
				isEnd: false
			})
			recordsModel.append(trainingModel);
		}
	}

	// Spacer between the today training and the complete training
	// button
	recordsModel.append({
		rowType: "Spacer",
		height: 40
	});

	// Title of today training
	recordsModel.append({
		rowType: "1Label",
		text: "Today Training",
		isTitle: true,
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

// The name explains what the function does pretty much
function appendRecordsDatadep(records, recordsModel, basescreen) {
	var training = 1;
	var notes = "";
	var recordModel = {}
	var trainingModel = {
		rowType: "Record",

		text: "Training " + training,
		isLast: false,

		recordModel: [
			{ text1: "Resistance", text2: "Reps", text3: "Effort", isTitle: false, isEnd: false },
			{ text1: "Set 1", text2: "50kg", text3: "10 reps", isTitle: false, isEnd: false },
			{ text1: "Set 2", text2: "55kg", text3: "8 reps", isTitle: false, isEnd: false },
			{ text1: "Set 3", text2: "60kg", text3: "6 reps", isTitle: false, isEnd: false }
		],

		notes: {
			text: "Notes",
			borderArray: JSON.stringify([1, 1, 1, 1]),
			radiusArray: JSON.stringify([0, 0, 1, 1])
		}
	};

	for (var i = 0; i < records.length; i++) {
		if (training != records[i].training) {
			trainingModel.push({
				rowType: "Record",
				text: "Training " + training,
			});
			recordsModel.append(trainingModel);
		}
	}



	// Loop to go around all the records
	for (var i = 0; i < records.length; i++) {

		// |If| to break on the training changes (1 to 2, 2 to 3, ...)
		if (training != records[i].training) {
			training = records[i].training;

			records.Model.append({})

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


}


function collectInputs(recordsModel) {
	var results = [];
	for (var i = 0; i < recordsModel.count; i++) {
		var item = recordsModel.get(i);
		if (item.rowType === "2Field1Label") {
			results.push(item.resistance, item.reps);
		} else if (item.rowType === "1Field") {
			results.push(item.todayNotes);
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
