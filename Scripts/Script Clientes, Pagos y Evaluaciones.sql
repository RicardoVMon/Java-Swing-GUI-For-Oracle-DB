-- PROCEDIMIENTOS ALMACENADOS

-- SECCION DE CLIENTES

-- Actualizar clientes

create or replace PROCEDURE Actualizar_Cliente (
    V_ID_CLIENTE IN NUMBER, 
    V_NOMBRE IN VARCHAR2, 
    V_APELLIDO_PATERNO IN VARCHAR2, 
    V_APELLIDO_MATERNO IN VARCHAR2, 
    V_EDAD IN NUMBER, 
    V_EMAIL IN VARCHAR2, 
    V_TELEFONO IN VARCHAR2, 
    V_NOMBRE_MEMBRESIA IN VARCHAR2)
AS
    V_ID_MEMBRESIA NUMBER := Obtener_ID_Membresia(V_NOMBRE_MEMBRESIA);
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
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20005, 'No se encontró el cliente con el ID proporcionado.');
    WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20008, 'Error desconocido al actualizar el cliente: ' || SQLERRM);
END;

-- Eliminar clientes

create or replace PROCEDURE Eliminar_Cliente (ID_CLIENTE IN NUMBER)
AS
    VSQL VARCHAR2(2000);
BEGIN
    VSQL := 'UPDATE CLIENTES SET ESTADO = 0
             WHERE ID_CLIENTE = :P1';
    EXECUTE IMMEDIATE VSQL USING ID_CLIENTE;
END;

-- Ingresar clientes

create or replace PROCEDURE Ingresar_Cliente (
    V_NOMBRE IN VARCHAR2, 
    V_APELLIDO_PATERNO IN VARCHAR2, 
    V_APELLIDO_MATERNO IN VARCHAR2, 
    V_EDAD IN NUMBER, 
    V_EMAIL IN VARCHAR2, 
    V_TELEFONO IN VARCHAR2, 
    V_NOMBRE_MEMBRESIA IN VARCHAR2)
AS
    V_ID_MEMBRESIA NUMBER := Obtener_ID_Membresia(V_NOMBRE_MEMBRESIA);
BEGIN
    INSERT INTO CLIENTES (NOMBRE, APELLIDO_PATERNO, APELLIDO_MATERNO, EDAD, EMAIL, TELEFONO, ID_MEMBRESIA, ESTADO)
    VALUES (V_NOMBRE, V_APELLIDO_PATERNO, V_APELLIDO_MATERNO, V_EDAD, V_EMAIL, V_TELEFONO, V_ID_MEMBRESIA, 1);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20004, 'Violación de clave única al ingresar el cliente. Verifique los datos proporcionados.');
        WHEN VALUE_ERROR THEN
            RAISE_APPLICATION_ERROR(-20005, 'Error de conversión al insertar el cliente. Verifique los datos proporcionados.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20006, 'Error desconocido al ingresar el cliente: ' || SQLERRM);
END;

-- Obtener cliente por Id

create or replace PROCEDURE Obtener_Cliente_Por_ID (ID_CLIENTE IN NUMBER, DATOS OUT SYS_REFCURSOR)
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

-- Obtener clientes (todos los que esten activos)

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

-- Obtener clientes (combo boxes)

create or replace PROCEDURE Obtener_Clientes_Pagos (DATOS OUT SYS_REFCURSOR)
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

-- Obtener opciones de membresias para el combo box en clientes

create or replace PROCEDURE Obtener_Membresias (DATOS OUT SYS_REFCURSOR)
AS
    VSQL VARCHAR2(2000);
BEGIN
    VSQL := 'SELECT 
    ID_MEMBRESIA,
    NOMBRE,
    PRECIO,
    DURACION
    FROM MEMBRESIAS
    WHERE ESTADO = 1
    ORDER BY ID_MEMBRESIA ASC';
    OPEN DATOS FOR VSQL;
END;

-- obtener nombres de clientes

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



-- SECCION DE EVALUACIONES

create or replace PROCEDURE Actualizar_Evaluacion (
    V_ID_EVALUACION IN NUMBER, 
    V_PESO IN NUMBER, 
    V_GRASA_CORPORAL IN NUMBER, 
    V_MASA_MUSCULAR IN NUMBER, 
    V_FECHA_EVALUACION IN DATE, 
    V_NOMBRE_CLIENTE IN VARCHAR2)
AS
    V_ID_CLIENTE NUMBER := Obtener_ID_Cliente(V_NOMBRE_CLIENTE);
BEGIN
    UPDATE EVALUACIONES SET 
    PESO = V_PESO,
    GRASA_CORPORAL = V_GRASA_CORPORAL,
    MASA_MUSCULAR = V_MASA_MUSCULAR,
    FECHA_EVALUACION = V_FECHA_EVALUACION,
    ID_CLIENTE = V_ID_CLIENTE
    WHERE ID_EVALUACION = V_ID_EVALUACION;
    COMMIT;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20005, 'No se encontró el cliente con el ID proporcionado.');
    WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20008, 'Error desconocido al actualizar el cliente: ' || SQLERRM);
