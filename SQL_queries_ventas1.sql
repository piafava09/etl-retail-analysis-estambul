# Determinar el modo de pago más frecuente de todos los clientes y a su vez categorizados por género

-- Modo de Pago más frecuente (General)
SELECT PAYMENT_METHOD,
COUNT(CUSTOMER_ID) AS Total_Transacciones
FROM innovacion1.ventas1
GROUP BY PAYMENT_METHOD
ORDER BY Total_Transacciones DESC;

--  Métodos de pago más utilizados por las mujeres.
SELECT PAYMENT_METHOD,
COUNT(CUSTOMER_ID) AS Total_Mujeres
FROM innovacion1.ventas1
WHERE GENDER = 'Female'
GROUP BY PAYMENT_METHOD
ORDER BY Total_Mujeres DESC;

-- Métodos de pago más utilizados por los hombres.
SELECT
    PAYMENT_METHOD,
    COUNT(CUSTOMER_ID) AS Total_Hombres
FROM innovacion1.ventas1
WHERE GENDER = 'Male'
GROUP BY PAYMENT_METHOD
ORDER BY Total_Hombres DESC;


# Métodos de pago por rango etario.

-- Métodos de Pago para el intervalo '28 - 37 Años'
SELECT PAYMENT_METHOD,
COUNT(CUSTOMER_ID) AS Total_Ventas
FROM innovacion1.ventas1
WHERE INTERVALOS_AGE = '28 - 37 Años' 
GROUP BY PAYMENT_METHOD
ORDER BY Total_Ventas DESC;

# Comportamiento de compra

-- Frecuencia de compra de intervalos de precio por categoría de producto
SELECT
    CATEGORY,
    INTERVALOS_PRICE,
    COUNT(*) AS Frecuencia_de_Compra
FROM innovacion1.ventas1
GROUP BY CATEGORY, INTERVALOS_PRICE
ORDER BY CATEGORY, Frecuencia_de_Compra DESC;

-- Distribución de transacciones por patrón de consumo (rango de precio)
SELECT
    INTERVALOS_PRICE,
    COUNT(*) AS Frecuencia,
    (COUNT(*) * 100.0 / 99457) AS Porcentaje 
FROM innovacion1.ventas1
GROUP BY INTERVALOS_PRICE;

# Distribución Porcentual de Ventas por Centro Comercial
SELECT
    SHOPPING_MALL,
    COUNT(*) AS Total_Ventas,
    (COUNT(*) * 100.0 / 99457) AS Porcentaje_del_Total
FROM innovacion1.ventas1
GROUP BY SHOPPING_MALL
ORDER BY Porcentaje_del_Total DESC;

SHOW VARIABLES LIKE 'secure_file_priv';
 
# EXPORTACIÓN:
-- Exporta la tabla 'ventas1' a un archivo CSV
SELECT
    CUSTOMER_ID,
    GENDER,
    PAYMENT_METHOD,
    CATEGORY,
    QUANTITY,
    DATE_FORMAT(INVOICE_DATE, '%Y-%m-%d') AS INVOICE_DATE,
    SHOPPING_MALL,
    INTERVALOS_AGE,
    INTERVALOS_PRICE,
    DISTRICT,
    SOCIOECONOMIC_PROFILE,
    LATITUD,
    LONGITUD,
    AGE,
    PRICE
INTO OUTFILE 'C://ProgramData//MySQL//MySQL Server 9.4//Uploads//ventas_export.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
FROM innovacion1.ventas1;

# TRIGGER 
-- 

DELIMITER $$

CREATE TRIGGER TRG_validar_cantidad_positiva
BEFORE INSERT ON ventas1 -- Aplica a tu tabla de ventas
FOR EACH ROW
BEGIN
    -- Verifica si la cantidad a insertar es menor o igual a cero
    IF NEW.QUANTITY <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: La cantidad (QUANTITY) debe ser un valor positivo para registrar una venta.';
    END IF;
END$$

DELIMITER ;

#STORED PROCEDURE
-- Eliminar el procedimiento si ya existe
DROP PROCEDURE IF EXISTS Generar_Informe_Tendencias_Pago;

DELIMITER $$

CREATE PROCEDURE Generar_Informe_Tendencias_Pago()
BEGIN
SELECT '--- REPORTE DE TENDENCIAS DE PAGO POR GÉNERO ---' AS Reporte_Seccion;

-- Modo de Pago más Frecuente (General)
SELECT
        'MODO DE PAGO MÁS FRECUENTE (GENERAL)' AS Hallazgo,
        PAYMENT_METHOD,
        COUNT(CUSTOMER_ID) AS Total_Transacciones
    FROM ventas1
    GROUP BY PAYMENT_METHOD
    ORDER BY Total_Transacciones DESC
    LIMIT 1;

-- Modo de Pago más Frecuente (MUJERES)
SELECT
        'MODO DE PAGO MÁS FRECUENTE (MUJERES)' AS Hallazgo,
        PAYMENT_METHOD,
        COUNT(CUSTOMER_ID) AS Total_Mujeres
    FROM ventas1
    WHERE GENDER = 'Female'
    GROUP BY PAYMENT_METHOD
    ORDER BY Total_Mujeres DESC
    LIMIT 1;

-- Modo de Pago más Frecuente (HOMBRES)
    SELECT
        'MODO DE PAGO MÁS FRECUENTE (HOMBRES)' AS Hallazgo,
        PAYMENT_METHOD,
        COUNT(CUSTOMER_ID) AS Total_Hombres
    FROM ventas1
    WHERE GENDER = 'Male'
    GROUP BY PAYMENT_METHOD
    ORDER BY Total_Hombres DESC
    LIMIT 1;
END$$

DELIMITER ;

CALL Generar_Informe_Tendencias_Pago();