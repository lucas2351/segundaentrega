-- insertar datos
use sistema; 

INSERT INTO categoria (idcategoria, nombre, descripcion, condicion)
VALUES
(1, 'Categoria 1', 'Descripcion de Categoria 1', 1),
(2, 'Categoria 2', 'Descripcion de Categoria 2', 1),
(3, 'Categoria 3', 'Descripcion de Categoria 3', 1),
(4, 'Categoria 4', 'Descripcion de Categoria 4', 1),
(5, 'Categoria 5', 'Descripcion de Categoria 5', 1);


-- Articulos 

use sistema;

INSERT INTO articulo (idcategoria, codigo, nombre, precio_venta, stock, descripcion, condicion)
VALUES 
(1, 'A001', 'Articulo 1', 10.00, 100, 'Descripcion 1', 1),
(1, 'A002', 'Articulo 2', 20.00, 200, 'Descripcion 2', 1),
(1, 'A003', 'Articulo 3', 30.00, 300, 'Descripcion 3', 1),
(1, 'A004', 'Articulo 4', 40.00, 400, 'Descripcion 4', 1),
(1, 'A005', 'Articulo 5', 50.00, 500, 'Descripcion 5', 1);

-- rol 

use sistema;

INSERT INTO rol (nombre, descripcion, condicion)
VALUES 
('Administrador', 'Rol de administrador', 1),
('Vendedor', 'Rol de vendedor', 1),
('Almacenero', 'Rol de almacenero', 1),
('Usuario', 'Rol de usuario', 1),
('Invitado', 'Rol de invitado', 1);


-- usuario 
use sistema; 
INSERT INTO usuario (idrol, nombre, tipo_documento, num_documento, direccion, telefono, email, password_hash, condicion)
VALUES 
(1, 'Usuario 1', 'DNI', '12345678', 'Direccion 1', '123456789', 'user1@example.com', SHA2('password1', 256), 1),
(2, 'Usuario 2', 'DNI', '23456789', 'Direccion 2', '234567890', 'user2@example.com', SHA2('password2', 256), 1),
(3, 'Usuario 3', 'DNI', '34567890', 'Direccion 3', '345678901', 'user3@example.com', SHA2('password3', 256), 1);



-- Crear  vistas 
use sistema;

CREATE VIEW vista_venta AS
SELECT 
    v.idventa, 
    v.idcliente, 
    v.idusuario, 
    v.tipo_comprobante, 
    v.serie_comprobante, 
    v.num_comprobante, 
    v.fecha_hora, 
    v.impuesto, 
    v.total, 
    v.estado,
    a.nombre AS nombre_articulo, 
    a.precio_venta AS precio_articulo, 
    c.nombre AS nombre_categoria
FROM 
    venta v
JOIN 
    detalle_venta dv ON v.idventa = dv.idventa
JOIN 
    articulo a ON dv.idarticulo = a.idarticulo
JOIN 
    categoria c ON a.idcategoria = c.idcategoria
ORDER BY 
    v.fecha_hora;


show create view vista_venta;

use sistema; 
CREATE VIEW detalle_ingreso_articulo AS
SELECT 
    di.iddetalle_ingreso,
    di.idingreso,
    di.idarticulo,
    di.cantidad,
    di.precio,
    a.codigo,
    a.nombre AS nombre_articulo,
    a.precio_venta,
    a.stock,
    a.descripcion AS descripcion_articulo,
    a.condicion AS condicion_articulo
FROM 
    detalle_ingreso di
JOIN 
    articulo a ON di.idarticulo = a.idarticulo
ORDER BY 
    di.iddetalle_ingreso;
    
    use sistema;
    
    CREATE VIEW vista_detalle_venta_usuario AS
SELECT 
    dv.iddetalle_venta,
    dv.idventa,
    dv.idarticulo,
    dv.cantidad,
    dv.precio,
    dv.descuento,
    a.codigo AS codigo_articulo,
    a.nombre AS nombre_articulo,
    a.precio_venta AS precio_venta_articulo,
    a.stock,
    a.descripcion AS descripcion_articulo,
    u.idusuario,
    u.nombre AS nombre_usuario,
    u.tipo_documento AS tipo_documento_usuario,
    u.num_documento AS num_documento_usuario,
    u.direccion AS direccion_usuario,
    u.telefono AS telefono_usuario,
    u.email AS email_usuario,
    u.condicion AS condicion_usuario
FROM 
    detalle_venta dv
JOIN 
    articulo a ON dv.idarticulo = a.idarticulo
JOIN 
    venta v ON dv.idventa = v.idventa
JOIN 
    usuario u ON v.idusuario = u.idusuario
ORDER BY 
    dv.iddetalle_venta;
    
    
    
    use sistema;
    CREATE VIEW vista_articulos_categorias AS
SELECT 
    a.idarticulo,
    a.idcategoria,
    a.codigo,
    a.nombre AS nombre_articulo,
    a.precio_venta,
    a.stock,
    a.descripcion AS descripcion_articulo,
    a.condicion AS condicion_articulo,
    c.nombre AS nombre_categoria,
    c.descripcion AS descripcion_categoria,
    c.condicion AS condicion_categoria
