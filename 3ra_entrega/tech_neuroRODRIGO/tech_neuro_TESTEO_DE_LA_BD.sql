-- ejemplo VISTAS
SELECT * FROM sesiones_detalladas;	
SELECT * FROM frecuencia_uso_dispositivos;
SELECT * FROM usos_aplicaciones;
SELECT * FROM Deportistas_y_profesionales;

-- ejemplo FUNCIONES
SELECT f_dias_entrenamiento(3) AS entrenamientos; -- 3 dias de entrenamiento
SELECT f_dias_entrenamiento(7) AS entrenamientos; -- 3 dias de entrenamiento
SELECT f_cantidad_uso_app("ap_MT") AS Usos_de_la_APP; -- se uso 12 veces
SELECT f_cantidad_sesiones_org('Club Atlético San Martín'); -- 6 sesiones

-- ejemplo STORED PROCEDURE (para incertar apps y a la vez llamar a un trigger)
CALL sp_insertar_app('KIVA', 'ERGONOMIC_TEST'); -- inserto una nueva app (trigger - auditoria_apps)
CALL sp_reporte_uso_apps_por_org('Centro de Alto Rendimiento Olímpico'); -- inserto una nueva app (trigger - auditoria_apps)

-- ejemplo TRIGGER
	-- TRG1 - Auditoria apps
SELECT * FROM db_neuro.auditoria_apps AS audiotoria_apps; -- visualizo la tabla auditoria completada por el trigger

	-- TRG 2 - Auditoria sesiones
		-- incerto una sesion
		INSERT INTO sesiones (idprofesional, iddeportista, idorganizacion, idapp, iddispositivo, started_at, ended_at)
		VALUES (1, 5, 1, 2, 2, '2025-09-10 09:00:00', '2025-09-10 09:30:00');
SELECT * FROM sesiones_auditoria AS auditoria_sesion;-- visualizo la tabla auditoria de sesion completada por el trigger
