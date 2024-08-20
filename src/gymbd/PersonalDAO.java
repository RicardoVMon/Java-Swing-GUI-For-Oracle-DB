/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package gymbd;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import oracle.jdbc.OracleTypes;
/**
 *
 * @author Fio
 */
public class PersonalDAO {
  private CallableStatement callableStatement = null;
    private ResultSet resultSet = null;

    public ResultSet obtenerEntrenadores(Connection conexion) {
        try {
            String sql = "{CALL Paquete_Personal.Obtener_Entrenadores(?)}";
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

    
   /* public ResultSet obtenerNombresEntrenadores(Connection conexion) {
        try {
            String sql = "{CALL Paquete_Personal.Obtener_Nombres_Entrenadores(?)}";
            callableStatement = conexion.prepareCall(sql);
            callableStatement.registerOutParameter(1, OracleTypes.CURSOR);
            callableStatement.execute();
            resultSet = (ResultSet) callableStatement.getObject(1);
            return resultSet;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }*/

    public ResultSet obtenerEntrenadorPorID(Connection conexion, int idEntrenador) {
        try {
            String sql = "{CALL Paquete_Personal.Obtener_Entrenador_Por_ID(?, ?)}";
            callableStatement = conexion.prepareCall(sql);
            callableStatement.setInt(1, idEntrenador);
            callableStatement.registerOutParameter(2, OracleTypes.CURSOR);
            callableStatement.execute();
            resultSet = (ResultSet) callableStatement.getObject(2);
            return resultSet;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean ingresarEntrenador(Connection conexion, String nombre, String apellidoPaterno,
            String apellidoMaterno, String especialidad) {

        try {
            String sql = "{call Paquete_Personal.Ingresar_Entrenador(?, ?, ?, ?)}";
            callableStatement = conexion.prepareCall(sql);
            callableStatement.setString(1, nombre);
            callableStatement.setString(2, apellidoPaterno);
            callableStatement.setString(3, apellidoMaterno);
            callableStatement.setString(4, especialidad);
            callableStatement.execute();
            System.out.println("Entrenador ingresado con éxito.");
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean actualizarEntrenador(Connection conexion, int idEntrenador, String nombre, String apellidoPaterno,
            String apellidoMaterno, String especialidad) {

        try {
            String sql = "{CALL Paquete_Personal.Actualizar_Entrenador(?, ?, ?, ?, ?, ?)}";
            callableStatement = conexion.prepareCall(sql);

            callableStatement.setInt(1, idEntrenador);
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

    public boolean eliminarEntrenador(Connection conexion, int idEntrenador) {
        try {
            String sql = "{CALL Paquete_Personal.Eliminar_Entrenador(?)}";
            callableStatement = conexion.prepareCall(sql);
            callableStatement.setInt(1, idEntrenador);
            callableStatement.execute();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }   
}
