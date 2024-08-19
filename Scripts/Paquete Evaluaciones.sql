create or replace PACKAGE Paquete_Evaluaciones AS
    PROCEDURE Actualizar_Evaluacion (
        V_ID_EVALUACION IN NUMBER, 
        V_PESO IN NUMBER, 
        V_GRASA_CORPORAL IN NUMBER, 
        V_MASA_MUSCULAR IN NUMBER, 
        V_FECHA_EVALUACION IN DATE, 
        V_NOMBRE_CLIENTE IN VARCHAR2
    );

    PROCEDURE Eliminar_Evaluacion (ID_EVALUACION IN NUMBER);

    PROCEDURE Ingresar_Evaluacion (
        V_PESO IN NUMBER, 
        V_GRASA_CORPORAL IN NUMBER, 
        V_MASA_MUSCULAR IN NUMBER, 
        V_FECHA_EVALUACION IN DATE, 
        V_NOMBRE_CLIENTE IN VARCHAR2
    );

    PROCEDURE Obtener_Evaluacion_Por_ID (
        ID_EVALUACION IN NUMBER, 
        DATOS OUT SYS_REFCURSOR
    );

    PROCEDURE Obtener_Evaluaciones (
        DATOS OUT SYS_REFCURSOR
    );
END Paquete_Evaluaciones;

create or replace PACKAGE BODY Paquete_Evaluaciones AS

    PROCEDURE Actualizar_Evaluacion (
        V_ID_EVALUACION IN NUMBER, 
        V_PESO IN NUMBER, 
        V_GRASA_CORPORAL IN NUMBER, 
        V_MASA_MUSCULAR IN NUMBER, 
        V_FECHA_EVALUACION IN DATE, 
        V_NOMBRE_CLIENTE IN VARCHAR2
    ) IS
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
            RAISE_APPLICATION_ERROR(-20008, 'Error desconocido al actualizar la evaluación: ' || SQLERRM);
    END Actualizar_Evaluacion;

    PROCEDURE Eliminar_Evaluacion (ID_EVALUACION IN NUMBER) IS
        VSQL VARCHAR2(2000);
    BEGIN
        VSQL := 'DELETE FROM EVALUACIONES WHERE ID_EVALUACION = :P1';
        EXECUTE IMMEDIATE VSQL USING ID_EVALUACION;
    END Eliminar_Evaluacion;

    PROCEDURE Ingresar_Evaluacion (
        V_PESO IN NUMBER, 
        V_GRASA_CORPORAL IN NUMBER, 
        V_MASA_MUSCULAR IN NUMBER, 
        V_FECHA_EVALUACION IN DATE, 
        V_NOMBRE_CLIENTE IN VARCHAR2
    ) IS
        V_ID_CLIENTE NUMBER := Obtener_ID_Cliente(V_NOMBRE_CLIENTE);
    BEGIN
        INSERT INTO EVALUACIONES (PESO, GRASA_CORPORAL, MASA_MUSCULAR, FECHA_EVALUACION, ID_CLIENTE)
        VALUES (V_PESO, V_GRASA_CORPORAL, V_MASA_MUSCULAR, V_FECHA_EVALUACION, V_ID_CLIENTE);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20004, 'Violación de clave única al ingresar la evaluación. Verifique los datos proporcionados.');
        WHEN VALUE_ERROR THEN
            RAISE_APPLICATION_ERROR(-20005, 'Error de conversión al insertar la evaluación. Verifique los datos proporcionados.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20006, 'Error desconocido al ingresar la evaluación: ' || SQLERRM);
    END Ingresar_Evaluacion;

    PROCEDURE Obtener_Evaluacion_Por_ID (
        ID_EVALUACION IN NUMBER, 
        DATOS OUT SYS_REFCURSOR
    ) IS
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
    END Obtener_Evaluacion_Por_ID;

    PROCEDURE Obtener_Evaluaciones (
        DATOS OUT SYS_REFCURSOR
    ) IS
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
    END Obtener_Evaluaciones;

END Paquete_Evaluaciones;