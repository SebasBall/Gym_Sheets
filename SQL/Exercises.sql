CREATE TABLE Exercises (
	Id INTEGER PRIMARY KEY AUTOINCREMENT,
	Name TEXT NOT NULL,
	Day INT NOT NULL,
	Video TEXT NOT NULL,
	Guide TEXT NOT NULL,
	Notes TEXT
);

INSERT INTO Exercises (Name, Day, Video, Guide, Notes)
VALUES
-- Day 1
("Press Inclinado con Mancuernas", 1, "https://youtu.be/J_x6MEFk3DM", "[6 - 8]", "Asiento nivel 6"),
("Apertura de Pectoral en Máquina", 1, "https://youtu.be/a9vQ_hwIksU", "[12 - 16] [12 - 16] [10 - 14]", "Asiento lo mas alto posible\nLas placas pesan 15kg en teoría, pero la primera pesa 10kg"),
("Empuje Frontal en Máquina", 1, "https://youtu.be/AsK9KDc-vG8", "[8 - 12]", "Asiento nivel 2"),
("Press de Hombro en Máquina", 1, "https://youtu.be/WvLMauqrnK8", "[10 - 12] [8 - 10] [6 - 10]", "Asiento abajo del 5\nLas primeras 5 placas son de 10kg y el resto de 15 kg"),
("Extensiones Katana", 1, "https://youtu.be/bJ9bm-aJ7No", "[10 - 12]", NULL),

-- Day 2
("Remo Horizontal Sentado", 2, "https://youtu.be/w2Kkk0uR2EU", "[8 - 10] [8 - 10] [6 - 8]", "5 Grados el asiento, 7 medio altura"),
("Jalones al Pecho (Agarre Neutro)", 2, "https://youtu.be/InXmIKVNwCU", "[10 - 12]", NULL),
("Remo Máquina Diagonal Unilateral", 2, "https://youtu.be/1u0pcZP0OZY", "[8 - 10]", NULL),
("Drag Curl de Bíceps con Barra", 2, "https://youtu.be/4jwx6O1q4Dg", "[8 - 12]", NULL),
("Curl de Bíceps Sentado con Mancuernas", 2, "https://youtu.be/DTdrS09a9NA", "[6 - 10]", "Asiento nivel 5"),
("Elevaciones Laterales en Máquina", 2, "https://youtu.be/f_OGBg2KxgY", "[6 - 10]", NULL),

-- Day 3
("Sentadilla Hack", 3, "https://youtu.be/k9JAabIHdEo", "[8 - 12]", NULL),
("Extensión de Cuadriceps en Máquina", 3, "https://youtu.be/oQM875T39M4", "[12 - 15]", "Maquina Life Fitness\nAsiento distancia 7\nPendulo largo M"),
("Prensa Horizontal", 3, "https://youtu.be/PBnh2I0nxmc", "[10 - 14]", "Asiento lo mas bajo posible"),
("Abductores en Máquina", 3, "https://youtu.be/_nwuScrS-kg", "[8 - 12]", "Maquina Hammer Strength"),
("Extensión de Tobillo con Banda", 3, "https://youtu.be/Re7XMKgAti8", "[12 - 16]", NULL),
("Eversion e Inversion de Tobillo con Banda", 3, "https://youtu.be/fw_U2B7sfHA", "[12 - 16]", NULL),
("Dorsiflexión", 3, "https://youtu.be/5YUh4lOQ2pI", "[12 - 16]", NULL),
("Estocada de Tobillo con Banda", 3, "https://youtu.be/n6rjn2Fx5tg", "[8 - 12]", NULL),
("Estabilidad con KB", 3, "https://youtu.be/XemHd4qzqKk", "40 seg", NULL),

-- Day 5
("Pull Ups", 5, "https://youtu.be/eDP_OOhMTZ4", "[16]", NULL),
("Fondos en Paralelas", 5, "https://youtu.be/NnJEg52IGjI", "[16]", NULL),
("Yoga Push Ups", 5, "https://youtu.be/qsUZh0rlubM", "[8 - 16]", NULL),
("Wood Choops Máquinas", 5, "https://youtu.be/90Qh5XG6mqs", "[10 - 14]", NULL),
("Plancha Dinamica KB", 5, "https://youtu.be/odo0h50hfwY", "40 seg | 3 Rondas", NULL),
("Plancha Lateral en Banco", 5, "https://youtu.be/aDsaGBnvDQo", "30 Seg | 3 Rondas", NULL),

-- Day 6

("Peso Muerto", 6, "https://youtu.be/7BdVi5qJ7E4", "[6 - 8]", NULL),
("Curl de Isquios en Máquina", 6, "https://youtu.be/6IvQvWZmEsw", "[12 - 15]", "Maquina Hammer strength"),
("Lunge en Smith", 6, "https://youtu.be/ngxMg0nuPyY", "[6 - 8]", NULL),
("Puente Glúteo en Máquina", 6, "https://youtu.be/zzFpqhVxxj8", "[6 - 8]", NULL),
("Elevación de Pantorrilla en Smith", 6, "https://youtu.be/wlqTemUXPXY", "[10 - 14]", NULL);
