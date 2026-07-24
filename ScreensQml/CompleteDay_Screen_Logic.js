.pragma library

function appendTodayRecords(todayData, listModel) {
	var exercise = {};
	var record = {};
	var notes = "";
	for (var i = 0; i < todayData.length; i++) {
		exercise = todayData[i];
		if (i == 0) {
			listModel.append({
				rowType: "1Label",
				isTitle: true,
				isStart: true,
				text: exercise.name
			});
		} else {
			listModel.append({
				rowType: "1Label",
				isTitle: true,
				text: exercise.name
			});
		}

		listModel.append({
			rowType: "3Label",
			text1: "Resistance",
			text2: "Reps",
			text3: "Effort",
			isTitle: true
		})

		notes = ""

		for (var j = 0; j < exercise.records.length; j++) {
			record = exercise.records[j]

			if (record.notes != "" && notes != "") {
				notes += "\n" + record.notes
			} else {
				notes += record.notes
			}

			if (i + 1 == todayData.length && j + 1 == exercise.records.length && notes == "") {
				listModel.append({
					rowType: "3Label",
					isEnd: true,
					text1: record.resistance,
					text2: record.reps,
					text3: record.effort,
					notes: notes
				})
			} else {
				listModel.append({
					rowType: "3Label",
					text1: record.resistance,
					text2: record.reps,
					text3: record.effort,
				})
			}

			if (j + 1 == exercise.records.length && notes != "") {
				listModel.append({
					rowType: "1Label",
					text: notes,
					isEnd: (i + 1 == todayData.length)
				})
			}
		}
	}

	listModel.append({
		rowType: "Spacer",
		height: 40
	})
	listModel.append({
		rowType: "1Button",
	})
}
