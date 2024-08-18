-- CLIENTES

ALTER TABLE CLIENTES ADD ESTADO NUMBER(1) DEFAULT 1 NOT NULL;

create or replace PROCEDURE Obtener_Clientes (DATOS OUT SYS_REFCURSOR)
AS
    VSQL VARCHAR2(2000);
BEGIN
    VSQL := 'SELECT 
    C.ID_CLIENTE,
    C.NOMBRE,
    C.APELLIDO_PATERNO,
    C.APELLIDO_MATERNO,
    C.EDAD,
    C.EMAIL,
    C.TELEFONO,
    M.NOMBRE AS Nombre_Membresia
    FROM CLIENTES C
    INNER JOIN Membresias M ON M.ID_MEMBRESIA = C.ID_MEMBRESIA
    WHERE C.ESTADO = 1
    ORDER BY C.ID_CLIENTE ASC';

    OPEN DATOS FOR VSQL;
END;

-- SP PARA ELIMINAR CLIENTE

CREATE OR REPLACE PROCEDURE Eliminar_Cliente (ID_CLIENTE IN NUMBER)
AS
    VSQL VARCHAR2(2000);
BEGIN
    VSQL := 'UPDATE CLIENTES SET ESTADO = 0
             WHERE ID_CLIENTE = :P1';
    EXECUTE IMMEDIATE VSQL USING ID_CLIENTE;
END;

-- SP PARA OBTENER CLIENTE POR ID

CREATE OR REPLACE PROCEDURE Obtener_Cliente_Por_ID (ID_CLIENTE IN NUMBER, DATOS OUT SYS_REFCURSOR)
AS
    VSQL VARCHAR2(2000);
BEGIN
    VSQL := 'SELECT 
    C.ID_CLIENTE,
    C.NOMBRE,
    C.APELLIDO_PATERNO,
    C.APELLIDO_MATERNO,
    C.EDAD,
    C.EMAIL,
    C.TELEFONO,
    M.NOMBRE AS Nombre_Membresia
    FROM CLIENTES C
    INNER JOIN Membresias M ON M.ID_MEMBRESIA = C.ID_MEMBRESIA
    WHERE C.ID_CLIENTE = :P1';
    OPEN DATOS FOR VSQL USING ID_CLIENTE;
END;

-- Metodo para actualizar cliente por ID

CREATE OR REPLACE PROCEDURE Actualizar_Cliente (
    V_ID_CLIENTE IN NUMBER, 
    V_NOMBRE IN VARCHAR2, 
    V_APELLIDO_PATERNO IN VARCHAR2, 
    V_APELLIDO_MATERNO IN VARCHAR2, 
    V_EDAD IN NUMBER, 
    V_EMAIL IN VARCHAR2, 
    V_TELEFONO IN VARCHAR2, 
    V_ID_MEMBRESIA IN NUMBER)
AS
BEGIN
    UPDATE CLIENTES SET 
    NOMBRE = V_NOMBRE,
    APELLIDO_PATERNO = V_APELLIDO_PATERNO,
    APELLIDO_MATERNO = V_APELLIDO_MATERNO,
    EDAD = V_EDAD,
    EMAIL = V_EMAIL,
    TELEFONO = V_TELEFONO,
    ID_MEMBRESIA = V_ID_MEMBRESIA
    WHERE ID_CLIENTE = V_ID_CLIENTE;
END;

-- metodo para ingresar cliente

CREATE OR REPLACE PROCEDURE Ingresar_Cliente (
    V_NOMBRE IN VARCHAR2, 
    V_APELLIDO_PATERNO IN VARCHAR2, 
    V_APELLIDO_MATERNO IN VARCHAR2, 
    V_EDAD IN NUMBER, 
    V_EMAIL IN VARCHAR2, 
    V_TELEFONO IN VARCHAR2, 
    V_ID_MEMBRESIA IN NUMBER)
AS
BEGIN
    INSERT INTO CLIENTES (NOMBRE, APELLIDO_PATERNO, APELLIDO_MATERNO, EDAD, EMAIL, TELEFONO, ID_MEMBRESIA, ESTADO)
    VALUES (V_NOMBRE, V_APELLIDO_PATERNO, V_APELLIDO_MATERNO, V_EDAD, V_EMAIL, V_TELEFONO, V_ID_MEMBRESIA, 1);
END;

-- Pagos

-- pagos sólo de clientes activos
create or replace PROCEDURE Obtener_Pagos (DATOS OUT SYS_REFCURSOR)
AS
    VSQL VARCHAR2(2000);
