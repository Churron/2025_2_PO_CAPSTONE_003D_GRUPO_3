-- --- Script DDL Final y Corregido para MySQL Workbench (en Español) ---

-- Tabla de Roles de Usuario
CREATE TABLE `roles` (
  `id_rol` INT PRIMARY KEY AUTO_INCREMENT,
  `nombre_rol` VARCHAR(50) NOT NULL UNIQUE
);

-- Tabla de Estados de la Orden de Trabajo
CREATE TABLE `estados_ot` (
  `id_estado_ot` INT PRIMARY KEY AUTO_INCREMENT,
  `nombre_estado` VARCHAR(50) NOT NULL UNIQUE
);

-- Tabla de Usuarios del Sistema
CREATE TABLE `usuarios` (
  `id_usuario` INT PRIMARY KEY AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL UNIQUE,
  `contrasena_hash` VARCHAR(255) NOT NULL,
  `id_rol` INT NOT NULL,
  `fecha_creacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `fk_usuario_rol` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`)
);

-- Tabla del Catálogo de Vehículos
CREATE TABLE `vehiculos` (
  `id_vehiculo` INT PRIMARY KEY AUTO_INCREMENT,
  `patente` VARCHAR(10) NOT NULL UNIQUE,
  `modelo` VARCHAR(100),
  `anio` INT,
  `vin` VARCHAR(50),
  `chasis` VARCHAR(50),
  `sucursal_origen` VARCHAR(100),
  `id_supervisor` INT,
  CONSTRAINT `fk_vehiculo_supervisor` FOREIGN KEY (`id_supervisor`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL
);

-- Tabla Principal de Órdenes de Trabajo
CREATE TABLE `ordenes_trabajo` (
  `id_ot` INT PRIMARY KEY AUTO_INCREMENT,
  `fecha_creacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `fecha_agendada` DATETIME,
  `descripcion_problema` TEXT,
  `id_vehiculo` INT NOT NULL,
  `id_vendedor_solicitante` INT NOT NULL,
  `id_mecanico_asignado` INT,
  `id_coordinador_agenda` INT NOT NULL,
  `id_estado_ot` INT NOT NULL,
  CONSTRAINT `fk_ot_vehiculo` FOREIGN KEY (`id_vehiculo`) REFERENCES `vehiculos` (`id_vehiculo`),
  CONSTRAINT `fk_ot_vendedor` FOREIGN KEY (`id_vendedor_solicitante`) REFERENCES `usuarios` (`id_usuario`),
  CONSTRAINT `fk_ot_mecanico` FOREIGN KEY (`id_mecanico_asignado`) REFERENCES `usuarios` (`id_usuario`),
  CONSTRAINT `fk_ot_coordinador` FOREIGN KEY (`id_coordinador_agenda`) REFERENCES `usuarios` (`id_usuario`),
  CONSTRAINT `fk_ot_estado` FOREIGN KEY (`id_estado_ot`) REFERENCES `estados_ot` (`id_estado_ot`)
);

-- Tabla para el Registro de Acceso (Guardia)
CREATE TABLE `registros_acceso` (
  `id_registro_acceso` INT PRIMARY KEY AUTO_INCREMENT,
  `fecha_hora_ingreso` DATETIME NOT NULL,
  `fecha_hora_salida` DATETIME,
  `id_ot` INT NOT NULL,
  `id_guardia_ingreso` INT NOT NULL,
  `id_guardia_salida` INT,
  CONSTRAINT `fk_acceso_ot` FOREIGN KEY (`id_ot`) REFERENCES `ordenes_trabajo` (`id_ot`),
  CONSTRAINT `fk_acceso_guardia_in` FOREIGN KEY (`id_guardia_ingreso`) REFERENCES `usuarios` (`id_usuario`),
  CONSTRAINT `fk_acceso_guardia_out` FOREIGN KEY (`id_guardia_salida`) REFERENCES `usuarios` (`id_usuario`)
);

-- Tabla del Catálogo de Repuestos
CREATE TABLE `repuestos` (
  `id_repuesto` INT PRIMARY KEY AUTO_INCREMENT,
  `codigo` VARCHAR(50) NOT NULL UNIQUE,
  `nombre_repuesto` VARCHAR(255) NOT NULL,
  `marca` VARCHAR(100)
);

-- Tabla Intermedia para conectar OTs y Repuestos
CREATE TABLE `ot_repuestos` (
  `id_ot_repuesto` INT PRIMARY KEY AUTO_INCREMENT,
  `id_ot` INT NOT NULL,
  `id_repuesto` INT NOT NULL,
  `cantidad` INT NOT NULL DEFAULT 1,
  CONSTRAINT `fk_otr_ot` FOREIGN KEY (`id_ot`) REFERENCES `ordenes_trabajo` (`id_ot`),
  CONSTRAINT `fk_otr_repuesto` FOREIGN KEY (`id_repuesto`) REFERENCES `repuestos` (`id_repuesto`),
  UNIQUE (`id_ot`, `id_repuesto`)
);

-- Tabla para las Fotos de las OTs
CREATE TABLE `fotos_ot` (
  `id_foto` INT PRIMARY KEY AUTO_INCREMENT,
  `url_imagen` VARCHAR(255) NOT NULL,
  `fecha_subida` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `id_ot` INT NOT NULL,
  CONSTRAINT `fk_foto_ot` FOREIGN KEY (`id_ot`) REFERENCES `ordenes_trabajo` (`id_ot`)
);

-- Tabla para el Historial de Cambios de Estado de las OTs
CREATE TABLE `historial_estado_ot` (
  `id_historial` INT PRIMARY KEY AUTO_INCREMENT,
  `fecha_cambio` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `id_ot` INT NOT NULL,
  `id_estado_anterior` INT,
  `id_estado_nuevo` INT NOT NULL,
  `id_usuario_modifica` INT NOT NULL,
  CONSTRAINT `fk_historial_ot` FOREIGN KEY (`id_ot`) REFERENCES `ordenes_trabajo` (`id_ot`),
  CONSTRAINT `fk_historial_estado_ant` FOREIGN KEY (`id_estado_anterior`) REFERENCES `estados_ot` (`id_estado_ot`),
  CONSTRAINT `fk_historial_estado_nue` FOREIGN KEY (`id_estado_nuevo`) REFERENCES `estados_ot` (`id_estado_ot`),
  CONSTRAINT `fk_historial_usuario` FOREIGN KEY (`id_usuario_modifica`) REFERENCES `usuarios` (`id_usuario`)
);
