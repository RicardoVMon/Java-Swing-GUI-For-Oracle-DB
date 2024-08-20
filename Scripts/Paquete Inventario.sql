CREATE OR REPLACE PACKAGE Paquete_Inventario AS
    -- Procedimientos
    PROCEDURE SP_Obtener_Nombres_Proveedores (DATOS OUT SYS_REFCURSOR);
    PROCEDURE SP_Crear_Productos (
        V_NOMBRE IN VARCHAR2, 
        V_PRECIO IN NUMBER, 
        V_DESCRIPCION IN VARCHAR2, 
        V_EXISTENCIAS IN NUMBER, 
        V_NOMBRE_PROVEEDOR IN VARCHAR2
    );
    PROCEDURE SP_Visualizar_Productos (DATOS OUT SYS_REFCURSOR);
    PROCEDURE SP_Visualizar_Productos_ID (ID_PRODUCTO IN NUMBER, DATOS OUT SYS_REFCURSOR);
    PROCEDURE SP_Editar_Productos (
        V_ID_PRODUCTO IN NUMBER, 
        V_NOMBRE IN VARCHAR2, 
        V_PRECIO IN NUMBER, 
        V_DESCRIPCION IN VARCHAR2, 
        V_EXISTENCIAS IN NUMBER, 
        V_NOMBRE_PROVEEDOR IN VARCHAR2
    );
    PROCEDURE SP_Eliminar_Productos (ID_PRODUCTO IN NUMBER);
END Paquete_Inventario;

