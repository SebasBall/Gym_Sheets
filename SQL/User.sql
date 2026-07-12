-- startDay
UPDATE User 
SET
CurrentDay = CurrentDay + 1,
NumExercisesToday = 
	(SELECT MAX("Order") FROM Exercises
	WHERE Day = ((SELECT CurrentDay FROM User) % (SELECT MAX(Day) FROM Exercises)) + 1),
CurrentExercise = 1;


-- checkDayCompleted
SELECT IF(CurrentExercise + 1 > NumExercisesToday,true,false) AS Completed FROM User;

-- updateCurrentExercise
UPDATE User SET CurrentExercise = CurrentExercise + 1;


