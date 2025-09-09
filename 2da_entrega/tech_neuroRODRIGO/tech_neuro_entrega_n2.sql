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
-- INSERCION DE REGISTROS
-- ------------------------------------------TABLAS PADRES-------------------------------------------------------
INSERT INTO profesionales (nombre, edad, sexo, profesion, especializacion) VALUES
('Mariana Torres', 32, 'Femenino', 'Preparadora Física', 'Entrenamiento de fuerza y acondicionamiento'),
('Diego Fernández', 40, 'Masculino', 'Entrenador', 'Fútbol de alto rendimiento'),
('Lucía Pérez', 29, 'Femenino', 'Nutricionista', 'Nutrición deportiva'),
('Javier López', 35, 'Masculino', 'Kinesiólogo', 'Prevención y rehabilitación de lesiones deportivas'),
('Valentina Ríos', 27, 'Femenino', 'Psicóloga', 'Psicología del deporte y motivación'),
('Andrés Ramírez', 38, 'Masculino', 'Entrenador', 'Atletismo y resistencia aeróbica'),
('Camila Herrera', 31, 'Femenino', 'Preparadora Física', 'Entrenamiento funcional'),
('Martín Gómez', 44, 'Masculino', 'Médico', 'Medicina deportiva'),
('Florencia Díaz', 30, 'Femenino', 'Fisioterapeuta', 'Recuperación post-competencia'),
('Tomás Sánchez', 37, 'Masculino', 'Entrenador', 'Rugby y fuerza explosiva'),
('Gabriela Medina', 41, 'Femenino', 'Kinesióloga', 'Rehabilitación musculoesquelética'),
('Rodrigo Paredes', 28, 'Masculino', 'Entrenador', 'CrossFit y halterofilia'),
('Elena Vargas', 34, 'Femenino', 'Preparadora Física', 'Entrenamiento de velocidad y agilidad'),
('Francisco Castro', 39, 'Masculino', 'Entrenador', 'Básquet y preparación física'),
('Julieta Morales', 33, 'Femenino', 'Nutricionista', 'Suplementación deportiva'),
('Pablo Navarro', 42, 'Masculino', 'Entrenador', 'Natación competitiva'),
('Rocío Suárez', 36, 'Femenino', 'Psicóloga', 'Gestión del estrés en el deporte'),
('Ignacio Benítez', 45, 'Masculino', 'Entrenador', 'Deportes de combate'),
('Carolina Fuentes', 29, 'Femenino', 'Entrenadora', 'Vóley profesional'),
('Hernán Aguilar', 50, 'Masculino', 'Médico', 'Cardiología aplicada al deporte');

INSERT INTO deportistas (edad, sexo, nombre, deporte, entrenamiento_semanal) VALUES
(19, 'Femenino', 'Camila Torres', 'Atletismo - 400m', 5),
(21, 'Masculino', 'Martín Rivas', 'Fútbol', 6),
(23, 'Femenino', 'Julieta Herrera', 'Natación competitiva', 8),
(24, 'Masculino', 'Diego Morales', 'Rugby', 7),
(20, 'Femenino', 'Sofía Ramírez', 'Gimnasia artística', 6),
(27, 'Masculino', 'Lucas Fernández', 'Básquet', 5),
(22, 'Femenino', 'Carolina Díaz', 'Tenis', 6),
(28, 'Masculino', 'Hernán López', 'Boxeo', 9),
(26, 'Femenino', 'Valeria Gómez', 'Vóley profesional', 5),
(25, 'Masculino', 'Ricardo Vargas', 'Ciclismo ruta', 7),
(30, 'Femenino', 'Mariana Paredes', 'Hockey sobre césped', 6),
(32, 'Masculino', 'Pablo Navarro', 'Triatlón', 10),
(24, 'Femenino', 'Lucía Suárez', 'Patinaje artístico', 6),
(29, 'Masculino', 'Javier Medina', 'Artes marciales mixtas', 8),
(31, 'Femenino', 'Rocío Benítez', 'Escalada deportiva', 5),
(33, 'Masculino', 'Fernando Castro', 'CrossFit', 6),
(35, 'Femenino', 'Gabriela Ortiz', 'Remo olímpico', 8),
(36, 'Masculino', 'Carlos Aguirre', 'Handball', 5),
(38, 'Femenino', 'Elena Vargas', 'Esgrima', 4),
(40, 'Masculino', 'Roberto Sánchez', 'Maratón', 7);

