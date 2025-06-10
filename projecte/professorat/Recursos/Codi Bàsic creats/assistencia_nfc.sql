
-- Creació de la base de dades (si no s'utilitza SQLite directament)
CREATE DATABASE IF NOT EXISTS assistencia_nfc;
USE assistencia_nfc;

-- Taula d'usuaris
CREATE TABLE usuaris (
    id_usuari INTEGER PRIMARY KEY AUTO_INCREMENT,
    nom TEXT NOT NULL,
    cognoms TEXT NOT NULL,
    tipus TEXT NOT NULL  -- alumne, professor, visitant...
);

-- Taula de targetes NFC
CREATE TABLE targetes (
    id_targeta TEXT PRIMARY KEY,  -- UID de la targeta
    id_usuari INTEGER NOT NULL,
    FOREIGN KEY (id_usuari) REFERENCES usuaris(id_usuari)
);

-- Taula d'accessos (registres d’assistència)
CREATE TABLE accessos (
    id_acces INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_targeta TEXT NOT NULL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    accio TEXT NOT NULL,  -- entrada, eixida...
    FOREIGN KEY (id_targeta) REFERENCES targetes(id_targeta)
);

-- Insercions de dades fictícies
INSERT INTO usuaris (nom, cognoms, tipus) VALUES
('Anna', 'Martínez López', 'alumne'),
('Joan', 'Gómez Ferrer', 'alumne'),
('Laura', 'Sanchis Ruiz', 'professor'),
('Pau', 'Navarro Blasco', 'alumne');

-- Associació d’UID de targetes als usuaris
INSERT INTO targetes (id_targeta, id_usuari) VALUES
('04A3F1671B', 1),
('0421B55D9A', 2),
('045CB3772E', 3),
('0498A1C4DD', 4);

-- Accessos simulats
INSERT INTO accessos (id_targeta, accio) VALUES
('04A3F1671B', 'entrada'),
('0421B55D9A', 'entrada'),
('045CB3772E', 'entrada'),
('0498A1C4DD', 'entrada'),
('04A3F1671B', 'eixida'),
('0421B55D9A', 'eixida');
