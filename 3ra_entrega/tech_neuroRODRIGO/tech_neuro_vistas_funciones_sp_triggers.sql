
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

-- Cantidad de deportistas y profesionales por organización
CREATE VIEW Deportistas_y_profesionales AS
SELECT 
	COUNT(p.nombre) AS nombre_profesionales,
    COUNT(d.nombre) AS nombre_deportista,
    o.nombre AS nombre_organizacion
FROM sesiones s
INNER JOIN profesionales p ON p.idprofesional = s.idprofesional 
INNER JOIN deportistas d ON d.iddeportista = s.iddeportista
INNER JOIN organizaciones o ON o.idorganizacion = s.idorganizacion
GROUP BY o.idorganizacion, o.nombre;


-- ---------------------FUNCIONES----------------------------------------------------
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
CREATE FUNCTION f_cantidad_uso_app(p_app_name VARCHAR(100))
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE v_cantidad_uso INT DEFAULT 0;
    SELECT COUNT(*)
    INTO v_cantidad_uso
    FROM sesiones s
    INNER JOIN apps a ON a.idapp = s.idapp
    WHERE a.app_nombre = p_app_name;
    
    RETURN v_cantidad_uso;
END// 

-- Conocer cuántas sesiones lleva una organización.
DELIMITER //

CREATE FUNCTION f_cantidad_sesiones_org(p_org_nombre VARCHAR(150))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_cantidad INT DEFAULT 0;

    SELECT COUNT(*)
    INTO v_cantidad
    FROM sesiones s
    INNER JOIN organizaciones o ON o.idorganizacion = s.idorganizacion
    WHERE o.nombre = p_org_nombre;

    RETURN v_cantidad;
END//



-- ---------------------STORED PROCEDURE----------------------------------------------------
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

-- Devuelve, para una organización, cuántas veces se usó cada app en sus sesiones.
DELIMITER //

CREATE PROCEDURE sp_reporte_uso_apps_por_org(IN p_org_nombre VARCHAR(150))
BEGIN
    SELECT 
        o.nombre AS organizacion,
        a.app_nombre AS app,
        COUNT(s.idsesion) AS cantidad_usos
    FROM sesiones s
    INNER JOIN organizaciones o ON o.idorganizacion = s.idorganizacion
    INNER JOIN apps a ON a.idapp = s.idapp
    WHERE o.nombre = p_org_nombre
    GROUP BY o.nombre, a.app_nombre;
END//

-- --------------------- TRIGGER----------------------------------------------------
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

CREATE TRIGGER IF NOT EXISTS trg_auditoria_insercion_app
AFTER INSERT ON apps 
FOR EACH ROW
INSERT INTO auditoria_apps VALUES
(DEFAULT,NEW.idapp, NEW.app_nombre, NEW.destreza_entrenada, USER(), NOW(),'se inserto una nueva app');

-- Auditoria sesion (TRIGGER de insercion)
CREATE TABLE sesiones_auditoria (
    id_audit INT AUTO_INCREMENT PRIMARY KEY,
    idsesion INT,
    accion VARCHAR(20),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER trg_insert_sesion_auditoria
AFTER INSERT ON sesiones
FOR EACH ROW
BEGIN
    INSERT INTO sesiones_auditoria (idsesion, accion)
    VALUES (NEW.idsesion, 'nueva sesion');
END//


