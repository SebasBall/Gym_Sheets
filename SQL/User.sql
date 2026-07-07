-- name: startDay
UPDATE User 
SET NumExercisesToday = 
(SELECT MAX("Order") FROM Exercises WHERE Day = (SELECT CurrentDay FROM User)),
CurrentExercise = 1;
