--m5_consultas_joins.sql
--Base de datos: Ventas_Tech_DB


-- CONSULTA 1 - VISTA BASE DEL PROYECTO
-- Combina ventas con clientes, productos y categorías.

SELECT
    v.id_venta,
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.ciudad,
    p.id_producto,
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos p
    ON v.id_producto = p.id_producto
INNER JOIN categorias cat
    ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta;


-- CONSULTA 2 - CLIENTES SIN VENTAS
-- Identifica clientes registrados que nunca realizaron una compra.

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;


-- CONSULTA 3 - PRODUCTOS SIN VENTAS
-- Identifica productos del catálogo que nunca fueron vendidos.

SELECT
    p.nombre_producto,
    c.nombre_categoria AS categoria,
    p.precio
FROM productos p
INNER JOIN categorias c
    ON p.id_categoria = c.id_categoria
LEFT JOIN ventas v
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;




-- CONSULTA 4 - CONSOLIDADO POR CANAL (UNION ALL)


SELECT
    canal,
    SUM(total) AS total_ventas
FROM (
   SELECT
        fecha_venta AS fecha,
        (cantidad * precio_unitario) AS total,
        'Online' AS canal
    FROM  ventas
    WHERE origen = 'Online'

    UNION ALL

    SELECT
        fecha_venta AS fecha,
        (cantidad * precio_unitario) AS total,
        'Presencial' AS canal
    FROM ventas
    WHERE origen = 'Presencial'
) AS ventas_consolidadas
GROUP BY canal
ORDER BY canal;
