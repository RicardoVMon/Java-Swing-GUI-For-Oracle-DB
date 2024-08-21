CREATE OR REPLACE PACKAGE Paquete_Entrenador AS

    -- Declaración de procedimientos
    PROCEDURE Actualizar_Entrenador(
        V_ID_ENTRENADOR IN NUMBER, 
        V_NOMBRE IN VARCHAR2, 
        V_APELLIDO_PATERNO IN VARCHAR2, 
        V_APELLIDO_MATERNO IN VARCHAR2, 
        V_ESPECIALIDAD IN VARCHAR2);

    PROCEDURE Eliminar_Entrenador(
        ID_ENTRENADOR IN NUMBER);

    PROCEDURE Ingresar_Entrenador(
        V_NOMBRE IN VARCHAR2, 
        V_APELLIDO_PATERNO IN VARCHAR2, 
        V_APELLIDO_MATERNO IN VARCHAR2, 
        V_ESPECIALIDAD IN VARCHAR2);

    PROCEDURE Obtener_Entrenador_Por_ID(
        V_ID_ENTRENADOR IN NUMBER, 
        DATOS OUT SYS_REFCURSOR);

    PROCEDURE Obtener_Entrenadores(
        DATOS OUT SYS_REFCURSOR);

END Paquete_Entrenador;

CREATE OR REPLACE PACKAGE BODY Paquete_Entrenador AS

    PROCEDURE Actualizar_Entrenador(
        V_ID_ENTRENADOR IN NUMBER, 
        V_NOMBRE IN VARCHAR2, 
        V_APELLIDO_PATERNO IN VARCHAR2, 
        V_APELLIDO_MATERNO IN VARCHAR2, 
        V_ESPECIALIDAD IN VARCHAR2) 
    AS
    BEGIN
        UPDATE ENTRENADORES SET 
            NOMBRE = V_NOMBRE,
            APELLIDO_PATERNO = V_APELLIDO_PATERNO,
            APELLIDO_MATERNO = V_APELLIDO_MATERNO,
            ESPECIALIDAD = V_ESPECIALIDAD
        WHERE ID_ENTRENADOR = V_ID_ENTRENADOR;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20005, 'No se encontro el entrenador con el ID proporcionado.');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20008, 'Error desconocido al actualizar el entrenador: ' || SQLERRM);
    END;

    PROCEDURE Eliminar_Entrenador(
        ID_ENTRENADOR IN NUMBER) 
    AS
        VSQL VARCHAR2(2000);
    BEGIN
        VSQL := 'UPDATE ENTRENADORES SET ESTADO = 0 WHERE ID_ENTRENADOR = :P1';
        EXECUTE IMMEDIATE VSQL USING ID_ENTRENADOR;
    END;

    PROCEDURE Ingresar_Entrenador(
        V_NOMBRE IN VARCHAR2, 
        V_APELLIDO_PATERNO IN VARCHAR2, 
        V_APELLIDO_MATERNO IN VARCHAR2, 
        V_ESPECIALIDAD IN VARCHAR2) 
    AS
    BEGIN
        INSERT INTO ENTRENADORES (NOMBRE, APELLIDO_PATERNO, APELLIDO_MATERNO, ESPECIALIDAD)
        VALUES (V_NOMBRE, V_APELLIDO_PATERNO, V_APELLIDO_MATERNO, V_ESPECIALIDAD);

        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                RAISE_APPLICATION_ERROR(-20011, 'Violacion de clave unica al ingresar el entrenador. Verifique los datos proporcionados.');
            WHEN VALUE_ERROR THEN
                RAISE_APPLICATION_ERROR(-20012, 'Error de conversion al insertar el entrenador. Verifique los datos proporcionados.');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20013, 'Error desconocido al ingresar el entrenador: ' || SQLERRM);
    END;

    PROCEDURE Obtener_Entrenador_Por_ID(
        V_ID_ENTRENADOR IN NUMBER, 
        DATOS OUT SYS_REFCURSOR) 
    AS
    BEGIN
        OPEN DATOS FOR
            SELECT 
                ID_ENTRENADOR,
                NOMBRE,
                APELLIDO_PATERNO,
                APELLIDO_MATERNO,
                ESPECIALIDAD
            FROM ENTRENADORES
            WHERE ID_ENTRENADOR = V_ID_ENTRENADOR;
    END;

    PROCEDURE Obtener_Entrenadores(
        DATOS OUT SYS_REFCURSOR) 
    AS
    BEGIN
        OPEN DATOS FOR
            SELECT 
                ID_ENTRENADOR,
                NOMBRE,
                APELLIDO_PATERNO,
                APELLIDO_MATERNO,
                ESPECIALIDAD
            FROM ENTRENADORES
            WHERE ESTADO = 1
            ORDER BY ID_ENTRENADOR ASC;
    END;

END Paquete_Entrenador;