INSERT INTO organizaciones (nombre, is_publico) VALUES
('Club Atlético San Martín', TRUE),
('Centro de Alto Rendimiento Olímpico', TRUE),
('Instituto Privado de Preparación Física Elite', FALSE),
('Escuela Universitaria de Ciencias del Deporte', TRUE),
('Academia ProSport Performance', FALSE);

INSERT INTO apps (app_nombre, destreza_entrenada) VALUES
('ap_TR', 'Tiempo de Respuesta'),
('ap_MT', 'Memoria de Trabajo'),
('ap_IR', 'Inhibición Reactiva');

INSERT INTO metricas 
(tiempo_reaccion_ms, tiempo_desicion_ms, aciertos, errores, porcentaje_aciertos, tiempo_memoria_trabajo) VALUES
(320.5, 500.2, 15, 3, 83.33, 420.1),
(280.7, 460.0, 18, 2, 90.00, 380.4),
(350.1, 510.3, 12, 5, 70.59, 410.9),
(295.2, 470.6, 20, 1, 95.24, 390.0),
(310.8, 490.5, 16, 4, 80.00, 400.7),
(270.4, 455.1, 22, 0, 100.00, 370.2),
(330.9, 520.7, 14, 6, 70.00, 430.8),
(305.5, 480.9, 19, 2, 90.48, 395.6),
(340.2, 530.3, 13, 7, 65.00, 415.2),
(285.7, 465.4, 21, 1, 95.45, 385.3);

-- ------------------------------------------TABLAS HIJAS-------------------------------------------------------
-- ap_TR (Tiempo de Respuesta) → tiempo_reaccion_ms (1), aciertos (3)
INSERT INTO apps_y_metricas (app_id, metrica_id) VALUES
(1, 1),
(1, 3);

-- ap_MT (Memoria de Trabajo) → tiempo_memoria_trabajo (6), aciertos (3)
INSERT INTO apps_y_metricas (app_id, metrica_id) VALUES
(2, 6),
(2, 3);

-- ap_IR (Inhibición Reactiva) → tiempo_desicion_ms (2), errores (4), porcentaje_aciertos (5)
INSERT INTO apps_y_metricas (app_id, metrica_id) VALUES
(3, 2),
(3, 4),
(3, 5);

INSERT INTO dispositivos (dispositivo_nombre) VALUES
('Kinect V2'),
('MediaPipe'),
('Meta Quest 3'),
('Kinect V2'),
('MediaPipe'),
('Meta Quest 3'),
('Kinect V2'),
('MediaPipe'),
('Meta Quest 3'),
('Kinect V2');

INSERT INTO sesiones (idprofesional, iddeportista, idorganizacion, idapp, iddispositivo, started_at, ended_at) VALUES
(1, 1, 1, 2, 1, '2025-09-01 10:00:00', '2025-09-01 10:30:00'),
(2, 2, 2, 1, 2, '2025-09-01 11:00:00', '2025-09-01 11:40:00'),
(3, 3, 3, 1, 3, '2025-09-01 12:00:00', '2025-09-01 12:45:00'),
(4, 4, 4, 2, 2, '2025-09-02 09:00:00', '2025-09-02 09:40:00'),
(5, 5, 5, 1, 1, '2025-09-02 10:00:00', '2025-09-02 10:30:00'),
(1, 6, 1, 3, 3, '2025-09-02 11:00:00', '2025-09-02 11:45:00'),
(2, 7, 2, 1, 1, '2025-09-03 09:30:00', '2025-09-03 10:00:00'),
(3, 8, 3, 2, 2, '2025-09-03 10:15:00', '2025-09-03 10:50:00'),
(4, 9, 4, 3, 3, '2025-09-03 11:30:00', '2025-09-03 12:10:00'),
(5, 10, 5, 3, 2, '2025-09-03 14:00:00', '2025-09-03 14:40:00'),

