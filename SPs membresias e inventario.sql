------------------------ INVENTARIO --------------------------
ALTER TABLE PRODUCTOS ADD ESTADO NUMBER(1) DEFAULT 1 NOT NULL;
ALTER TABLE PROVEEDORES ADD ESTADO NUMBER(1) DEFAULT 1 NOT NULL;

--sp para dropdown list de nombres de proveedores
CREATE OR REPLACE PROCEDURE SP_Obtener_Nombres_Proveedores (DATOS OUT SYS_REFCURSOR)
AS
BEGIN
    OPEN DATOS FOR
        SELECT NOMBRE
        FROM PROVEEDORES
        WHERE ESTADO = 1;
commit;
END;


--fn para obtener el id del proveedor para sps crear y editar
CREATE OR REPLACE FUNCTION FN_Obtener_ID_Proveedor (V_NOMBRE_PROVEEDOR IN VARCHAR2)
RETURN NUMBER
AS
    V_ID_PROVEEDOR NUMBER;
BEGIN
    SELECT ID_PROVEEDOR
    INTO V_ID_PROVEEDOR
    FROM PROVEEDORES
    WHERE NOMBRE = V_NOMBRE_PROVEEDOR;

    RETURN V_ID_PROVEEDOR;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN OTHERS THEN
        RETURN NULL;
END;


--crear
CREATE OR REPLACE PROCEDURE SP_Crear_Productos (
    V_NOMBRE IN VARCHAR2, 
    V_PRECIO IN NUMBER, 
    V_DESCRIPCION IN VARCHAR2, 
    V_EXISTENCIAS IN NUMBER, 
    V_NOMBRE_PROVEEDOR IN VARCHAR2)
AS
    V_ID_PROVEEDOR NUMBER;
    VCOD NUMBER;
    VMENS VARCHAR2(500);
BEGIN
    V_ID_PROVEEDOR := FN_Obtener_ID_Proveedor(V_NOMBRE_PROVEEDOR);
    
    IF V_ID_PROVEEDOR IS NOT NULL THEN
        INSERT INTO PRODUCTOS (NOMBRE, PRECIO, DESCRIPCION, EXISTENCIAS, ID_PROVEEDOR, ESTADO)
        VALUES (V_NOMBRE, V_PRECIO, V_DESCRIPCION, V_EXISTENCIAS, V_ID_PROVEEDOR, 1);
    END IF;
commit;    
EXCEPTION
    WHEN OTHERS THEN  
        VCOD := SQLCODE;
        VMENS := SQLERRM;
        DBMS_OUTPUT.PUT_LINE(' *Se ha producido un error:' || VCOD || ' ' ||  VMENS||'* ');
END;


--leer
CREATE OR REPLACE PROCEDURE SP_Visualizar_Productos (DATOS OUT SYS_REFCURSOR)
AS
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
END;

--leer id producto
CREATE OR REPLACE PROCEDURE SP_Visualizar_Productos_ID (ID_PRODUCTO IN NUMBER, DATOS OUT SYS_REFCURSOR)
AS
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
        DBMS_OUTPUT.PUT_LINE(' *No se encontr� ning�n producto con el ID proporcionado* ');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE(' *Se encontraron m�ltiples productos con el ID proporcionado* ');
    WHEN OTHERS THEN  
        VCOD := SQLCODE;
        VMENS := SQLERRM;
        DBMS_OUTPUT.PUT_LINE(' *Se ha producido un error:' || VCOD || ' ' ||  VMENS||'* ');
END;

--editar
CREATE OR REPLACE PROCEDURE SP_Editar_Productos (
    V_ID_PRODUCTO IN NUMBER, 
    V_NOMBRE IN VARCHAR2, 
    V_PRECIO IN NUMBER, 
    V_DESCRIPCION IN VARCHAR2, 
    V_EXISTENCIAS IN NUMBER, 
    V_NOMBRE_PROVEEDOR IN VARCHAR2)
AS
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
commit;    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE(' *No se encontr� ning�n producto con el ID proporcionado* ');
    WHEN OTHERS THEN  
        VCOD := SQLCODE;
        VMENS := SQLERRM;
        DBMS_OUTPUT.PUT_LINE(' *Se ha producido un error:' || VCOD || ' ' ||  VMENS||'* ');
END;

--trigger para verificar que los nombres de productos no se repitan
CREATE OR REPLACE TRIGGER TRG_PRODUCTO_NOMBRE
BEFORE INSERT OR UPDATE ON PRODUCTOS
FOR EACH ROW
DECLARE
    CANT NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO CANT
    FROM PRODUCTOS
    WHERE NOMBRE = :NEW.NOMBRE AND ID_PRODUCTO != :NEW.ID_PRODUCTO;

    IF CANT > 0 THEN
        DBMS_OUTPUT.PUT_LINE(' *Ya existe en el inventario un producto con el nombre dado* ');
        RAISE_APPLICATION_ERROR(-20001, 'Ya existe en el inventario un producto con el nombre dado');
    END IF;