FROM 
    articulo a
JOIN 
    categoria c ON a.idcategoria = c.idcategoria
ORDER BY 
    a.nombre;  -- Ordenar por el nombre del artículo
    
    
    use sistema;
    
    CREATE VIEW vista_articulos_detalle_venta AS
SELECT 
    dv.iddetalle_venta,
    dv.idventa,
    dv.idarticulo,
    dv.cantidad,
    dv.precio,
    dv.descuento,
    a.codigo AS codigo_articulo,
    a.nombre AS nombre_articulo,
    a.precio_venta AS precio_venta_articulo,
    a.stock,
    a.descripcion AS descripcion_articulo,
    a.condicion AS condicion_articulo,
    r.idrol,
    r.nombre AS nombre_rol,
    r.descripcion AS descripcion_rol,
    r.condicion AS condicion_rol
FROM 
    detalle_venta dv
JOIN 
    articulo a ON dv.idarticulo = a.idarticulo
JOIN 
    rol r ON a.idcategoria = r.idrol  -- Aquí asumo una posible relación; ajústala según sea necesario
ORDER BY 
    a.nombre;  -- Ordenar por el nombre del artículo
    
   -- Funciones  
   
   -- Calcular el stock de articulos 
   
  use sistema; 

DELIMITER //

CREATE FUNCTION calcular_stock()
RETURNS INT
BEGIN
    DECLARE total_stock INT;
    
    SELECT SUM(stock) INTO total_stock FROM articulo;
    
    RETURN total_stock;
END //

DELIMITER ;


SELECT calcular_stock() AS stock_total;


-- Calcular el IVA de un articulo 

DELIMITER //

CREATE FUNCTION calcular_iva(precio DECIMAL(11,2))
RETURNS DECIMAL(11,2)
BEGIN
    DECLARE iva DECIMAL(11,2);
    
    SET iva = precio * 0.21; -- Tasa de IVA del 21%
    
    RETURN iva;
END //

DELIMITER ;

-- Procesos almacenados 

use sistema;
DELIMITER //
CREATE PROCEDURE calcular_precio_total(
    IN p_idarticulo INT,  -- Parámetro de entrada: ID del artículo
    OUT p_precio_venta DECIMAL(11,2),  -- Parámetro de salida: Precio de venta del artículo
    OUT p_iva DECIMAL(11,2),  -- Parámetro de salida: IVA calculado
    OUT p_precio_total DECIMAL(11,2)  -- Parámetro de salida: Precio total (precio de venta + IVA)
)
BEGIN
    -- Declarar variables locales
    DECLARE precio DECIMAL(11,2);

    -- Obtener el precio de venta del artículo
    SELECT precio_venta INTO precio FROM articulo WHERE idarticulo = p_idarticulo;

    -- Calcular el IVA (suponiendo una tasa de IVA del 16%)
    SET p_iva = precio * 0.21;

    -- Asignar el precio de venta al parámetro de salida
    SET p_precio_venta = precio;

    -- Calcular el precio total
    SET p_precio_total = precio + p_iva;
END //



-- Registrar Ventas 
use sistema
DELIMITER //


CREATE PROCEDURE registrar_venta(
    IN p_idcliente INT,
    IN p_idusuario INT,
    IN p_tipo_comprobante VARCHAR(20),
    IN p_serie_comprobante VARCHAR(7),
    IN p_num_comprobante VARCHAR(10),
    IN p_fecha_hora DATETIME,
    IN p_impuesto DECIMAL(4,2),
    IN p_total DECIMAL(11,2),
    IN p_estado VARCHAR(20)
)
BEGIN
    -- Iniciar una transacción
    START TRANSACTION;
    
    -- Insertar en la tabla venta
    INSERT INTO venta (
        idcliente, idusuario, tipo_comprobante, serie_comprobante,
        num_comprobante, fecha_hora, impuesto, total, estado
    ) VALUES (
        p_idcliente, p_idusuario, p_tipo_comprobante, p_serie_comprobante,
        p_num_comprobante, p_fecha_hora, p_impuesto, p_total, p_estado
    );

    -- Confirmar la transacción
    COMMIT;
END //

-- Disparadores 
use sistema;

DELIMITER //

CREATE TRIGGER after_detalle_venta_insert
AFTER INSERT ON detalle_venta
FOR EACH ROW
BEGIN
    UPDATE articulo
    SET stock = stock - NEW.cantidad
    WHERE idarticulo = NEW.idarticulo;
END//

DELIMITER ;

use sistema;

DELIMITER //

CREATE TRIGGER before_detalle_ingreso_insert
BEFORE INSERT ON detalle_ingreso
FOR EACH ROW
BEGIN
    IF NEW.cantidad <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cantidad de artículos debe ser mayor a cero';
    END IF;
END//

DELIMITER ;


