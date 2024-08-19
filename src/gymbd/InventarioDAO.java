package gymbd;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import javax.swing.JOptionPane;
import java.sql.SQLException;
import oracle.jdbc.OracleTypes;

/**
 *
 * @author arian
 */
public class InventarioDAO {
    private CallableStatement callableStatement = null;
    private ResultSet resultSet = null;
    private Connection connection;
    
    public InventarioDAO(Connection connection) {
        this.connection = connection;
    }

    //leer
    public ResultSet obtenerProductos(Connection conexion) {
        try {
            String sql = "{CALL SP_Visualizar_Productos(?)}";
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

    //leer producto por ID
    public ResultSet obtenerProductoPorID(Connection conexion, int idProducto) {
        try {
            String sql = "{CALL SP_Visualizar_Productos_ID(?, ?)}";
            callableStatement = conexion.prepareCall(sql);
            callableStatement.setInt(1, idProducto);
            callableStatement.registerOutParameter(2, OracleTypes.CURSOR);
            callableStatement.execute();
            resultSet = (ResultSet) callableStatement.getObject(2);
            return resultSet;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    //crear
    public boolean crearProducto(Connection conexion, String nombre, double precio, String descripcion, int existencias, String nombreProveedor) {
        try {
            String sql = "{call SP_Crear_Productos(?, ?, ?, ?, ?)}";
            callableStatement = conexion.prepareCall(sql);

            callableStatement.setString(1, nombre);
            callableStatement.setDouble(2, precio);
            callableStatement.setString(3, descripcion);
            callableStatement.setInt(4, existencias);
            callableStatement.setString(5, nombreProveedor);

            callableStatement.execute();
            System.out.println("Producto creado con éxito.");
            return true;

        } catch (SQLException e) {
        if (e.getErrorCode() == 20001) {
            JOptionPane.showMessageDialog(null, "Ya existe en el inventario un producto con el nombre dado", "Error", JOptionPane.ERROR_MESSAGE);
        } else {
            e.printStackTrace();
        }
        return false;
        }
    }

    //editar
    public boolean actualizarProducto(Connection conexion, int idProducto, String nombre, double precio, String descripcion, int existencias, String nombreProveedor) {
        try {
            String sql = "{CALL SP_Editar_Productos(?, ?, ?, ?, ?, ?)}";
            callableStatement = conexion.prepareCall(sql);

            callableStatement.setInt(1, idProducto);
            callableStatement.setString(2, nombre);
            callableStatement.setDouble(3, precio);
            callableStatement.setString(4, descripcion);
            callableStatement.setInt(5, existencias);
            callableStatement.setString(6, nombreProveedor);

            callableStatement.execute();
            return true;

        } catch (SQLException e) {
        if (e.getErrorCode() == 20001) {
            JOptionPane.showMessageDialog(null, "Ya existe en el inventario un producto con el nombre dado", "Error", JOptionPane.ERROR_MESSAGE);
        } else {
            e.printStackTrace();
        }
        return false;
        }
    }

    //eliminar/desactivar
    public boolean eliminarProducto(Connection conexion, int idProducto) {
        try {
            String sql = "{CALL SP_Eliminar_Productos(?)}";
            callableStatement = conexion.prepareCall(sql);
            callableStatement.setInt(1, idProducto);
            callableStatement.execute();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    //metodo para los nombres de proveedores para dropdown list
    public ResultSet obtenerNombresProveedores(Connection conexion) {
        try {
            String sql = "{CALL SP_Obtener_Nombres_Proveedores(?)}";
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
    
    public Integer obtenerIDProveedor(Connection conexion, String nombreProveedor) {
        CallableStatement callableStatement = null;
        try {
            String sql = "{ ? = call FN_Obtener_ID_Proveedor(?) }";
            callableStatement = conexion.prepareCall(sql);
            callableStatement.registerOutParameter(1, OracleTypes.NUMBER);
            callableStatement.setString(2, nombreProveedor);
            callableStatement.execute();

            Integer idProveedor = callableStatement.getInt(1);
            return idProveedor != null ? idProveedor : null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            if (callableStatement != null) {
                try {
                    callableStatement.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    
    public void close() {
        try {
            if (resultSet != null) resultSet.close();
            if (callableStatement != null) callableStatement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
