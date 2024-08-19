create or replace PACKAGE Paquete_Clientes AS
    PROCEDURE Actualizar_Cliente (
        V_ID_CLIENTE IN NUMBER, 
        V_NOMBRE IN VARCHAR2, 
        V_APELLIDO_PATERNO IN VARCHAR2, 
        V_APELLIDO_MATERNO IN VARCHAR2, 
        V_EDAD IN NUMBER, 
        V_EMAIL IN VARCHAR2, 
        V_TELEFONO IN VARCHAR2, 
        V_NOMBRE_MEMBRESIA IN VARCHAR2
    );

    PROCEDURE Eliminar_Cliente (ID_CLIENTE IN NUMBER);

    PROCEDURE Ingresar_Cliente (
        V_NOMBRE IN VARCHAR2, 
        V_APELLIDO_PATERNO IN VARCHAR2, 
        V_APELLIDO_MATERNO IN VARCHAR2, 
        V_EDAD IN NUMBER, 
        V_EMAIL IN VARCHAR2, 
        V_TELEFONO IN VARCHAR2, 
        V_NOMBRE_MEMBRESIA IN VARCHAR2
    );

    PROCEDURE Obtener_Cliente_Por_ID (
        ID_CLIENTE IN NUMBER, 
        DATOS OUT SYS_REFCURSOR
    );

    PROCEDURE Obtener_Clientes (
        DATOS OUT SYS_REFCURSOR
    );

    PROCEDURE Obtener_Clientes_Pagos (
        DATOS OUT SYS_REFCURSOR
    );

    PROCEDURE Obtener_Membresias (
        DATOS OUT SYS_REFCURSOR
    );

    PROCEDURE Obtener_Nombres_Clientes (
        DATOS OUT SYS_REFCURSOR
    );
END Paquete_Clientes;

create or replace PACKAGE BODY Paquete_Clientes AS

    PROCEDURE Actualizar_Cliente (
        V_ID_CLIENTE IN NUMBER, 
        V_NOMBRE IN VARCHAR2, 
        V_APELLIDO_PATERNO IN VARCHAR2, 
        V_APELLIDO_MATERNO IN VARCHAR2, 
        V_EDAD IN NUMBER, 
        V_EMAIL IN VARCHAR2, 
        V_TELEFONO IN VARCHAR2, 
        V_NOMBRE_MEMBRESIA IN VARCHAR2
    ) IS
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
    END Actualizar_Cliente;

    PROCEDURE Eliminar_Cliente (ID_CLIENTE IN NUMBER) IS
        VSQL VARCHAR2(2000);
    BEGIN
        VSQL := 'UPDATE CLIENTES SET ESTADO = 0 WHERE ID_CLIENTE = :P1';
        EXECUTE IMMEDIATE VSQL USING ID_CLIENTE;
    END Eliminar_Cliente;

    PROCEDURE Ingresar_Cliente (
        V_NOMBRE IN VARCHAR2, 
        V_APELLIDO_PATERNO IN VARCHAR2, 
        V_APELLIDO_MATERNO IN VARCHAR2, 
        V_EDAD IN NUMBER, 
        V_EMAIL IN VARCHAR2, 
        V_TELEFONO IN VARCHAR2, 
        V_NOMBRE_MEMBRESIA IN VARCHAR2
    ) IS
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
    END Ingresar_Cliente;

    PROCEDURE Obtener_Cliente_Por_ID (
        ID_CLIENTE IN NUMBER, 
        DATOS OUT SYS_REFCURSOR
    ) IS
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
    END Obtener_Cliente_Por_ID;

    PROCEDURE Obtener_Clientes (
        DATOS OUT SYS_REFCURSOR
    ) IS
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
    END Obtener_Clientes;

    PROCEDURE Obtener_Clientes_Pagos (
        DATOS OUT SYS_REFCURSOR
    ) IS
        VSQL VARCHAR2(2000);
    BEGIN
        VSQL := 'SELECT 
        ID_CLIENTE,
        NOMBRE || '' '' || APELLIDO_PATERNO || '' '' || APELLIDO_MATERNO AS NOMBRE_COMPLETO
        FROM CLIENTES
        WHERE ESTADO = 1
        ORDER BY ID_CLIENTE ASC';
        OPEN DATOS FOR VSQL;
    END Obtener_Clientes_Pagos;

    PROCEDURE Obtener_Membresias (
        DATOS OUT SYS_REFCURSOR
    ) IS
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
    END Obtener_Membresias;

    PROCEDURE Obtener_Nombres_Clientes (
        DATOS OUT SYS_REFCURSOR
    ) IS
        VSQL VARCHAR2(2000);
    BEGIN
        VSQL := 'SELECT 
        ID_CLIENTE,
        NOMBRE || '' '' || APELLIDO_PATERNO || '' '' || APELLIDO_MATERNO AS NOMBRE_COMPLETO
        FROM CLIENTES
        WHERE ESTADO = 1
        ORDER BY ID_CLIENTE ASC';
        OPEN DATOS FOR VSQL;
    END Obtener_Nombres_Clientes;

END Paquete_Clientes;