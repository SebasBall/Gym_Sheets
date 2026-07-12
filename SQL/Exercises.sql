-- getExercise
SELECT Id, Name, Video, Guide, Notes FROM Exercises
WHERE "Order" = (SELECT CurrentExercise FROM User)
AND Day = ((SELECT CurrentDay - 1 FROM User) % (SELECT MAX(Day) FROM Exercises)) + 1;
