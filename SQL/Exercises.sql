-- name: getExercise
SELECT Id, Name, Video, Guide, Notes FROM Exercises
WHERE "Order" = (SELECT CurrentExercise FROM User)
AND Day = (SELECT CurrentDay FROM User);
