CREATE DATABASE IF NOT EXISTS tech_usage;
USE tech_usage;

-- Organizaciones
CREATE TABLE IF NOT EXISTS organizations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  country VARCHAR(100),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Profesionales
CREATE TABLE IF NOT EXISTS professionals (
  id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(255) NOT NULL,
  profession VARCHAR(100) NOT NULL,
  specialization VARCHAR(150) NOT NULL,          
  org_id INT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (org_id) REFERENCES organizations(id)
);

-- Aplicaciones
CREATE TABLE IF NOT EXISTS apps (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  platform VARCHAR(100),                
  version VARCHAR(50),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Features
CREATE TABLE IF NOT EXISTS features (
  id INT AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(100) NOT NULL UNIQUE,    
  name VARCHAR(150) NOT NULL,           
  description TEXT
);

-- Relación app ↔ features
CREATE TABLE IF NOT EXISTS app_features (
  app_id INT NOT NULL,
  feature_id INT NOT NULL,
  PRIMARY KEY (app_id, feature_id),
  FOREIGN KEY (app_id) REFERENCES apps(id),
  FOREIGN KEY (feature_id) REFERENCES features(id)
);

-- Dispositivos
CREATE TABLE devices (
  id INT AUTO_INCREMENT PRIMARY KEY,
  device_type VARCHAR(100),              
  os_version VARCHAR(100)
);

-- Sesiones (ID entero incremental)
CREATE TABLE IF NOT EXISTS sessions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  professional_id INT NOT NULL,
  app_id INT NOT NULL,
  device_id INT,
  started_at DATETIME NOT NULL,
  ended_at DATETIME NULL,
  context_tag VARCHAR(100),
  CONSTRAINT fk_s_prof FOREIGN KEY (professional_id) REFERENCES professionals(id),
  CONSTRAINT fk_s_app FOREIGN KEY (app_id) REFERENCES apps(id),
  CONSTRAINT fk_s_dev FOREIGN KEY (device_id) REFERENCES devices(id)
);

-- Eventos de features (session_id INT)
CREATE TABLE IF NOT EXISTS feature_events (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  session_id INT NOT NULL,
  feature_id INT NOT NULL,
  occurred_at DATETIME NOT NULL,
  action VARCHAR(50) NOT NULL,
  value_numeric DOUBLE NULL,
  value_text VARCHAR(255) NULL,
  CONSTRAINT fk_fe_session FOREIGN KEY (session_id) REFERENCES sessions(id),
  CONSTRAINT fk_fe_feature FOREIGN KEY (feature_id) REFERENCES features(id)
);

-- Insertar organizaciones
INSERT INTO organizations (name, country) VALUES
('CERKIDE', 'AR'),
('CONAR', 'AR'),
('KINESALUD', 'AR'),
('Hospital Marcial Quiroga', 'AR'),
('Hospital Rawson', 'AR'),
('PhysioMove', 'AR');

-- Insertar profesionales
INSERT INTO professionals (full_name, profession, specialization, org_id) VALUES
('Ana Pérez', 'Kinesiólogo', 'Traumatología', 1),
('Juan López', 'Kinesiólogo', 'Neurorehabilitación', 1),
('María Fernández', 'Fisioterapeuta', 'Rehabilitación respiratoria', 2),
('Luis Gómez', 'Kinesiólogo', 'Deportiva', 2),
('Paula Martínez', 'Kinesiólogo', 'Rehabilitación neuromuscular', 3),
('Sofía Herrera', 'Fisioterapeuta', 'Geriatría', 3),
('Roberto Díaz', 'Kinesiólogo', 'Traumatología', 4),
('Claudia Sánchez', 'Kinesiólogo', 'Cardiopulmonar', 4),
('Matías Torres', 'Fisioterapeuta', 'Rehabilitación de mano', 5),
('Carla Romero', 'Kinesiólogo', 'Dolor crónico', 5),
('Federico Castro', 'Kinesiólogo', 'UCI', 6),
('Verónica Ruiz', 'Fisioterapeuta', 'Pediátrica', 6),
('Pablo Álvarez', 'Kinesiólogo', 'Vestibular', 1),
('Natalia Ríos', 'Fisioterapeuta', 'Rehabilitación post-ictus', 3),
('Diego Bustos', 'Kinesiólogo', 'Prevención de lesiones', 2);

-- Insertar apps
INSERT INTO apps (name, platform, version) VALUES
('Interruptor de Postura', 'Kinect', '1.0.0'),
('Cubos Terapéuticos', 'Quest', '1.0.1'),
('Reacción Rítmica', 'MP', '1.2.0'),
('Equilibrio Extremo', 'Quest', '1.3.0'),
('Pulso Motor', 'Quest', '1.4.0');

-- Insertar features
INSERT INTO features (code, name) VALUES
('therapy_battery','Barra de batería terapéutica'),
('timed_response','Medición de tiempo de reacción'),
('random_targets','Aparición aleatoria de objetivos'),
('visual_cues','Estimulación visual con patrones'),
('audio_cues','Estimulación auditiva'),
('force_control','Control de fuerza aplicada'),
('range_tracking','Seguimiento de rango articular'),
('dual_task','Tareas dobles (cognitivo + motor)'),
('session_log','Registro y almacenamiento de sesión');

-- App features
INSERT INTO app_features (app_id, feature_id) VALUES
(1, 1), (1, 8), (1, 9),
(2, 3), (2, 4), (2, 7), (2, 9),
(3, 2), (3, 4), (3, 5), (3, 9),
(4, 3), (4, 6), (4, 7), (4, 9),
(5, 2), (5, 4), (5, 5), (5, 6), (5, 9);

-- Sesiones
INSERT INTO sessions (professional_id, app_id, device_id, started_at, context_tag) VALUES
(1, 1, NULL, NOW(), 'UCI'),
(2, 2, NULL, NOW(), 'Rehabilitación ambulatoria'),
(3, 3, NULL, NOW(), 'Evaluación inicial'),
(4, 4, NULL, NOW(), 'Terapia de equilibrio'),
(5, 5, NULL, NOW(), 'Entrenamiento de fuerza'),
(6, 1, NULL, NOW(), 'Terapia combinada'),
(7, 2, NULL, NOW(), 'Sesión cognitivo-motora'),
(8, 3, NULL, NOW(), 'Estimulación sensorial'),
(9, 4, NULL, NOW(), 'Rehabilitación post-lesión'),
(10, 5, NULL, NOW(), 'Evaluación funcional');

-- Vista simple de sesiones
CREATE OR REPLACE VIEW v_sessions_simple AS
SELECT id AS session_id,
       professional_id, app_id, device_id, started_at, ended_at, context_tag
FROM sessions;

-- Vista actividad por profesional
CREATE OR REPLACE VIEW v_professional_activity AS
SELECT p.full_name, p.profession, p.specialization,
       o.name AS organization, COUNT(DISTINCT s.id) AS sesiones,
       COUNT(fe.id) AS eventos
FROM professionals p
LEFT JOIN organizations o ON o.id = p.org_id
LEFT JOIN sessions s ON s.professional_id = p.id
LEFT JOIN feature_events fe ON fe.session_id = s.id
GROUP BY p.id, p.full_name, p.profession, p.specialization, o.name
ORDER BY sesiones DESC;
