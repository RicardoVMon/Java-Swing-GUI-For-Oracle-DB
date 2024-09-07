package gymbd;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import oracle.jdbc.OracleTypes;

public class EvaluacionesDAO {

    private CallableStatement callableStatement = null;
    private ResultSet resultSet = null;

    public ResultSet obtenerEvaluaciones(Connection conexion) {
        try {
            String sql = "{CALL Paquete_Evaluaciones.Obtener_Evaluaciones(?)}";
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

    public ResultSet obtenerEvaluacionPorID(Connection conexion, int idEvaluacion) {
        try {
            String sql = "{CALL Paquete_Evaluaciones.Obtener_Evaluacion_Por_ID(?, ?)}";
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

    public boolean ingresarEvalucion(Connection conexion, int peso, int grasa,
            int masa, String fecha, String nombreCliente) {

        try {
            String sql = "{CALL Paquete_Evaluaciones.Ingresar_Evaluacion(?, ?, ?, ?, ?)}";
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

    public boolean actualizarEvaluacion(Connection conexion, int idEvaluacion, int peso, int grasa,
            int masa, String fecha, String nombreCliente) {

        try {
            String sql = "{CALL Paquete_Evaluaciones.Actualizar_Evaluacion(?, ?, ?, ?, ?, ?)}";
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

    public boolean eliminarEvaluacion(Connection conexion, int idEvaluacion) {
        try {
            String sql = "{CALL Paquete_Evaluaciones.Eliminar_Evaluacion(?)}";
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
