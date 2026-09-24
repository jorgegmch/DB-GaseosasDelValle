-- GASEOSAS DEL VALLE S.A.
-- Script: gdv_schema.sql
-- Descripción: Creación de la base de datos y sus tablas.

CREATE DATABASE IF NOT EXISTS gaseosas_del_valle
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_spanish_ci;

USE gaseosas_del_valle;

CREATE TABLE IF NOT EXISTS productos (
    id_producto  INT PRIMARY KEY AUTO_INCREMENT,
    nombre       VARCHAR(100) NOT NULL,
    categoria    ENUM('Gaseosas', 'Jugos', 'Aguas', 'Energizantes') NOT NULL,
    precio       DECIMAL(10,2) NOT NULL,
    volumen_ml   INT NOT NULL,
    stock_actual INT NOT NULL DEFAULT 0,
    stock_minimo INT NOT NULL DEFAULT 10,

    CONSTRAINT chk_precio_positivo          CHECK (precio > 0),
    CONSTRAINT chk_stock_no_negativo        CHECK (stock_actual >= 0),
    CONSTRAINT chk_stock_minimo_no_negativo CHECK (stock_minimo >= 0)
);

CREATE TABLE IF NOT EXISTS clientes (
	id_cliente INT PRIMARY KEY AUTO_INCREMENT,
	nombre_completo VARCHAR(150) NOT NULL,
	identificacion VARCHAR(20) NOT NULL,
	direccion VARCHAR(200),
	telefono VARCHAR(20),
	correo_electronico VARCHAR(100),

	CONSTRAINT uq_identificacion UNIQUE (identificacion)
);

CREATE TABLE IF NOT EXISTS sedes (
	id_sede INT PRIMARY KEY AUTO_INCREMENT,
	nombre_sede VARCHAR(100) NOT NULL,
	ubicacion VARCHAR(200),
	capacidad_almacenamiento INT,
	encargado VARCHAR(150)
);

CREATE TABLE IF NOT EXISTS pedidos (
	id_pedido INT PRIMARY KEY AUTO_INCREMENT,
	fecha_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	id_cliente INT NOT NULL,
	id_sede INT NOT NULL,
	total_sin_iva DECIMAL(12,2),
	total_con_iva DECIMAL(12,2),

	CONSTRAINT fk_pedido_cliente
		FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
	CONSTRAINT fk_pedido_sede
		FOREIGN KEY (id_sede) REFERENCES sedes(id_sede)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS detalle_pedido (
	id_pedido INT NOT NULL,
	id_producto INT NOT NULL,
	cantidad INT NOT NULL,
	subtotal DECIMAL(10,2),

	PRIMARY KEY (id_pedido, id_producto),

	CONSTRAINT fk_detalle_pedido
		FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,

	CONSTRAINT fk_detalle_producto
		FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS auditoria_precios (
	id_auditoria INT PRIMARY KEY AUTO_INCREMENT,
	id_producto INT NOT NULL,
	precio_anterior DECIMAL(10,2),
	precio_nuevo DECIMAL(10,2),
	fecha_cambio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	usuario VARCHAR(100) NOT NULL DEFAULT (CURRENT_USER()),

	CONSTRAINT fk_auditoria_producto
		FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);