CREATE OR REPLACE PACKAGE BODY Paquete_Inventario AS

    -- Procedimiento para obtener nombres de proveedores
    PROCEDURE SP_Obtener_Nombres_Proveedores (DATOS OUT SYS_REFCURSOR) AS
    BEGIN
        OPEN DATOS FOR
            SELECT NOMBRE
            FROM PROVEEDORES
            WHERE ESTADO = 1;
        COMMIT;
    END SP_Obtener_Nombres_Proveedores;

    -- Procedimiento para crear productos
    PROCEDURE SP_Crear_Productos (
        V_NOMBRE IN VARCHAR2, 
        V_PRECIO IN NUMBER, 
        V_DESCRIPCION IN VARCHAR2, 
        V_EXISTENCIAS IN NUMBER, 
        V_NOMBRE_PROVEEDOR IN VARCHAR2
    ) AS
        V_ID_PROVEEDOR NUMBER;
        VCOD NUMBER;
        VMENS VARCHAR2(500);
    BEGIN
        V_ID_PROVEEDOR := FN_Obtener_ID_Proveedor(V_NOMBRE_PROVEEDOR);
        
        IF V_ID_PROVEEDOR IS NOT NULL THEN
            INSERT INTO PRODUCTOS (NOMBRE, PRECIO, DESCRIPCION, EXISTENCIAS, ID_PROVEEDOR, ESTADO)
            VALUES (V_NOMBRE, V_PRECIO, V_DESCRIPCION, V_EXISTENCIAS, V_ID_PROVEEDOR, 1);
        END IF;
        COMMIT;    
    EXCEPTION
        WHEN OTHERS THEN  
            VCOD := SQLCODE;
            VMENS := SQLERRM;
            DBMS_OUTPUT.PUT_LINE(' *Se ha producido un error:' || VCOD || ' ' ||  VMENS || '* ');
    END SP_Crear_Productos;

    -- Procedimiento para visualizar productos
    PROCEDURE SP_Visualizar_Productos (DATOS OUT SYS_REFCURSOR) AS
        VSQL VARCHAR2(2000);
    BEGIN
        VSQL := 'SELECT 
            P.ID_PRODUCTO,
            P.NOMBRE,
            P.PRECIO,
            P.DESCRIPCION,
            P.EXISTENCIAS,
            PR.NOMBRE AS Nombre_Proveedor
            FROM PRODUCTOS P
            INNER JOIN PROVEEDORES PR ON PR.ID_PROVEEDOR = P.ID_PROVEEDOR
            WHERE P.ESTADO = 1
            ORDER BY P.ID_PRODUCTO ASC';

        OPEN DATOS FOR VSQL;
    END SP_Visualizar_Productos;

    -- Procedimiento para visualizar productos por ID
    PROCEDURE SP_Visualizar_Productos_ID (ID_PRODUCTO IN NUMBER, DATOS OUT SYS_REFCURSOR) AS
        VSQL VARCHAR2(2000);
        VCOD NUMBER;
        VMENS VARCHAR2(500);
    BEGIN
        VSQL := 'SELECT 
            P.ID_PRODUCTO,
            P.NOMBRE,
            P.PRECIO,
            P.DESCRIPCION,
            P.EXISTENCIAS,
            PR.NOMBRE AS Nombre_Proveedor
            FROM PRODUCTOS P
            INNER JOIN PROVEEDORES PR ON PR.ID_PROVEEDOR = P.ID_PROVEEDOR
            WHERE P.ID_PRODUCTO = :P1';
        OPEN DATOS FOR VSQL USING ID_PRODUCTO;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE(' *No se encontró ningún producto con el ID proporcionado* ');
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE(' *Se encontraron múltiples productos con el ID proporcionado* ');
        WHEN OTHERS THEN  
            VCOD := SQLCODE;
            VMENS := SQLERRM;
            DBMS_OUTPUT.PUT_LINE(' *Se ha producido un error:' || VCOD || ' ' ||  VMENS || '* ');
    END SP_Visualizar_Productos_ID;

    -- Procedimiento para editar productos
    PROCEDURE SP_Editar_Productos (
        V_ID_PRODUCTO IN NUMBER, 
        V_NOMBRE IN VARCHAR2, 
        V_PRECIO IN NUMBER, 
        V_DESCRIPCION IN VARCHAR2, 
        V_EXISTENCIAS IN NUMBER, 
        V_NOMBRE_PROVEEDOR IN VARCHAR2
    ) AS
        V_ID_PROVEEDOR NUMBER;
        VCOD NUMBER;
        VMENS VARCHAR2(500);
    BEGIN
        V_ID_PROVEEDOR := FN_Obtener_ID_Proveedor(V_NOMBRE_PROVEEDOR);

        IF V_ID_PROVEEDOR IS NOT NULL THEN
            UPDATE PRODUCTOS SET 
            NOMBRE = V_NOMBRE,
            PRECIO = V_PRECIO,
            DESCRIPCION = V_DESCRIPCION,
            EXISTENCIAS = V_EXISTENCIAS,
            ID_PROVEEDOR = V_ID_PROVEEDOR
            WHERE ID_PRODUCTO = V_ID_PRODUCTO;
        END IF;
        COMMIT;    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE(' *No se encontró ningún producto con el ID proporcionado* ');
        WHEN OTHERS THEN  
            VCOD := SQLCODE;
            VMENS := SQLERRM;
            DBMS_OUTPUT.PUT_LINE(' *Se ha producido un error:' || VCOD || ' ' ||  VMENS || '* ');
    END SP_Editar_Productos;

    -- Procedimiento para eliminar productos
    PROCEDURE SP_Eliminar_Productos (ID_PRODUCTO IN NUMBER) AS
        VSQL VARCHAR2(2000);
        VCOD NUMBER;
        VMENS VARCHAR2(500);
    BEGIN
        VSQL := 'UPDATE PRODUCTOS SET ESTADO = 0
                 WHERE ID_PRODUCTO = :P1';
        EXECUTE IMMEDIATE VSQL USING ID_PRODUCTO;

    EXCEPTION
        WHEN OTHERS THEN  
            VCOD := SQLCODE;
            VMENS := SQLERRM;
            DBMS_OUTPUT.PUT_LINE(' *Se ha producido un error:' || VCOD || ' ' ||  VMENS || '* ');
    END SP_Eliminar_Productos;

END Paquete_Inventario;
