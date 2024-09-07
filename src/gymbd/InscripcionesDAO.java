package gymbd;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import oracle.jdbc.OracleTypes;

public class InscripcionesDAO {

    private CallableStatement callableStatement = null;
    private ResultSet resultSet = null;

    public ResultSet obtenerInscripciones(Connection conexion) {
        try {
            String sql = "{CALL Paquete_Inscripciones.SP_Obtener_Inscripciones(?)}";
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

    public boolean ingresarInscripcion(Connection conexion, String nombreCliente, String nombreClase) {

        try {
            String sql = "{call Paquete_Inscripciones.SP_Ingresar_Inscripcion(?, ?)}";
            callableStatement = conexion.prepareCall(sql);
            callableStatement.setString(1, nombreCliente);
            callableStatement.setString(2, nombreClase);
            callableStatement.execute();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarInscripcion(Connection conexion, int idCliente) {
        try {
            String sql = "{CALL Paquete_Inscripciones.SP_Eliminar_Inscripcion(?)}";
            callableStatement = conexion.prepareCall(sql);
            callableStatement.setInt(1, idCliente);
            callableStatement.execute();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