(1, 2, 1, 3, 1, '2025-09-04 09:00:00', '2025-09-04 09:30:00'),
(2, 3, 2, 3, 2, '2025-09-04 10:00:00', '2025-09-04 10:45:00'),
(3, 4, 3, 2, 3, '2025-09-04 11:00:00', '2025-09-04 11:30:00'),
(4, 5, 4, 2, 1, '2025-09-04 12:00:00', '2025-09-04 12:30:00'),
(5, 6, 5, 2, 2, '2025-09-04 13:00:00', '2025-09-04 13:40:00'),
(1, 7, 1, 3, 3, '2025-09-05 09:00:00', '2025-09-05 09:30:00'),
(2, 8, 2, 2, 2, '2025-09-05 10:00:00', '2025-09-05 10:45:00'),
(3, 9, 3, 1, 1, '2025-09-05 11:00:00', '2025-09-05 11:40:00'),
(4, 10, 4, 1, 2, '2025-09-05 12:00:00', '2025-09-05 12:30:00'),
(5, 1, 5, 1, 3, '2025-09-05 14:00:00', '2025-09-05 14:50:00'),

(1, 3, 1, 1, 1, '2025-09-06 09:00:00', '2025-09-06 09:40:00'),
(2, 4, 2, 1, 2, '2025-09-06 10:00:00', '2025-09-06 10:30:00'),
(3, 5, 3, 2, 3, '2025-09-06 11:00:00', '2025-09-06 11:35:00'),
(4, 6, 4, 1, 1, '2025-09-06 12:00:00', '2025-09-06 12:30:00'),
(5, 7, 5, 1, 2, '2025-09-06 14:00:00', '2025-09-06 14:40:00'),
(1, 8, 1, 2, 3, '2025-09-07 09:00:00', '2025-09-07 09:30:00'),
(2, 9, 2, 2, 1, '2025-09-07 10:00:00', '2025-09-07 10:45:00'),
(3, 10, 3, 1, 2, '2025-09-07 11:00:00', '2025-09-07 11:30:00'),
(4, 1, 4, 2, 3, '2025-09-07 12:00:00', '2025-09-07 12:40:00'),
(5, 2, 5, 2, 1, '2025-09-07 14:00:00', '2025-09-07 14:30:00');
-- --------------------------VISTAS----------------------------------------------------
-- Detalle de las sesiones
CREATE VIEW sesiones_detalladas AS
SELECT
	p.nombre AS nombre_profesionales,
    d.nombre AS nombre_deportista,
    o.nombre AS nombre_organizacion,
    a.app_nombre AS nombre_aplicacion,
    dis.dispositivo_nombre AS nombre_dispositivo,
    s.started_at AS inicio_sesion,
    s.ended_at AS fin_sesion
FROM sesiones s
INNER JOIN profesionales p ON p.idprofesional = s.idprofesional 
INNER JOIN deportistas d ON d.iddeportista = s.iddeportista
INNER JOIN organizaciones o ON o.idorganizacion = s.idorganizacion
INNER JOIN dispositivos dis ON dis.iddispositivo = s.iddispositivo
INNER JOIN apps a ON a.idapp = s.idapp
ORDER BY dis.dispositivo_nombre;

-- Cantida de deportistas que usaron los dispositivos
CREATE VIEW frecuencia_uso_dispositivos AS
SELECT
    dis.dispositivo_nombre AS nombre_dispositivo,
    COUNT(DISTINCT d.iddeportista) AS cantidad_deportistas
