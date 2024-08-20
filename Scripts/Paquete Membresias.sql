CREATE OR REPLACE PACKAGE Paquete_Membresias AS
    -- Procedimientos
    PROCEDURE SP_Crear_Membresias (
        V_NOMBRE IN VARCHAR2, 
        V_PRECIO IN NUMBER, 
        V_DURACION IN NUMBER
    );
    PROCEDURE SP_Visualizar_Membresias (DATOS OUT SYS_REFCURSOR);
    PROCEDURE SP_Visualizar_Membresias_ID (ID_MEMBRESIA IN NUMBER, DATOS OUT SYS_REFCURSOR);
    PROCEDURE SP_Editar_Membresias (
        V_ID_MEMBRESIA IN NUMBER, 
        V_NOMBRE IN VARCHAR2, 
        V_PRECIO IN NUMBER, 
        V_DURACION IN NUMBER
    );
    PROCEDURE SP_Eliminar_Membresias (ID_MEMBRESIA IN NUMBER);
END Paquete_Membresias;

CREATE OR REPLACE PACKAGE BODY Paquete_Membresias AS

    -- Procedimiento para crear membresías
    PROCEDURE SP_Crear_Membresias (
        V_NOMBRE IN VARCHAR2, 
        V_PRECIO IN NUMBER, 
        V_DURACION IN NUMBER
    ) AS
        VCOD NUMBER;
        VMENS VARCHAR2(500);
    BEGIN
        INSERT INTO MEMBRESIAS (NOMBRE, PRECIO, DURACION, ESTADO)
        VALUES (V_NOMBRE, V_PRECIO, V_DURACION, 1);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN  
            VCOD := SQLCODE;
            VMENS := SQLERRM;
            DBMS_OUTPUT.PUT_LINE(' *Se ha producido un error al crear la membresía: ' || VCOD || ' ' || VMENS || '* ');
    END SP_Crear_Membresias;

    -- Procedimiento para visualizar membresías
    PROCEDURE SP_Visualizar_Membresias (DATOS OUT SYS_REFCURSOR) AS
        VSQL VARCHAR2(2000);
    BEGIN
        VSQL := 'SELECT 
            M.ID_MEMBRESIA,
            M.NOMBRE,
            M.PRECIO,
            M.DURACION
            FROM MEMBRESIAS M
            WHERE M.ESTADO = 1
            ORDER BY M.ID_MEMBRESIA ASC';

        OPEN DATOS FOR VSQL;
    END SP_Visualizar_Membresias;

    -- Procedimiento para visualizar membresías por ID
    PROCEDURE SP_Visualizar_Membresias_ID (ID_MEMBRESIA IN NUMBER, DATOS OUT SYS_REFCURSOR) AS
        VSQL VARCHAR2(2000);
        VCOD NUMBER;
        VMENS VARCHAR2(500);
    BEGIN
        VSQL := 'SELECT 
            M.ID_MEMBRESIA,
            M.NOMBRE,
            M.PRECIO,
            M.DURACION
            FROM MEMBRESIAS M
            WHERE M.ID_MEMBRESIA = :P1';
        OPEN DATOS FOR VSQL USING ID_MEMBRESIA;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE(' *No se encontró ninguna membresía con el ID proporcionado* ');
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE(' *Se encontraron múltiples membresías con el ID proporcionado* ');
        WHEN OTHERS THEN  
            VCOD := SQLCODE;
            VMENS := SQLERRM;
            DBMS_OUTPUT.PUT_LINE(' *Se ha producido un error al visualizar la membresía: ' || VCOD || ' ' || VMENS || '* ');
    END SP_Visualizar_Membresias_ID;

    -- Procedimiento para editar membresías
    PROCEDURE SP_Editar_Membresias (
        V_ID_MEMBRESIA IN NUMBER, 
        V_NOMBRE IN VARCHAR2, 
        V_PRECIO IN NUMBER, 
        V_DURACION IN NUMBER
    ) AS
        VCOD NUMBER;
        VMENS VARCHAR2(500);
    BEGIN
        UPDATE MEMBRESIAS SET 
        NOMBRE = V_NOMBRE,
        PRECIO = V_PRECIO,
        DURACION = V_DURACION
        WHERE ID_MEMBRESIA = V_ID_MEMBRESIA;
        COMMIT;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE(' *No se encontró ninguna membresía con el ID proporcionado* ');
        WHEN OTHERS THEN  
            VCOD := SQLCODE;
            VMENS := SQLERRM;
            DBMS_OUTPUT.PUT_LINE(' *Se ha producido un error al editar la membresía: ' || VCOD || ' ' || VMENS || '* ');
    END SP_Editar_Membresias;

    -- Procedimiento para eliminar/desactivar membresías
    PROCEDURE SP_Eliminar_Membresias (ID_MEMBRESIA IN NUMBER) AS
        VSQL VARCHAR2(2000);
        VCOD NUMBER;
        VMENS VARCHAR2(500);
    BEGIN
        VSQL := 'UPDATE MEMBRESIAS SET ESTADO = 0
                 WHERE ID_MEMBRESIA = :P1';
        EXECUTE IMMEDIATE VSQL USING ID_MEMBRESIA;

    EXCEPTION
        WHEN OTHERS THEN  
            VCOD := SQLCODE;
            VMENS := SQLERRM;
            DBMS_OUTPUT.PUT_LINE(' *Se ha producido un error al eliminar la membresía: ' || VCOD || ' ' || VMENS || '* ');
    END SP_Eliminar_Membresias;

END Paquete_Membresias;
