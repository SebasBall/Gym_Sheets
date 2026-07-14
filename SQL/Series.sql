-- getRoutine
SELECT st.Type AS Effort 
FROM Series s 
JOIN SeriesTypes st ON s.SeriesType = st.Id 
WHERE ExerciseId = :exerciseId;
