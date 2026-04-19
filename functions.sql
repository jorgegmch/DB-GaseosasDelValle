-- GASEOSAS DEL VALLE S.A.
-- Script: functions.sql
-- Descripción: Creación de funciones personalizadas.

USE gaseosas_del_valle;

DELIMITER $$

CREATE FUNCTION fn_calcular_total_con_iva(p_id_pedido INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE v_total DECIMAL(12,2);

    SELECT SUM(subtotal) * 1.19
    INTO v_total
    FROM detalle_pedido
    WHERE id_pedido = p_id_pedido;

    RETURN v_total;
END $$

DELIMITER ;

DELIMITER $$

CREATE FUNCTION fn_validar_stock(p_id_producto INT, p_cantidad INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE v_stock_actual INT;

    SELECT stock_actual
    INTO v_stock_actual
    FROM productos
    WHERE id_producto = p_id_producto;

    IF v_stock_actual >= p_cantidad THEN
        RETURN CONCAT('Stock suficiente: hay ', v_stock_actual, ' unidades disponibles.');
    ELSE
        RETURN CONCAT('Stock insuficiente: solo hay ', v_stock_actual, ' unidades disponibles.');
    END IF;

END $$

DELIMITER ;