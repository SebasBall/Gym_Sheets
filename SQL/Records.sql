-- name: getRecords
SELECT Resistance, Reps, Type, Notes, Training
FROM RecordsView 
WHERE ExerciseId = :exerciseId
ORDER BY Training ASC;

-- name: setRecord
INSERT INTO Records (ExerciseId, "Order", Resistance, Reps, Training, Notes)
VALUES
((SELECT CurrentExercise FROM User),
	:ord,
	:resistance,
	:reps,
	:training,
	:notes);
