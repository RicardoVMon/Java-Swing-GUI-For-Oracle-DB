package gymbd;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import oracle.jdbc.OracleTypes;

public class PedidosDAO {

    private CallableStatement callableStatement = null;
    private ResultSet resultSet = null;

    public ResultSet obtenerPedidos(Connection conexion) {
        try {
            String sql = "{CALL Paquete_Pedidos.Obtener_Pedidos(?)}";
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

    public ResultSet obtenerPedidoPorId(Connection conexion, int idPedido) {
        try {
            String sql = "{CALL Paquete_Pedidos.Obtener_Pedido_Por_ID(?, ?)}";
            callableStatement = conexion.prepareCall(sql);
            callableStatement.setInt(1, idPedido);
            callableStatement.registerOutParameter(2, OracleTypes.CURSOR);
            callableStatement.execute();
            resultSet = (ResultSet) callableStatement.getObject(2);
            return resultSet;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public ResultSet obtenerProductos(Connection conexion) {
        try {
            String sql = "{CALL Paquete_Pedidos.Obtener_Nombre_Productos(?)}";
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

    public ResultSet obtenerClientes(Connection conexion) {
        try {
            String sql = "{CALL Paquete_Pedidos.Obtener_Nombre_Clientes(?)}";
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

    public boolean ingresarPedido(Connection conexion, String fecha, String estado,
            String cliente, int cantidad, String producto) {

        try {
            String sql = "{CALL Paquete_Pedidos.Ingresar_Pedido(?, ?, ?, ?, ?)}";
            callableStatement = conexion.prepareCall(sql);

            callableStatement.setString(1, fecha);
            callableStatement.setString(2, estado);
            callableStatement.setString(3, cliente);
            callableStatement.setInt(4, cantidad);
            callableStatement.setString(5, producto);
            callableStatement.execute();
            System.out.println("Pedido ingresado con éxito.");
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean actualizarPedido(Connection conexion, int idPedido, String fecha, String producto,
            String estado, int cantidad) {

        try {
            String sql = "{CALL Paquete_Pedidos.Actualizar_Pedido(?, ?, ?, ?, ?)}";
            callableStatement = conexion.prepareCall(sql);

            callableStatement.setInt(1, idPedido);
            callableStatement.setString(2, fecha);
            callableStatement.setString(3, producto);
            callableStatement.setString(4, estado);
            callableStatement.setInt(5, cantidad);
            callableStatement.execute();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarPedido(Connection conexion, int idPedido) {
        try {
            String sql = "{CALL Paquete_Pedidos.Eliminar_Pedido(?)}";
            callableStatement = conexion.prepareCall(sql);
            callableStatement.setInt(1, idPedido);
            callableStatement.execute();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}