END;

-- Eliminar evaluaciones

create or replace PROCEDURE Eliminar_Evaluacion (ID_EVALUACION IN NUMBER)
AS
    VSQL VARCHAR2(2000);
BEGIN
    VSQL := 'DELETE FROM EVALUACIONES
             WHERE ID_EVALUACION = :P1';
    EXECUTE IMMEDIATE VSQL USING ID_EVALUACION;
END;

-- Ingresa evaluaciones

create or replace PROCEDURE Ingresar_Evaluacion (
    V_PESO IN NUMBER, 
    V_GRASA_CORPORAL IN NUMBER, 
    V_MASA_MUSCULAR IN NUMBER, 
    V_FECHA_EVALUACION IN DATE, 
    V_NOMBRE_CLIENTE IN VARCHAR2)
AS
    V_ID_CLIENTE NUMBER := Obtener_ID_Cliente(V_NOMBRE_CLIENTE);
BEGIN
        INSERT INTO EVALUACIONES (PESO, GRASA_CORPORAL, MASA_MUSCULAR, FECHA_EVALUACION, ID_CLIENTE)
        VALUES (V_PESO, V_GRASA_CORPORAL, V_MASA_MUSCULAR, V_FECHA_EVALUACION, V_ID_CLIENTE);
EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
    RAISE_APPLICATION_ERROR(-20004, 'Violación de clave única al ingresar la evaluación. Verifique los datos proporcionados: ' || SQLERRM);
WHEN VALUE_ERROR THEN
    RAISE_APPLICATION_ERROR(-20005, 'Error de conversión al insertar la evaluación. Verifique los datos proporcionados.');
WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20006, 'Error desconocido al ingresar la evaluación: ' || SQLERRM);
END;

-- Obtener evaluaciones por Id

create or replace PROCEDURE Obtener_Evaluacion_Por_ID (ID_EVALUACION IN NUMBER, DATOS OUT SYS_REFCURSOR)
AS
    VSQL VARCHAR2(2000);
BEGIN
    VSQL := 'SELECT 
    E.ID_EVALUACION,
    E.PESO,
    E.GRASA_CORPORAL,
    E.MASA_MUSCULAR,
    E.FECHA_EVALUACION,
    C.ID_CLIENTE,
    C.NOMBRE || '' '' || C.APELLIDO_PATERNO || '' '' || C.APELLIDO_MATERNO AS Nombre_Cliente
    FROM EVALUACIONES E
    INNER JOIN CLIENTES C ON C.ID_CLIENTE = E.ID_CLIENTE
    WHERE E.ID_EVALUACION = :P1';
    OPEN DATOS FOR VSQL USING ID_EVALUACION;
END;

-- obtener evaluaciones (todos los que esten activos)

create or replace PROCEDURE Obtener_Evaluaciones (DATOS OUT SYS_REFCURSOR)
AS
    VSQL VARCHAR2(2000);
BEGIN
    VSQL := 'SELECT 
    E.ID_EVALUACION,
    E.PESO,
    E.GRASA_CORPORAL,
    E.MASA_MUSCULAR,
    E.FECHA_EVALUACION,
    C.ID_CLIENTE,
    C.NOMBRE || '' '' || C.APELLIDO_PATERNO || '' '' || C.APELLIDO_MATERNO AS Nombre_Cliente
    FROM EVALUACIONES E
    INNER JOIN CLIENTES C ON C.ID_CLIENTE = E.ID_CLIENTE
    WHERE C.ESTADO = 1
    ORDER BY E.ID_EVALUACION ASC';

    OPEN DATOS FOR VSQL;
END;

-- SECCION DE PAGOS

create or replace PROCEDURE Actualizar_Pago (
    V_ID_PAGO IN NUMBER, 
    V_MONTO IN NUMBER, 
    V_FECHA_PAGO IN DATE, 
    V_METODO_PAGO IN VARCHAR2, 
    V_CONCEPTO IN VARCHAR2, 
    V_NOMBRE_CLIENTE IN VARCHAR2)
