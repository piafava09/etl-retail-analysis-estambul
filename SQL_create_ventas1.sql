-- Crear el nuevo schema
CREATE SCHEMA IF NOT EXISTS innovacion1;
USE innovacion1;

-- Eliminar la tabla 'ventas1' (si existe) para crearla
DROP TABLE IF EXISTS ventas1;

-- Crear la tabla 'ventas1' con los tipos de datos correctos
CREATE TABLE ventas1 (
    CUSTOMER_ID VARCHAR(255),
    GENDER VARCHAR(10),
    PAYMENT_METHOD VARCHAR(50), 
    CATEGORY VARCHAR(50),
    QUANTITY INT,
    INVOICE_DATE DATETIME, 
    SHOPPING_MALL VARCHAR(50), 
    INTERVALOS_AGE VARCHAR(20), 
    INTERVALOS_PRICE VARCHAR(20), 
    DISTRICT VARCHAR(255),
    SOCIOECONOMIC_PROFILE VARCHAR(50), 
    LATITUD DOUBLE, 
    LONGITUD DOUBLE, 
    AGE VARCHAR(50), 
    PRICE VARCHAR(50) 
);

-- Insertar los datos
INSERT INTO ventas1
SELECT
    `CUSTOMER ID`, 
    GENDER,
    `PAYMENT METHOD`, 
    CATEGORY,
    QUANTITY,
    STR_TO_DATE(`INVOICE DATE`, '%d-%m-%Y') AS INVOICE_DATE, 
    `SHOPPING MALL`, 
    AGE, 
    PRICE, 
    DISTRICT,
    `SOCIOECONOMIC PROFILE`, 
    CAST(LATITUD AS DOUBLE) AS LATITUD, 
    CAST(LONGITUD AS DOUBLE) AS LONGITUD, 
    AGE, 
    PRICE
FROM innovacion1.ventas1_temp; 

-- Verificación final: deben ser 99457 registros
SELECT COUNT(*) FROM ventas1;