-- GASEOSAS DEL VALLE S.A.
-- Script: gdv_triggers.sql
-- Descripción: Triggers implementados.

USE gaseosas_del_valle;

-- Descuenta el stock y actualiza totales del pedido

DELIMITER $$

DROP TRIGGER IF EXISTS tr_actualizar_stock $$

CREATE TRIGGER tr_actualizar_stock
AFTER INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
    UPDATE productos
    SET stock_actual = stock_actual - NEW.cantidad
    WHERE id_producto = NEW.id_producto;

    UPDATE pedidos
    SET total_con_iva  = fn_calcular_total_con_iva(NEW.id_pedido),
        total_sin_iva  = fn_calcular_total_con_iva(NEW.id_pedido) / 1.19
    WHERE id_pedido = NEW.id_pedido;
END $$

DELIMITER ;

-- Registra en auditoria_precios cada cambio de precio

DELIMITER $$

DROP TRIGGER IF EXISTS tr_auditar_cambio_precio $$

CREATE TRIGGER tr_auditar_cambio_precio
AFTER UPDATE ON productos
FOR EACH ROW
BEGIN
    IF OLD.precio <> NEW.precio THEN
        INSERT INTO auditoria_precios (id_producto, precio_anterior, precio_nuevo)
        VALUES (OLD.id_producto, OLD.precio, NEW.precio);
    END IF;
END $$

DELIMITER ;

-- El trigger solo calcula totales para pedidos futuros; esto llena los del seed
UPDATE pedidos
SET total_con_iva = fn_calcular_total_con_iva(id_pedido),
    total_sin_iva = fn_calcular_total_con_iva(id_pedido) / 1.19;