BEGIN
    VSQL := 'SELECT 
    P.ID_PAGO,
    P.MONTO,
    P.FECHA_PAGO,
    P.METODO_PAGO,
    P.CONCEPTO,
    C.ID_CLIENTE,
    C.NOMBRE || '' '' || C.APELLIDO_PATERNO || '' '' || C.APELLIDO_MATERNO AS Nombre_Cliente
    FROM PAGOS P
    INNER JOIN CLIENTES C ON C.ID_CLIENTE = P.ID_CLIENTE
    WHERE C.ESTADO = 1
    ORDER BY P.ID_PAGO ASC';

    OPEN DATOS FOR VSQL;
END;

-- SP PARA OBTENER PAGOS POR ID

CREATE OR REPLACE PROCEDURE Obtener_Pago_Por_ID (ID_PAGO IN NUMBER, DATOS OUT SYS_REFCURSOR)
AS
    VSQL VARCHAR2(2000);
BEGIN
    VSQL := 'SELECT 
    P.ID_PAGO,
    P.MONTO,
    P.FECHA_PAGO,
    P.METODO_PAGO,
    P.CONCEPTO,
    C.ID_CLIENTE,
    C.NOMBRE || '' '' || C.APELLIDO_PATERNO || '' '' || C.APELLIDO_MATERNO AS Nombre_Cliente
    FROM PAGOS P
    INNER JOIN CLIENTES C ON C.ID_CLIENTE = P.ID_CLIENTE
    WHERE P.ID_PAGO = :P1';
    OPEN DATOS FOR VSQL USING ID_PAGO;
END;

-- SP PARA ELIMINAR PAGO

CREATE OR REPLACE PROCEDURE Eliminar_Pago (ID_PAGO IN NUMBER)
AS
    VSQL VARCHAR2(2000);
BEGIN
    VSQL := 'DELETE FROM PAGOS
             WHERE ID_PAGO = :P1';
    EXECUTE IMMEDIATE VSQL USING ID_PAGO;
END;

-- SP PARA OBTENER CLIENTES PARA PAGOS

create or replace PROCEDURE Obtener_Nombres_Clientes (DATOS OUT SYS_REFCURSOR)
AS
    VSQL VARCHAR2(2000);
BEGIN
    VSQL := 'SELECT 
    ID_CLIENTE,
    NOMBRE || '' '' || APELLIDO_PATERNO || '' '' || APELLIDO_MATERNO AS NOMBRE_COMPLETO
    FROM CLIENTES
    WHERE ESTADO = 1
    ORDER BY ID_CLIENTE ASC';

    OPEN DATOS FOR VSQL;
END;

-- sp para actualizar pago

CREATE OR REPLACE PROCEDURE Actualizar_Pago (
    V_ID_PAGO IN NUMBER, 
    V_MONTO IN NUMBER, 
    V_FECHA_PAGO IN DATE, 
    V_METODO_PAGO IN VARCHAR2, 
    V_CONCEPTO IN VARCHAR2, 
    V_ID_CLIENTE IN NUMBER)
AS
BEGIN
    UPDATE PAGOS SET 
    MONTO = V_MONTO,
    FECHA_PAGO = V_FECHA_PAGO,
    METODO_PAGO = V_METODO_PAGO,
    CONCEPTO = V_CONCEPTO,
    ID_CLIENTE = V_ID_CLIENTE
    WHERE ID_PAGO = V_ID_PAGO;
END;

-- sp para ingresar pago

CREATE OR REPLACE PROCEDURE Ingresar_Pago (
    V_MONTO IN NUMBER, 
    V_FECHA_PAGO IN DATE, 
    V_METODO_PAGO IN VARCHAR2, 
    V_CONCEPTO IN VARCHAR2, 
    V_NOMBRE_CLIENTE IN NUMBER)
AS
    V_ID_CLIENTE NUMBER;
BEGIN

    SELECT ID_CLIENTE 
    INTO V_ID_CLIENTE
    FROM CLIENTES
    WHERE NOMBRE ||' '|| APELLIDO_PATERNO ||' '|| APELLIDO_MATERNO = V_NOMBRE_CLIENTE;

    INSERT INTO PAGOS (MONTO, FECHA_PAGO, METODO_PAGO, CONCEPTO, ID_CLIENTE)
    VALUES (V_MONTO, V_FECHA_PAGO, V_METODO_PAGO, V_CONCEPTO, V_ID_CLIENTE);
END;
