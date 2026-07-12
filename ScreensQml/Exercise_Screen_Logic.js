.pragma library

function gotExerciseData(exercise, records, dataModel, basescreen) {
	dataModel.append({
		rowtype: "1Label",
		isBold: true,
		col1text: exercise.name,
		fontSize: 20,
		borderArray: JSON.stringify([1, 0, 1, 1]),
		radiusArray: JSON.stringify([1, 1, 0, 0])
	});
	dataModel.append({
		rowtype: "1Label",
		col1text: exercise.video
	});
	dataModel.append({
		rowtype: "1Label",
		col1text: exercise.guide
	});
	dataModel.append({
		rowtype: "1Label",
		col1text: exercise.notes,
		borderArray: JSON.stringify([1, 1, 1, 1]),
		radiusArray: JSON.stringify([0, 0, 1, 1])
	});
	dataModel.append({
		rowtype: "Spacer",
		rowHeight: 30
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
					rowtype: "1Label",
					col1text: notes
				});
			}
			if (records[i].training === 1) {
				dataModel.append({
					rowtype: "1Label",
					col1text: "Training " + records[i].training,
					isBold: true,
					radiusArray: JSON.stringify([1, 1, 0, 0])
				});
			} else {
				dataModel.append({
					rowtype: "1Label",
					col1text: "Training " + records[i].training,
					isBold: true
				});
			}
			dataModel.append({
				rowtype: "3Label",
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

		notes = notes + records[i].notes;

		if (notes === "" && i + 1 === records.length) {
			dataModel.append({
				rowtype: "3Label",
				isBold: false,
				col1text: records[i].resistance,
				col2text: records[i].reps,
				col3text: records[i].effort,
				borderArray1: JSON.stringify([1, 1, 1, 0]),
				borderArray2: JSON.stringify([1, 1, 1, 0]),
				borderArray3: JSON.stringify([1, 1, 1, 1]),
				radiusArray1: JSON.stringify([0, 0, 1, 0]),
				radiusArray3: JSON.stringify([0, 0, 0, 1]),
			});
		} else if (notes != "" && i + 1 === records.length) {
			dataModel.append({
				rowtype: "1Label",
				col1text: notes,
				borderArray: JSON.stringify([1, 1, 1, 1]),
				radiusArray: JSON.stringify([0, 0, 1, 1])
			});
		} else {
			dataModel.append({
				rowtype: "3Label",
				isBold: false,
				col1text: records[i].resistance,
				col2text: records[i].reps,
				col3text: records[i].effort
			});
		}
		if (!gotRutine) {
			basescreen.rutine.push(records[i].effort);
		}
	}
	dataModel.append({
		rowtype: "Spacer",
		rowHeight: 30
	});
	dataModel.append({
		rowtype: "1Label",
		isBold: true,
		col1text: "Today Training",
		radiusArray: JSON.stringify([1, 1, 0, 0])
	});
	dataModel.append({
		rowtype: "3Label",
		isBold: true,
		col1text: "Resistance",
		col2text: "Reps",
		col3text: "Effort"
	});
	for (var i = 0; i < basescreen.rutine.length; i++) {
		dataModel.append({
			rowtype: "2Fields1Label",
			col3text: basescreen.rutine[i]
		});
	}
	dataModel.append({
		rowtype: "1Field"
	});
	dataModel.append({
		rowtype: "Spacer",
		rowHeight: 30
	});
	dataModel.append({
		rowtype: "1Button",
		col1text: "Complete Day"
	});
}




function collectInputs(dataModel) {
	var results = [];
	for (var i = 0; i < dataModel.count; i++) {
		var item = dataModel.get(i);
		if (item.rowtype === "2Fields1Label") {
			results.push(item.resistance, item.reps);
		} else if (item.rowtype === "1Field") {
			results.push(item.notes);
		}
	}
	return results;
}

function completeExercise(dataModel, basescreen, ThreadManager) {
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
	ThreadManager.completeExercise(records);
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

function loadPreviewData(dataModel, basescreen) {
	basescreen.rutine = ["RIR 2", "RIR 1", "FALLO"];

	var exercise = {
		id: 1,
		name: "Press Inclinado con Mancuernas",
		video: "https://youtu.be/J_x6MEFk3DM",
		guide: "[6 - 8]",
		notes: "Asiento nivel 6"
	};

	var records = [
		{ training: 1, resistance: "20kg", reps: "7", effort: "RIR 2", notes: "" },
		{ training: 1, resistance: "20kg", reps: "8", effort: "RIR 1", notes: "" },
		{ training: 1, resistance: "22.5kg", reps: "8 RP x (1 parcial)", effort: "FALLO", notes: "" },

		{ training: 2, resistance: "22.5kg", reps: "6", effort: "RIR 2", notes: "" },
		{ training: 2, resistance: "22.5kg", reps: "7", effort: "RIR 1", notes: "" },
		{
			training: 2, resistance: "25kg", reps: "4", effort: "FALLO",
			notes: "No se porque pero hoy no pude con 25 Kg y las de 22.5 estaban cogidas entonces me tocó con las de 20kg"
		},

		{ training: 3, resistance: "22.5kg", reps: "7", effort: "RIR 2", notes: "" },
		{ training: 3, resistance: "22.5kg", reps: "7 (1 parcial)", effort: "RIR 1", notes: "" },
		{ training: 3, resistance: "20kg", reps: "7 RP x 4 RP x 3", effort: "FALLO", notes: "" },

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

	gotExerciseData(exercise, records, dataModel, basescreen);
}
