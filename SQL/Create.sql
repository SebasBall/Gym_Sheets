CREATE TABLE Exercises (
	Id INTEGER PRIMARY KEY AUTOINCREMENT,
	Name TEXT NOT NULL,
	Day INT NOT NULL,
	"Order" INT NOT NULL,
	Video TEXT NOT NULL,
	Guide TEXT NOT NULL,
	Notes TEXT
);

CREATE TABLE SeriesTypes (
	Id INTEGER PRIMARY KEY AUTOINCREMENT,
	Type TEXT NOT NULL
);

INSERT INTO SeriesTypes (Type)
VALUES
('FALLO'),
('RIR 1'),
('RIR 2'),
('RPE 7'),
('RPE 8'),
('RPE 9'),
('RONDAS');

CREATE TABLE Series (
    ExerciseId INTEGER NOT NULL,
    "Order" INTEGER NOT NULL,
    SeriesType INTEGER NOT NULL,
    PRIMARY KEY (ExerciseId, "Order"),
    FOREIGN KEY (ExerciseId) REFERENCES Exercises(Id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (SeriesType) REFERENCES SeriesTypes(Id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Records (
    ExerciseId INTEGER NOT NULL,
    "Order" INTEGER NOT NULL,
    Resistance TEXT NOT NULL,
    Reps TEXT NOT NULL,
    Training INT NOT NULL,
    Notes TEXT,
    PRIMARY KEY (ExerciseId, "Order", Training),
    FOREIGN KEY (ExerciseId, "Order") REFERENCES Series(ExerciseId, "Order") ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE VIEW RecordsView AS
SELECT 
	r.ExerciseId,
	r.Resistance,
	r.Reps,
	st.Type AS Effort,
	r.Notes,
	r.Training
FROM Records r
JOIN Series s ON 
	r.ExerciseId = s.ExerciseId AND r."Order" = s."Order"
JOIN SeriesTypes st ON
	s.SeriesType = st.Id;

CREATE TABLE User (
	Id INT PRIMARY KEY CHECK (Id = 1),
	CurrentDay INT NOT NULL,
	CurrentExercise INT NOT NULL,
	NumExercisesToday INT NOT NULL
);

INSERT INTO User (Id, CurrentDay, CurrentExercise, NumExercisesToday)
VALUES
(1,1,1,1);