END;



--eliminar/desactivar
CREATE OR REPLACE PROCEDURE SP_Eliminar_Productos (ID_PRODUCTO IN NUMBER)
AS
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
        DBMS_OUTPUT.PUT_LINE(' *Se ha producido un error:' || VCOD || ' ' ||  VMENS||'* ');
END;


------------------------ MEMBRESIAS --------------------------

ALTER TABLE MEMBRESIAS ADD ESTADO NUMBER(1) DEFAULT 1 NOT NULL;

--crear
CREATE OR REPLACE PROCEDURE SP_Crear_Membresias (
    V_NOMBRE IN VARCHAR2, 
    V_PRECIO IN NUMBER, 
    V_DURACION IN NUMBER)
AS
    VCOD NUMBER;
    VMENS VARCHAR2(500);
BEGIN
    INSERT INTO MEMBRESIAS (NOMBRE, PRECIO, DURACION, ESTADO)
    VALUES (V_NOMBRE, V_PRECIO, V_DURACION, 1);
commit;
EXCEPTION
    WHEN OTHERS THEN  
        VCOD := SQLCODE;
        VMENS := SQLERRM;
        DBMS_OUTPUT.PUT_LINE(' *Se ha producido un error al crear la membres�a: ' || VCOD || ' ' || VMENS || '* ');
END;

--leer
CREATE OR REPLACE PROCEDURE SP_Visualizar_Membresias (DATOS OUT SYS_REFCURSOR)
AS
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
END;



-- leer id membresia
CREATE OR REPLACE PROCEDURE SP_Visualizar_Membresias_ID (ID_MEMBRESIA IN NUMBER, DATOS OUT SYS_REFCURSOR)
AS
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
        DBMS_OUTPUT.PUT_LINE(' *No se encontr� ninguna membres�a con el ID proporcionado* ');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE(' *Se encontraron m�ltiples membres�as con el ID proporcionado* ');
    WHEN OTHERS THEN  
        VCOD := SQLCODE;
        VMENS := SQLERRM;
        DBMS_OUTPUT.PUT_LINE(' *Se ha producido un error al visualizar la membres�a: ' || VCOD || ' ' || VMENS || '* ');
END;

--editar
CREATE OR REPLACE PROCEDURE SP_Editar_Membresias (
    V_ID_MEMBRESIA IN NUMBER, 
    V_NOMBRE IN VARCHAR2, 
    V_PRECIO IN NUMBER, 
    V_DURACION IN NUMBER)
AS
    VCOD NUMBER;
    VMENS VARCHAR2(500);
BEGIN
    UPDATE MEMBRESIAS SET 
    NOMBRE = V_NOMBRE,
    PRECIO = V_PRECIO,
    DURACION = V_DURACION
    WHERE ID_MEMBRESIA = V_ID_MEMBRESIA;
commit;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE(' *No se encontr� ninguna membres�a con el ID proporcionado* ');
    WHEN OTHERS THEN  
        VCOD := SQLCODE;
        VMENS := SQLERRM;
        DBMS_OUTPUT.PUT_LINE(' *Se ha producido un error al editar la membres�a: ' || VCOD || ' ' || VMENS || '* ');
END;

--eliminar/desactivar
CREATE OR REPLACE PROCEDURE SP_Eliminar_Membresias (ID_MEMBRESIA IN NUMBER)
AS
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
        DBMS_OUTPUT.PUT_LINE(' *Se ha producido un error al eliminar la membres�a: ' || VCOD || ' ' || VMENS || '* ');
END;

--exec SP_Eliminar_Membresias(x);

--triggers

--tgr para que no repita nombre
CREATE OR REPLACE TRIGGER TRG_MEMBRESIA_NOMBRE
BEFORE INSERT OR UPDATE ON MEMBRESIAS
FOR EACH ROW
DECLARE
    CANT NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO CANT
    FROM MEMBRESIAS
    WHERE NOMBRE = :NEW.NOMBRE AND ID_MEMBRESIA != :NEW.ID_MEMBRESIA;

    IF CANT > 0 THEN
        DBMS_OUTPUT.PUT_LINE(' *Ya existe una membres�a con el nombre dado* ');
        RAISE_APPLICATION_ERROR(-20001, 'Ya existe una membres�a con el nombre dado');
    END IF;
END;



--tgr para cuando precio es menor a 0
CREATE OR REPLACE TRIGGER TRG_MEMBRESIA_PRECIO
BEFORE INSERT OR UPDATE ON MEMBRESIAS
FOR EACH ROW
BEGIN
    IF :NEW.PRECIO < 0 THEN
        DBMS_OUTPUT.PUT_LINE(' *El precio de la membres�a no puede ser negativo* ');
        RAISE_APPLICATION_ERROR(-20002, 'El precio de la membres�a no puede ser negativo');
    END IF;
END;