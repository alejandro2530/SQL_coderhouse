CREATE DATABASE IF NOT EXISTS db_neuro; 
USE db_neuro;

-- CREACION DE TABLAS-------------------------------
-- ----------TABLAS PADRES-----------------
CREATE TABLE IF NOT EXISTS profesionales
(
	idprofesional INT AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(255) NOT NULL,
    edad INT NOT NULL,
    sexo VARCHAR(20) NOT NULL,
	profesion VARCHAR(100) NOT NULL,
	especializacion VARCHAR(150) NOT NULL,          
	creado_el TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS deportistas
(
	iddeportista INT AUTO_INCREMENT PRIMARY KEY,
    edad INT NOT NULL,
    sexo VARCHAR(10) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    deporte VARCHAR(150) NOT NULL,
    entrenamiento_semanal INT NOT NULL
);
CREATE TABLE IF NOT EXISTS organizaciones
(
	idorganizacion INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    is_publico BOOL
);
CREATE TABLE IF NOT EXISTS apps
(
	idapp INT AUTO_INCREMENT PRIMARY KEY,
    app_nombre VARCHAR(100),
    destreza_entrenada VARCHAR(100) NOT NULL
);
CREATE TABLE IF NOT EXISTS metricas
(
	idmetrica INT AUTO_INCREMENT PRIMARY KEY,
    tiempo_reaccion_ms FLOAT,
    tiempo_desicion_ms FLOAT,
    aciertos INT,
    errores INT,
    porcentaje_aciertos DECIMAL,
    tiempo_memoria_trabajo FLOAT
);
CREATE TABLE IF NOT EXISTS dispositivos
(
	iddispositivo INT AUTO_INCREMENT PRIMARY KEY,
    dispositivo_nombre VARCHAR(50) NOT NULL
);
-- ----------TABLAS HIJAS-----------------
CREATE TABLE IF NOT EXISTS apps_y_metricas
(
	app_id INT NOT NULL,
    metrica_id INT NOT NULL,
    PRIMARY KEY(app_id, metrica_id),
    FOREIGN KEY (app_id) REFERENCES apps(idapp),
    FOREIGN KEY (metrica_id) REFERENCES metricas(idmetrica)
);
CREATE TABLE IF NOT EXISTS sesiones
(
	idsesion INT AUTO_INCREMENT PRIMARY KEY,
    idprofesional INT NOT NULL,
    iddeportista INT NOT NULL,
    idorganizacion INT NOT NULL,
    idapp INT NOT NULL,
    iddispositivo INT NOT NULL,
	started_at DATETIME NOT NULL,
	ended_at DATETIME NULL,
    FOREIGN KEY (idprofesional) REFERENCES profesionales(idprofesional),
    FOREIGN KEY (iddeportista) REFERENCES deportistas(iddeportista),
    FOREIGN KEY (idorganizacion) REFERENCES organizaciones(idorganizacion),
    FOREIGN KEY (idapp) REFERENCES apps(idapp),
    FOREIGN KEY (iddispositivo) REFERENCES dispositivos(iddispositivo)
);