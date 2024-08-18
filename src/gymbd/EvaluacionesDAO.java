package gymbd;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import oracle.jdbc.OracleTypes;

public class EvaluacionesDAO {

    private CallableStatement callableStatement = null;
    private ResultSet resultSet = null;

    // Método para obtener todos los pagos
    public ResultSet obtenerEvaluaciones(Connection conexion) {
        try {
            String sql = "{CALL Obtener_Evaluaciones(?)}";
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

    // Método para obtener un pago por ID
    public ResultSet obtenerEvaluacionPorID(Connection conexion, int idEvaluacion) {
        try {
            String sql = "{CALL Obtener_Evaluacion_Por_ID(?, ?)}";
            callableStatement = conexion.prepareCall(sql);
            callableStatement.setInt(1, idEvaluacion);
            callableStatement.registerOutParameter(2, OracleTypes.CURSOR);
            callableStatement.execute();
            resultSet = (ResultSet) callableStatement.getObject(2);
            return resultSet;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Método para ingresar un cliente
    public boolean ingresarEvalucion(Connection conexion, int peso, int grasa,
            int masa, String fecha, String nombreCliente) {

        try {
            String sql = "{CALL Ingresar_Evaluacion(?, ?, ?, ?, ?)}";
            callableStatement = conexion.prepareCall(sql);

            callableStatement.setInt(1, peso);
            callableStatement.setInt(2, grasa);
            callableStatement.setInt(3, masa);
            callableStatement.setString(4, fecha);
            callableStatement.setString(5, nombreCliente);
            callableStatement.execute();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Método para actualizar un cliente
    public boolean actualizarEvaluacion(Connection conexion, int idEvaluacion, int peso, int grasa,
            int masa, String fecha, String nombreCliente) {

        try {
            String sql = "{CALL Actualizar_Evaluacion(?, ?, ?, ?, ?, ?)}";
            callableStatement = conexion.prepareCall(sql);

            callableStatement.setInt(1, idEvaluacion);
            callableStatement.setInt(2, peso);
            callableStatement.setInt(3, grasa);
            callableStatement.setInt(4, masa);
            callableStatement.setString(5, fecha);
            callableStatement.setString(6, nombreCliente);
            callableStatement.execute();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Método para eliminar un cliente
    public boolean eliminarEvaluacion(Connection conexion, int idEvaluacion) {
        try {
            String sql = "{CALL Eliminar_Evaluacion(?)}";
            callableStatement = conexion.prepareCall(sql);
            callableStatement.setInt(1, idEvaluacion);
            callableStatement.execute();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
