package gymbd;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import oracle.jdbc.OracleTypes;

public class ProveedoresDAO {

    private CallableStatement callableStatement = null;
    private ResultSet resultSet = null;

    public ResultSet obtenerProveedores(Connection conexion) {
        try {
            String sql = "{CALL Paquete_Proveedores.Obtener_Proveedores(?)}";
            callableStatement = conexion.prepareCall(sql);
            callableStatement.registerOutParameter(1, OracleTypes.CURSOR);
            callableStatement.execute();
            resultSet = (ResultSet) callableStatement.getObject(1);
            return resultSet;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public ResultSet obtenerProveedorPorId(Connection conexion, int idProveedor) {
        try {
            String sql = "{CALL Paquete_Proveedores.Obtener_Proveedor_Por_ID(?, ?)}";
            callableStatement = conexion.prepareCall(sql);
            callableStatement.setInt(1, idProveedor);
            callableStatement.registerOutParameter(2, OracleTypes.CURSOR);
            callableStatement.execute();
            resultSet = (ResultSet) callableStatement.getObject(2);
            return resultSet;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public boolean ingresarProveedor(Connection conexion, String nombre, String telefono, String direccion) {

        try {
            String sql = "{CALL Paquete_Proveedores.Ingresar_Proveedor(?, ?, ?)}";
            callableStatement = conexion.prepareCall(sql);

            callableStatement.setString(1, nombre);
            callableStatement.setString(2, telefono);
            callableStatement.setString(3, direccion);
            callableStatement.execute();
            System.out.println("Proveedor ingresado con éxito.");
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean actualizarProveedor(Connection conexion, int idProveedor, String nombre, String telefono,
            String direccion) {

        try {
            String sql = "{CALL Paquete_Proveedores.Actualizar_Proveedor(?, ?, ?, ?)}";
            callableStatement = conexion.prepareCall(sql);

            callableStatement.setInt(1, idProveedor);
            callableStatement.setString(2, nombre);
            callableStatement.setString(3, telefono);
            callableStatement.setString(4, direccion);
            callableStatement.execute();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean eliminarProveedor(Connection conexion, int idProveedor) {
        try {
            String sql = "{CALL Paquete_Proveedores.Eliminar_Proveedor(?)}";
            callableStatement = conexion.prepareCall(sql);
            callableStatement.setInt(1, idProveedor);
            callableStatement.execute();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}