FROM sesiones s
INNER JOIN deportistas d ON s.iddeportista = d.iddeportista
INNER JOIN dispositivos dis ON s.iddispositivo = dis.iddispositivo
GROUP BY dis.dispositivo_nombre
ORDER BY cantidad_deportistas DESC;

-- Cantidad de veces que se usaron las aplicaciones
CREATE VIEW usos_aplicaciones AS
SELECT 
    a.app_nombre AS nombre_aplicacion,
    COUNT(s.idsesion) AS cantidad_usos
FROM sesiones s
INNER JOIN apps a ON a.idapp = s.idapp
GROUP BY a.app_nombre;

-- ---------------------FUNCIONES---------------------
-- Conocer la cantidad de dias de entrenamiento del deportista
DELIMITER //
CREATE FUNCTION f_dias_entrenamiento(p_iddeportista INT)
RETURNS INT 
DETERMINISTIC
BEGIN
	DECLARE v_cantidad_dias INT;
	    SELECT COUNT(DISTINCT DATE(started_at))
		INTO v_cantidad_dias
		FROM sesiones
		WHERE iddeportista = p_iddeportista;
    RETURN v_cantidad_dias;
END//

-- Conocer la cantidad de veces que se utilizo una app especifica
DELIMITER //
CREATE FUNCTION f_cantidad_uso_app(p_app_name VARCHAR(20))
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE v_cantidad_uso INT;
    
    SELECT COUNT(*)
    INTO v_cantidad_uso
    FROM sesiones s
    INNER JOIN apps a ON a.idapp = s.idapp
    WHERE a.app_nombre = p_app_name;
    
    RETURN v_cantidad_uso;
END// 

-- ---------------------STORED PROCEDURE---------------------
-- Insertar un nuevo app
DELIMITER //
CREATE PROCEDURE sp_insertar_app(IN p_nueva_app VARCHAR(100), IN p_nueva_destreza VARCHAR(100))
BEGIN
	-- Verificamos si el parametro esta vacio
    IF p_nueva_app = '' THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'ERROR: no se pudo insertar la app';
	ELSE
    -- Insertamos nuevo producto
		INSERT INTO apps (app_nombre,destreza_entrenada)
        VALUES (p_nueva_app,p_nueva_destreza);
    
	-- Mostramos los registros ordenados descendentemente
    SELECT * 
    FROM apps
    ORDER BY idapp DESC;
    END IF;
END//
-- --------------------- TRIGGER---------------------
-- Auditorias apps (TRIGGER de insercion)
CREATE TABLE auditoria_apps
(
	id_auditoria_apps INT AUTO_INCREMENT PRIMARY KEY,
    idapp INT NOT NULL,
    app_nombre VARCHAR(100),
    destreza_entrenada VARCHAR(100) NOT NULL,
    usuario VARCHAR(100) NOT NULL,
    fecha DATETIME NOT NULL,
    detalle VARCHAR(100)
);

CREATE TRIGGER IF NOT EXISTS auditoria_insercion_app
AFTER INSERT ON apps 
FOR EACH ROW
INSERT INTO auditoria_apps VALUES
(DEFAULT,NEW.idapp, NEW.app_nombre, NEW.destreza_entrenada, USER(), NOW(),'se inserto una nueva app');

-- ejemplo VISTAS
SELECT * FROM sesiones_detalladas;	
SELECT * FROM frecuencia_uso_dispositivos;
SELECT * FROM usos_aplicaciones;

-- ejemplo FUNCIONES
SELECT f_dias_entrenamiento(3); -- 3 dias de entrenamiento
SELECT f_dias_entrenamiento(7); -- 2 dias de entrenamiento
SELECT f_cantidad_uso_app(ap_TR); -- se uso 12 veces

-- ejemplo STORED PROCEDURE Y TRIGGER
CALL sp_insertar_app('Axismova', 'ROM_articular'); -- inserto una nueva app
SELECT * FROM db_neuro.auditoria_apps; -- visualizo la tabla auditoria completada por el trigger









 
