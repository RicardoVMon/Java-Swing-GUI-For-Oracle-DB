CREATE OR REPLACE PACKAGE Paquete_Clases AS

    -- Declaración de procedimientos
    PROCEDURE Actualizar_Clase(
        V_ID_CLASE IN NUMBER, 
        V_NOMBRE IN VARCHAR2, 
        V_DESCRIPCION IN VARCHAR2, 
        V_CAPACIDAD IN NUMBER, 
        V_HORARIO IN VARCHAR2, 
        V_NOMBRE_ENTRENADOR IN VARCHAR2);

    PROCEDURE Eliminar_Clase(
        ID_CLASE IN NUMBER);

    PROCEDURE Ingresar_Clases(
        V_NOMBRE IN VARCHAR2, 
        V_DESCRIPCION IN VARCHAR2, 
        V_CAPACIDAD IN NUMBER, 
        V_HORARIO IN VARCHAR2, 
        V_NOMBRE_ENTRENADOR IN VARCHAR2);

    PROCEDURE Obtener_Clase_Por_ID(
        ID_CLASE IN NUMBER, 
        DATOS OUT SYS_REFCURSOR);

    PROCEDURE Obtener_Clases(
        DATOS OUT SYS_REFCURSOR);

    PROCEDURE Obtener_Nombres_Entrenadores(
        DATOS OUT SYS_REFCURSOR);

END Paquete_Clases;

CREATE OR REPLACE PACKAGE BODY Paquete_Clases AS

    PROCEDURE Actualizar_Clase(
        V_ID_CLASE IN NUMBER, 
        V_NOMBRE IN VARCHAR2, 
        V_DESCRIPCION IN VARCHAR2, 
        V_CAPACIDAD IN NUMBER, 
        V_HORARIO IN VARCHAR2, 
        V_NOMBRE_ENTRENADOR IN VARCHAR2) 
    AS
        V_ID_ENTRENADOR NUMBER := Obtener_ID_Entrenador(V_NOMBRE_ENTRENADOR);
    BEGIN
        UPDATE CLASES SET 
            NOMBRE = V_NOMBRE,
            DESCRIPCION = V_DESCRIPCION,
            CAPACIDAD = V_CAPACIDAD,
            HORARIO = V_HORARIO,
            ID_ENTRENADOR = V_ID_ENTRENADOR
        WHERE ID_CLASE = V_ID_CLASE;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20005, 'No se encontro la clase con el ID proporcionado.');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20008, 'Error desconocido al actualizar la clase: ' || SQLERRM);
    END;

    PROCEDURE Eliminar_Clase(
        ID_CLASE IN NUMBER) 
    AS
        VSQL VARCHAR2(2000);
    BEGIN
        VSQL := 'UPDATE CLASES SET ESTADO = 0 WHERE ID_CLASE = :P1';
        EXECUTE IMMEDIATE VSQL USING ID_CLASE;
    END;

    PROCEDURE Ingresar_Clases(
        V_NOMBRE IN VARCHAR2, 
        V_DESCRIPCION IN VARCHAR2, 
        V_CAPACIDAD IN NUMBER, 
        V_HORARIO IN VARCHAR2, 
        V_NOMBRE_ENTRENADOR IN VARCHAR2) 
    AS
        V_ID_ENTRENADOR NUMBER := Obtener_ID_Entrenador(V_NOMBRE_ENTRENADOR);
    BEGIN
        INSERT INTO CLASES (NOMBRE, DESCRIPCION, CAPACIDAD, HORARIO, ID_ENTRENADOR, ESTADO)
        VALUES (V_NOMBRE, V_DESCRIPCION, V_CAPACIDAD, V_HORARIO, V_ID_ENTRENADOR, 1);

        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                RAISE_APPLICATION_ERROR(-20004, 'Violacion de clave unica al ingresar la clase. Verifique los datos proporcionados.');
            WHEN VALUE_ERROR THEN
                RAISE_APPLICATION_ERROR(-20005, 'Error de conversion al insertar la clase. Verifique los datos proporcionados.');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20006, 'Error desconocido al ingresar la clase: ' || SQLERRM);
    END;

    PROCEDURE Obtener_Clase_Por_ID(
        ID_CLASE IN NUMBER, 
        DATOS OUT SYS_REFCURSOR) 
    AS
        VSQL VARCHAR2(2000);
    BEGIN
        VSQL := 'SELECT 
            C.ID_CLASE,
            C.NOMBRE,
            C.DESCRIPCION,
            C.CAPACIDAD,
            C.HORARIO,
            E.NOMBRE || '' '' || E.APELLIDO_PATERNO || '' '' || E.APELLIDO_MATERNO AS NOMBRE_COMPLETO
        FROM CLASES C
        INNER JOIN ENTRENADORES E ON E.ID_ENTRENADOR = C.ID_ENTRENADOR
        WHERE C.ID_CLASE = :P1 
          AND C.ESTADO = 1 
          AND E.ESTADO = 1';

        OPEN DATOS FOR VSQL USING ID_CLASE;
    END;

    PROCEDURE Obtener_Clases(
        DATOS OUT SYS_REFCURSOR) 
    AS
        VSQL VARCHAR2(2000);
    BEGIN
        VSQL := 'SELECT 
            C.ID_CLASE,
            C.NOMBRE,
            C.DESCRIPCION,
            C.CAPACIDAD,
            C.HORARIO,
            E.NOMBRE || '' '' || E.APELLIDO_PATERNO || '' '' || E.APELLIDO_MATERNO AS NOMBRE_COMPLETO
        FROM CLASES C
        INNER JOIN ENTRENADORES E ON E.ID_ENTRENADOR = C.ID_ENTRENADOR
        WHERE C.ESTADO = 1 
          AND E.ESTADO = 1
        ORDER BY C.ID_CLASE ASC';

        OPEN DATOS FOR VSQL;
    END;

    PROCEDURE Obtener_Nombres_Entrenadores(
        DATOS OUT SYS_REFCURSOR) 
    AS
    BEGIN
        OPEN DATOS FOR
            SELECT 
                NOMBRE || ' ' || APELLIDO_PATERNO || ' ' || APELLIDO_MATERNO AS NOMBRE_COMPLETO
            FROM ENTRENADORES
            WHERE ESTADO = 1;
    END;

END Paquete_Clases;


