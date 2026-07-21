pragma Singleton
import QtQuick

QtObject {

    function startDay() {
        console.log("Called Start day on thread manager");
        startedDay();
    }

    function getExerciseData() {
        var exercise = {
            id: 1,
            name: "Press Inclinado con Mancuernas",
            video: "https://youtu.be/J_x6MEFk3DM",
            guide: "[6 - 8]",
            notes: "Asiento nivel 6 \\n Test segunda linea"
        };

        var records = [
            {
                training: 1,
                resistance: "20kg",
                reps: "7",
                effort: "RIR 2",
                notes: ""
            },
            {
                training: 1,
                resistance: "20kg",
                reps: "8",
                effort: "RIR 1",
                notes: ""
            },
            {
                training: 1,
                resistance: "22.5kg",
                reps: "8 RP x (1 parcial)",
                effort: "FALLO",
                notes: ""
            },
            {
                training: 2,
                resistance: "22.5kg",
                reps: "6",
                effort: "RIR 2",
                notes: ""
            },
            {
                training: 2,
                resistance: "22.5kg",
                reps: "7",
                effort: "RIR 1",
                notes: ""
            },
            {
                training: 2,
                resistance: "25kg",
                reps: "4",
                effort: "FALLO",
                notes: ""
            },
            {
                training: 3,
                resistance: "22.5kg",
                reps: "7",
                effort: "RIR 2",
                notes: ""
            },
            {
                training: 3,
                resistance: "22.5kg",
                reps: "7 (1 parcial)",
                effort: "RIR 1",
                notes: ""
            },
            {
                training: 3,
                resistance: "20kg",
                reps: "7 RP x 4 RP x 3",
                effort: "FALLO",
                notes: "No se porque pero hoy no pude con 25 Kg y las de 22.5 estaban cogidas entonces me tocó con las de 20kg"
            },
            {
                training: 4,
                resistance: "20kg",
                reps: "8",
                effort: "RIR 2",
                notes: ""
            },
            {
                training: 4,
                resistance: "22.5kg",
                reps: "6",
                effort: "RIR 1",
                notes: ""
            },
            {
                training: 4,
                resistance: "22.5kg",
                reps: "8",
                effort: "FALLO",
                notes: "No pude hacer RP, cuando me intenté volver a poner las mancuernas no pude mantenerlas"
            },
            {
                training: 5,
                resistance: "22.5kg",
                reps: "6",
                effort: "RIR 2",
                notes: ""
            },
            {
                training: 5,
                resistance: "22.5kg",
                reps: "7",
                effort: "RIR 1",
                notes: ""
            },
            {
                training: 5,
                resistance: "25kg",
                reps: "4",
                effort: "FALLO",
                notes: ""
            }
        ];

        var routine = ["RIR 2", "RIR 1", "FALLO"];

        gotExerciseData(exercise, records, routine);
    }

    function completeExercise(records) {
        console.log(records);
        completedExercise(Math.random() < 0.7);
    }

    function getOnTraining() {
        gotOnTraining(Math.random() < 0.5);
    }

    signal startedDay
    signal gotExerciseData(var exercise, var records, var routine)
    signal completedExercise(var dayCompleted)
    signal gotOnTraining(var onTraining)
}
