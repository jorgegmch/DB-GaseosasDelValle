-- GASEOSAS DEL VALLE S.A.
-- Script: views_and_queries.sql
-- Descripción: Vistas y consultas complejas.

USE gaseosas_del_valle;

-- VISTAS

-- Vista 1: Resumen de pedidos y ventas por sede

CREATE VIEW vista_resumen_pedidos_por_sede AS
SELECT
    s.id_sede,
    s.nombre_sede,
    COUNT(p.id_pedido) AS total_pedidos,
    SUM(p.total_sin_iva) AS total_ventas_sin_iva,
    SUM(p.total_con_iva) AS total_ventas_con_iva
FROM sedes s
LEFT JOIN pedidos p ON s.id_sede = p.id_sede
GROUP BY s.id_sede, s.nombre_sede;

-- Vista 2: Productos con stock por debajo del mínimo

CREATE VIEW vista_productos_bajo_stock AS
SELECT
    id_producto,
    nombre,
    categoria,
    stock_actual,
    stock_minimo,
    (stock_minimo - stock_actual) AS unidades_faltantes
FROM productos
WHERE stock_actual <= stock_minimo;

-- Vista 3: Clientes con al menos un pedido registrado

CREATE VIEW vista_clientes_activos AS
SELECT DISTINCT
    c.id_cliente,
    c.nombre_completo,
    c.identificacion,
    c.telefono,
    c.correo_electronico,
    COUNT(p.id_pedido) AS total_pedidos
FROM clientes c
INNER JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre_completo, c.identificacion, c.telefono, c.correo_electronico;

-- CONSULTAS

-- Consulta 1: Productos con stock por debajo del mínimo

SELECT nombre, categoria, stock_actual, stock_minimo
FROM productos
WHERE stock_actual <= stock_minimo
ORDER BY stock_actual ASC;

-- Consulta 2: Pedidos realizados entre dos fechas

SELECT p.id_pedido, c.nombre_completo, s.nombre_sede, p.fecha_pedido, p.total_con_iva
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
JOIN sedes s    ON p.id_sede    = s.id_sede
WHERE p.fecha_pedido BETWEEN '2026-02-01' AND '2026-02-28'
ORDER BY p.fecha_pedido;

-- Consulta 3: Productos más vendidos

SELECT
    pr.nombre,
    pr.categoria,
    SUM(dp.cantidad) AS total_unidades_vendidas,
    SUM(dp.subtotal) AS total_ingresos
FROM detalle_pedido dp
JOIN productos pr ON dp.id_producto = pr.id_producto
GROUP BY pr.id_producto, pr.nombre, pr.categoria
ORDER BY total_unidades_vendidas DESC;
 
-- Consulta 4: Clientes y cantidad de pedidos realizados

SELECT
    c.nombre_completo,
    c.identificacion,
    c.telefono,
    COUNT(p.id_pedido) AS total_pedidos
FROM clientes c
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre_completo, c.identificacion, c.telefono
ORDER BY total_pedidos DESC;
 
-- Consulta 5: Buscar clientes por nombre parcial

SELECT
    id_cliente,
    nombre_completo,
    identificacion,
    telefono,
    correo_electronico
FROM clientes
WHERE nombre_completo LIKE '%Restaurante%'
ORDER BY nombre_completo;
 
-- Consulta 6: Productos de ciertas categorías

SELECT
    nombre,
    categoria,
    precio,
    stock_actual
FROM productos
WHERE categoria IN ('Energizantes', 'Jugos')
ORDER BY categoria, precio DESC;
 
-- Consulta 7: Cliente con mayor número de pedidos

SELECT
    c.nombre_completo,
    c.identificacion,
    c.telefono,
    COUNT(p.id_pedido) AS total_pedidos
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre_completo, c.identificacion, c.telefono
HAVING COUNT(p.id_pedido) = (
    SELECT MAX(conteo)
    FROM (
        SELECT COUNT(id_pedido) AS conteo
        FROM pedidos
        GROUP BY id_cliente
    ) AS subconsulta
);
 
-- Consulta 8: Pedidos y sus totales agrupados por sede

SELECT
    s.nombre_sede,
    COUNT(p.id_pedido) AS total_pedidos,
    SUM(p.total_sin_iva) AS total_sin_iva,
    SUM(p.total_con_iva) AS total_con_iva
FROM sedes s
LEFT JOIN pedidos p ON s.id_sede = p.id_sede
GROUP BY s.id_sede, s.nombre_sede
ORDER BY total_con_iva DESC;