AS
    V_ID_CLIENTE NUMBER := Obtener_ID_Cliente(V_NOMBRE_CLIENTE);
BEGIN
    UPDATE PAGOS SET 
    MONTO = V_MONTO,
    FECHA_PAGO = TO_DATE(V_FECHA_PAGO, 'YYYY-MM-DD'),
    METODO_PAGO = V_METODO_PAGO,
    CONCEPTO = V_CONCEPTO,
    ID_CLIENTE = V_ID_CLIENTE
    WHERE ID_PAGO = V_ID_PAGO;
    COMMIT;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20005, 'No se encontró el cliente con el ID proporcionado.');
    WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20008, 'Error desconocido al actualizar el cliente: ' || SQLERRM);
END;

-- Eliminar pagos

create or replace PROCEDURE Eliminar_Pago (ID_PAGO IN NUMBER)
AS
    VSQL VARCHAR2(2000);
BEGIN
    VSQL := 'DELETE FROM PAGOS
             WHERE ID_PAGO = :P1';
    EXECUTE IMMEDIATE VSQL USING ID_PAGO;
END;

-- Ingresar pagos

create or replace PROCEDURE Ingresar_Pago (
    V_MONTO IN NUMBER, 
    V_FECHA_PAGO IN DATE, 
    V_METODO_PAGO IN VARCHAR2, 
    V_CONCEPTO IN VARCHAR2, 
    V_NOMBRE_CLIENTE IN VARCHAR2)
AS
    V_ID_CLIENTE NUMBER;
BEGIN

    SELECT ID_CLIENTE 
    INTO V_ID_CLIENTE
    FROM CLIENTES
    WHERE NOMBRE ||' '|| APELLIDO_PATERNO ||' '|| APELLIDO_MATERNO = V_NOMBRE_CLIENTE;

    INSERT INTO PAGOS (MONTO, FECHA_PAGO, METODO_PAGO, CONCEPTO, ID_CLIENTE)
    VALUES (V_MONTO, V_FECHA_PAGO, V_METODO_PAGO, V_CONCEPTO, V_ID_CLIENTE);
    COMMIT;
EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
    RAISE_APPLICATION_ERROR(-20004, 'Violación de clave única al ingresar la evaluación. Verifique los datos proporcionados: ' || SQLERRM);
WHEN VALUE_ERROR THEN
    RAISE_APPLICATION_ERROR(-20005, 'Error de conversión al insertar la evaluación. Verifique los datos proporcionados.');
WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20006, 'Error desconocido al ingresar la evaluación: ' || SQLERRM);
END;

-- obtener pago por id

create or replace PROCEDURE Obtener_Pago_Por_ID (ID_PAGO IN NUMBER, DATOS OUT SYS_REFCURSOR)
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

-- obtener pagos (todos los que esten activos)

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

-- FUNCIONES (NO ESTAN ASOCIADAS A NINGUN PAQUETE)

-- Seccion de clientes

-- obtener cantidad de clientes

create or replace FUNCTION CANTIDAD_CLIENTES
RETURN NUMBER
AS

    NUMCLIENTES NUMBER;

BEGIN

    SELECT COUNT(*) AS CANTIDAD
    INTO NUMCLIENTES
    FROM CLIENTES;

    RETURN numclientes;

END;

-- obtener id de cliente segun nombre

create or replace FUNCTION Obtener_ID_Cliente (
    V_NOMBRE_CLIENTE IN VARCHAR2
) RETURN NUMBER
AS
    V_ID_CLIENTE NUMBER;
BEGIN
    SELECT ID_CLIENTE 
    INTO V_ID_CLIENTE
    FROM CLIENTES
    WHERE NOMBRE ||' '|| APELLIDO_PATERNO ||' '|| APELLIDO_MATERNO = V_NOMBRE_CLIENTE;

    RETURN V_ID_CLIENTE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN TOO_MANY_ROWS THEN
        RETURN NULL;
END;

-- obtener id de membresia segun nombre

create or replace FUNCTION Obtener_ID_Membresia (
    V_NOMBRE_MEMBRESIA IN VARCHAR2
) RETURN NUMBER
AS
    V_ID_MEMBRESIA NUMBER;
BEGIN
    SELECT ID_MEMBRESIA
    INTO V_ID_MEMBRESIA
    FROM MEMBRESIAS
    WHERE NOMBRE = V_NOMBRE_MEMBRESIA;

    RETURN V_ID_MEMBRESIA;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN TOO_MANY_ROWS THEN
        RETURN NULL;
END;