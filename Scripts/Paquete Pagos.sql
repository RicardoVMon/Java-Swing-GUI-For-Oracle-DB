create or replace PACKAGE Paquete_Pagos AS
    PROCEDURE Actualizar_Pago (
        V_ID_PAGO IN NUMBER, 
        V_MONTO IN NUMBER, 
        V_FECHA_PAGO IN DATE, 
        V_METODO_PAGO IN VARCHAR2, 
        V_CONCEPTO IN VARCHAR2, 
        V_NOMBRE_CLIENTE IN VARCHAR2
    );

    PROCEDURE Eliminar_Pago (ID_PAGO IN NUMBER);

    PROCEDURE Ingresar_Pago (
        V_MONTO IN NUMBER, 
        V_FECHA_PAGO IN DATE, 
        V_METODO_PAGO IN VARCHAR2, 
        V_CONCEPTO IN VARCHAR2, 
        V_NOMBRE_CLIENTE IN VARCHAR2
    );

    PROCEDURE Obtener_Pago_Por_ID (
        ID_PAGO IN NUMBER, 
        DATOS OUT SYS_REFCURSOR
    );

    PROCEDURE Obtener_Pagos (
        DATOS OUT SYS_REFCURSOR
    );
END Paquete_Pagos;

create or replace PACKAGE BODY Paquete_Pagos AS

    PROCEDURE Actualizar_Pago (
        V_ID_PAGO IN NUMBER, 
        V_MONTO IN NUMBER, 
        V_FECHA_PAGO IN DATE, 
        V_METODO_PAGO IN VARCHAR2, 
        V_CONCEPTO IN VARCHAR2, 
        V_NOMBRE_CLIENTE IN VARCHAR2
    ) IS
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
            RAISE_APPLICATION_ERROR(-20008, 'Error desconocido al actualizar el pago: ' || SQLERRM);
    END Actualizar_Pago;

    PROCEDURE Eliminar_Pago (ID_PAGO IN NUMBER) IS
        VSQL VARCHAR2(2000);
    BEGIN
        VSQL := 'DELETE FROM PAGOS WHERE ID_PAGO = :P1';
        EXECUTE IMMEDIATE VSQL USING ID_PAGO;
    END Eliminar_Pago;

    PROCEDURE Ingresar_Pago (
        V_MONTO IN NUMBER, 
        V_FECHA_PAGO IN DATE, 
        V_METODO_PAGO IN VARCHAR2, 
        V_CONCEPTO IN VARCHAR2, 
        V_NOMBRE_CLIENTE IN VARCHAR2
    ) IS
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
            RAISE_APPLICATION_ERROR(-20004, 'Violación de clave única al ingresar el pago. Verifique los datos proporcionados: ' || SQLERRM);
        WHEN VALUE_ERROR THEN
            RAISE_APPLICATION_ERROR(-20005, 'Error de conversión al insertar el pago. Verifique los datos proporcionados.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20006, 'Error desconocido al ingresar el pago: ' || SQLERRM);
    END Ingresar_Pago;

    PROCEDURE Obtener_Pago_Por_ID (
        ID_PAGO IN NUMBER, 
        DATOS OUT SYS_REFCURSOR
    ) IS
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
    END Obtener_Pago_Por_ID;

    PROCEDURE Obtener_Pagos (
        DATOS OUT SYS_REFCURSOR
    ) IS
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
    END Obtener_Pagos;

END Paquete_Pagos;
