-- getRecords
SELECT Resistance, Reps, Effort, Notes, Training
FROM RecordsView 
WHERE ExerciseId = :exerciseId
ORDER BY Training ASC;

-- setTodayRecord
INSERT INTO TodayRecords (ExerciseId, "Order", Resistance, Reps, Training, Notes)
VALUES
	((SELECT Id FROM Exercises 
		WHERE "Order" = (SELECT CurrentExercise FROM User)
		AND Day = ((SELECT CurrentDay - 1 FROM User) % (SELECT MAX(Day) FROM Exercises)) + 1),
	:ord,
	:resistance,
	:reps,
	:training,
	:notes);

-- getTodayRecords
SELECT Name, Resistance, Reps, Effort, Notes
FROM TodayRecordsView
ORDER BY Id ASC;

-- setRecords
INSERT INTO Records (ExerciseId, "Order", Resistance, Reps, Training, Notes)
SELECT ExerciseId, "Order", Resistance, Reps, Training, Notes
FROM TodayRecords;

-- clearTodayRecords
DELETE FROM TodayRecords;

-- resetTodayRecords
DELETE FROM sqlite_sequence WHERE name = 'TodayRecords';
