ALTER TABLE CLASES
ADD ESTADO NUMBER(1) DEFAULT 1;

ALTER TABLE ENTRENADORES
ADD ESTADO NUMBER(1) DEFAULT 1;


Scrip Clases 

-- SECCION DE CLASES
--actualizar clase
create or replace PROCEDURE Actualizar_Clase (
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

-- Eliminar clases

create or replace PROCEDURE Eliminar_Clase (ID_CLASE IN NUMBER)
AS
    VSQL VARCHAR2(2000);
BEGIN
    VSQL := 'UPDATE CLASES SET ESTADO = 0 WHERE ID_CLASE = :P1';
    EXECUTE IMMEDIATE VSQL USING ID_CLASE;
END;


-- Ingresa clases

create or replace PROCEDURE Ingresar_Clases (
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


-- Obtener clase por Id

create or replace PROCEDURE Obtener_Clase_Por_ID (ID_CLASE IN NUMBER, DATOS OUT SYS_REFCURSOR)
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



-- Obtener todas las Clases:

create or replace PROCEDURE Obtener_Clases (DATOS OUT SYS_REFCURSOR)
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

--Obtener nombres de los entrenadores
create or replace PROCEDURE Obtener_Nombres_Entrenadores (DATOS OUT SYS_REFCURSOR) 
AS
BEGIN
    OPEN DATOS FOR
        SELECT 
            NOMBRE || ' ' || APELLIDO_PATERNO || ' ' || APELLIDO_MATERNO AS NOMBRE_COMPLETO
        FROM ENTRENADORES
        WHERE ESTADO = 1;
END;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
PERSONAL
-- SECCIÓN DE ENTRENADORES

-- Actualizar Entrenador
create or replace PROCEDURE Actualizar_Entrenador (
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

-- Eliminar Entrenador

create or replace PROCEDURE Eliminar_Entrenador (ID_ENTRENADOR IN NUMBER)
AS
    VSQL VARCHAR2(2000);
BEGIN
    VSQL := 'UPDATE ENTRENADORES SET ESTADO = 0 WHERE ID_ENTRENADOR = :P1';
    EXECUTE IMMEDIATE VSQL USING ID_ENTRENADOR;
END;



-- Insertar Entrenador
create or replace PROCEDURE Ingresar_Entrenador (
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

-- Obtener Entrenador por ID
create or replace PROCEDURE Obtener_Entrenador_Por_ID (V_ID_ENTRENADOR IN NUMBER, DATOS OUT SYS_REFCURSOR)
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

-- Obtener todos los Entrenadores
create or replace PROCEDURE Obtener_Entrenadores (DATOS OUT SYS_REFCURSOR)
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

create or replace FUNCTION Obtener_ID_Entrenador (
    V_NOMBRE_ENTRENADOR IN VARCHAR2
) RETURN NUMBER
AS
    V_ID_ENTRENADOR NUMBER;
BEGIN
    SELECT ID_ENTRENADOR 
    INTO V_ID_ENTRENADOR
    FROM ENTRENADORES
    WHERE NOMBRE ||' '|| APELLIDO_PATERNO ||' '|| APELLIDO_MATERNO = V_NOMBRE_ENTRENADOR;

    RETURN V_ID_ENTRENADOR;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN TOO_MANY_ROWS THEN
        RETURN NULL;
END;