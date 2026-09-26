--- m4_consultas_negocio
-- Consulta 1
SELECT
    EXTRACT(MONTH FROM fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY EXTRACT(MONTH FROM fecha_venta)
ORDER BY mes;

-- Consulta 2  

SELECT
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC
LIMIT 5;


-- Consulta 3

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC;



-- Consulta 4  

SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado >= (
            SELECT AVG(facturacion_mensual)
            FROM (
                SELECT
                    SUM(cantidad * precio_unitario) AS facturacion_mensual
                FROM ventas
                GROUP BY EXTRACT(MONTH FROM fecha_venta)
            ) AS resumen_mensual
        )
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM (
    SELECT
        EXTRACT(MONTH FROM fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY EXTRACT(MONTH FROM fecha_venta)
) AS ventas_por_mes
ORDER BY mes;

-- HALLAZGOS DEL ANALISIS
-- 1ro
-- El mes 3   registró la mayor facturación, con un total 6444.00

-- 2do
-- El producto con ID 1 generó la mayor facturación,
-- con un total de 3600 y 3 unidades vendidas.


-- 3ro
-- Se identificaron 5 clientes recurrentes.
-- El cliente con ID 1 realizó 2 pedidos
-- y acumuló un gasto total de 2640,00.
