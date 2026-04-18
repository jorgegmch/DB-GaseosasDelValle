-- GASEOSAS DEL VALLE S.A.
-- Script: database.sql
-- Descripción: Creación de la base de datos gaseosas_del_valle, tablas, relaciones y datos de prueba.

-- DROP DATABASE IF EXISTS gaseosas_del_valle;

CREATE DATABASE IF NOT EXISTS gaseosas_del_valle;

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

-- SHOW TABLES;

-- Insertado de datos de prueba

INSERT INTO sedes (nombre_sede, ubicacion, capacidad_almacenamiento, encargado) VALUES
	('Sede Girón Centro',       'Calle 30 #25-10, Girón, Santander',                   5000,    'Andres Felipe Corzo'),
    ('Bodega Bucaramanga',      'Carrera 15 #36-20, Bucaramanga, Santander',           8000,    'Victor Alfonso Gazabon'),
    ('Punto Piedecuesta',       'Avenida Principal #12-45, Piedecuesta, Santander',    3000,    'Jorge Alberto Gomez');

INSERT INTO productos (nombre, categoria, precio, volumen_ml, stock_actual, stock_minimo) VALUES
	('Coca-Cola Original',          'Gaseosas',      2500.00,  350,  150, 20),
    ('Coca-Cola 1.5L',              'Gaseosas',      5500.00, 1500,   80, 15),
    ('Pepsi Original',              'Gaseosas',      2300.00,  350,  120, 20),
    ('Pepsi 1.5L',                  'Gaseosas',      5200.00, 1500,   60, 15),
    ('Sprite 350ml',                'Gaseosas',      2400.00,  350,  100, 20),
    ('Fanta Naranja 350ml',         'Gaseosas',      2400.00,  350,   90, 20),
    ('Colombiana 350ml',            'Gaseosas',      2200.00,  350,  200, 25),
    ('Manzana Postobón 350ml',      'Gaseosas',      2200.00,  350,  180, 25),
    
    ('Hit de Mango 350ml',          'Jugos',         2800.00,  350,   70, 15),
    ('Hit de Lulo 350ml',           'Jugos',         2800.00,  350,   65, 15),
    ('Tutti Frutti 250ml',          'Jugos',         1800.00,  250,   90, 20),
    ('Del Valle Naranja 1L',        'Jugos',         4500.00, 1000,   40, 10),
    
    ('Cristal Sin Gas 600ml',       'Aguas',         1500.00,  600,  300, 30),
    ('Cristal Con Gas 600ml',       'Aguas',         1700.00,  600,  120, 20),
    ('Brisa 1.5L',                  'Aguas',         2800.00, 1500,   50, 15),
    
    ('Vive 100 240ml',              'Energizantes',  2500.00,  240,   60, 15),
    ('Red Bull 250ml',              'Energizantes',  6500.00,  250,   35, 10),
    ('Monster Energy 473ml',        'Energizantes',  7500.00,  473,   25,  8),
    
    ('Speed Max 250ml',             'Energizantes',  3200.00,  250,    5, 10),
    ('Agua Oasis 300ml',            'Aguas',         1200.00,  300,    3, 10);

INSERT INTO clientes (nombre_completo, identificacion, direccion, telefono, correo_electronico) VALUES
	('Tienda La Esquina de Don Pedro',      '900456789-1',  'Calle 28 #15-30, Girón',                '3101234567',   'tiendadonpedro@email.com'),
    ('Restaurante El Buen Sabor',           '900567890-2',  'Carrera 20 #10-15, Girón',              '3209876543',   'buensabor@email.com'),
    ('Minimercado La Economía',             '900678901-3',  'Avenida Los Andes #5-22, Girón',        '3157891234',   'laeconomia@email.com'),
    ('Cafetería Central UIS',               '900789012-4',  'Ciudad Universitaria, Bucaramanga',     '3114567890',   'cafeteria.uis@email.com'),
    ('Supermercado MegaAhorro',             '900890123-5',  'Calle 45 #20-10, Bucaramanga',          '3176543210',   'megaahorro@email.com'),
    ('Panadería Villa del Pan',             '1098765432',   'Carrera 8 #12-56, Piedecuesta',         '3123456789',    NULL),
    ('Cigarrería La 15',                    '1087654321',   'Calle 15 #10-05, Girón',                '3145678901',    NULL),
    ('Restaurante Doña Cecilia',            '37894561',     'Carrera 22 #8-30, Girón',               '3198765432',   'donacecilia@email.com'),
    ('Distribuidora JM',                    '900345678-9',  'Zona Industrial, Bucaramanga',          '3167890123',   'distribuidorajm@email.com'),
    ('Heladería Frescos del Parque',        '1076543210',   'Parque Principal, Piedecuesta',         '3112345678',   'frescosdelparque@email.com');

INSERT INTO pedidos (fecha_pedido, id_cliente, id_sede) VALUES
	('2026-01-15 08:30:00',  1,  1),
    ('2026-01-20 10:00:00',  2,  1),
    ('2026-02-05 09:15:00',  3,  1),
    ('2026-02-14 14:00:00',  7,  1),
    ('2026-03-01 11:30:00',  8,  1),
    ('2026-03-10 08:00:00',  1,  1),

    ('2026-02-10 09:00:00',  4,  2),
    ('2026-02-20 16:00:00',  5,  2),
    ('2026-03-05 10:30:00',  9,  2),
    ('2026-03-15 13:00:00',  4,  2),

    ('2026-02-28 11:00:00',  6,  3),
    ('2026-03-12 15:30:00',  10, 3),
    ('2026-04-01 09:00:00',  6,  3);

INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad, subtotal) VALUES
	(1,  1,  24,  60000.00),
    (1,  7,  20,  44000.00),
    (1, 13,  30,  45000.00),

    (2,  1,  12,  30000.00),
    (2,  5,  10,  24000.00),
    (2,  9,  15,  42000.00),
    (2, 13,  20,  30000.00),

    (3,  2,  10,  55000.00),
    (3,  4,   8,  41600.00),
    (3,  8,  15,  33000.00),
    (3, 16,  10,  25000.00),

    (4,  1,  10,  25000.00),
    (4,  3,  10,  23000.00),
    (4, 16,   5,  12500.00),

    (5,  6,  12,  28800.00),
    (5,  9,   8,  22400.00),
    (5, 12,   6,  27000.00),

    (6,  1,  30,  75000.00),
    (6,  7,  25,  55000.00),
    (6, 15,  10,  28000.00),

    (7,  1,  20,  50000.00),
    (7, 11,  15,  27000.00),
    (7, 13,  25,  37500.00),
    (7, 17,   5,  32500.00),

    (8,  2,  20, 110000.00),
    (8,  4,  15,  78000.00),
    (8,  7,  30,  66000.00),
    (8, 13,  50,  75000.00),

    (9,  1,  50, 125000.00),
    (9,  3,  40,  92000.00),
    (9,  5,  30,  72000.00),
    (9, 13,  60,  90000.00),

    (10,  9,  10,  28000.00),
    (10, 10,  10,  28000.00),
    (10, 18,   3,  22500.00),

    (11,  1,   8,  20000.00),
    (11, 11,  10,  18000.00),
    (11, 13,  15,  22500.00),

    (12,  6,   6,  14400.00),
    (12, 13,  10,  15000.00),
    (12, 14,   8,  13600.00),

    (13,  7,  12,  26400.00),
    (13,  8,  10,  22000.00),
    (13, 11,   8,  14400.00);