-- getRecords
SELECT Resistance, Reps, Effort, Notes, Training
FROM RecordsView 
WHERE ExerciseId = :exerciseId
ORDER BY Training ASC;

-- setRecord
INSERT INTO Records (ExerciseId, "Order", Resistance, Reps, Training, Notes)
VALUES
	((SELECT Id FROM Exercises 
		WHERE "Order" = (SELECT CurrentExercise FROM User)
		AND Day = ((SELECT CurrentDay - 1 FROM User) % (SELECT MAX(Day) FROM Exercises)) + 1),
	:ord,
	:resistance,
	:reps,
	:training,
	:notes);
