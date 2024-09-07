package gymbd;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import oracle.jdbc.OracleTypes;

public class PersonalDAO {

    private CallableStatement callableStatement = null;
    private ResultSet resultSet = null;

    public ResultSet obtenerPersonal(Connection conexion) {
        try {
            String sql = "{CALL Paquete_Entrenador.Obtener_Entrenadores(?)}";
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

    public ResultSet obtenerNombresPersonal(Connection conexion) {
        try {
            String sql = "{CALL Obtener_Nombres_Entrenadores(?)}";
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

    public ResultSet obtenerPersonalPorID(Connection conexion, int idPersonal) {
        try {
            String sql = "{CALL Paquete_Entrenador.Obtener_Entrenador_Por_ID(?, ?)}";
            callableStatement = conexion.prepareCall(sql);
            callableStatement.setInt(1, idPersonal);
            callableStatement.registerOutParameter(2, OracleTypes.CURSOR);
            callableStatement.execute();
            resultSet = (ResultSet) callableStatement.getObject(2);
            return resultSet;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean ingresarPersonal(Connection conexion, String nombre, String apellidoPaterno,
            String apellidoMaterno, String especialidad) {
        try {
            String sql = "{call Paquete_Entrenador.Ingresar_Entrenador(?, ?, ?, ?)}";
            callableStatement = conexion.prepareCall(sql);
            callableStatement.setString(1, nombre);
            callableStatement.setString(2, apellidoPaterno);
            callableStatement.setString(3, apellidoMaterno);
            callableStatement.setString(4, especialidad);
            callableStatement.execute();
            System.out.println("Personal ingresado con éxito.");
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean actualizarPersonal(Connection conexion, int idPersonal, String nombre, String apellidoPaterno,
            String apellidoMaterno, String especialidad) {

        try {
            String sql = "{CALL Paquete_Entrenador.Actualizar_Entrenador(?, ?, ?, ?, ?)}";
            callableStatement = conexion.prepareCall(sql);

            callableStatement.setInt(1, idPersonal);
            callableStatement.setString(2, nombre);
            callableStatement.setString(3, apellidoPaterno);
            callableStatement.setString(4, apellidoMaterno);
            callableStatement.setString(5, especialidad);
            callableStatement.execute();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarPersonal(Connection conexion, int idCliente) {
        try {
            String sql = "{CALL Paquete_Entrenador.Eliminar_Entrenador(?)}";
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
