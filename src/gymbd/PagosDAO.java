package gymbd;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import oracle.jdbc.OracleTypes;

public class PagosDAO {

    private CallableStatement callableStatement = null;
    private ResultSet resultSet = null;

    public ResultSet obtenerPagos(Connection conexion) {
        try {
            String sql = "{CALL Paquete_Pagos.Obtener_Pagos(?)}";
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

    public ResultSet obtenerPagoPorID(Connection conexion, int idPago) {
        try {
            String sql = "{CALL Paquete_Pagos.Obtener_Pago_Por_ID(?, ?)}";
            callableStatement = conexion.prepareCall(sql);
            callableStatement.setInt(1, idPago);
            callableStatement.registerOutParameter(2, OracleTypes.CURSOR);
            callableStatement.execute();
            resultSet = (ResultSet) callableStatement.getObject(2);
            return resultSet;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean ingresarPago(Connection conexion, int monto, String fecha,
            String metodo, String concepto, String nombreCliente) {

        try {
            String sql = "{CALL Paquete_Pagos.Ingresar_Pago(?, ?, ?, ?, ?)}";
            callableStatement = conexion.prepareCall(sql);

            callableStatement.setInt(1, monto);
            callableStatement.setString(2, fecha);
            callableStatement.setString(3, metodo);
            callableStatement.setString(4, concepto);
            callableStatement.setString(5, nombreCliente);
            callableStatement.execute();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean actualizarPago(Connection conexion, int idPago, int monto, String fecha,
            String metodo, String concepto, String nombreCliente) {

        try {
            String sql = "{CALL Paquete_Pagos.Actualizar_Pago(?, ?, ?, ?, ?, ?)}";
            callableStatement = conexion.prepareCall(sql);

            callableStatement.setInt(1, idPago);
            callableStatement.setInt(2, monto);
            callableStatement.setString(3, fecha);
            callableStatement.setString(4, metodo);
            callableStatement.setString(5, concepto);
            callableStatement.setString(6, nombreCliente);
            callableStatement.execute();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarPago(Connection conexion, int idPago) {
        try {
            String sql = "{CALL Paquete_Pagos.Eliminar_Pago(?)}";
            callableStatement = conexion.prepareCall(sql);
            callableStatement.setInt(1, idPago);
            callableStatement.execute();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
