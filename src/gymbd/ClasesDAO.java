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
public class ClasesDAO {
  private CallableStatement callableStatement = null;
    private ResultSet resultSet = null;

    public ResultSet obtenerClases(Connection conexion) {
        try {
            String sql = "{CALL Paquete_Clases.Obtener_Clases(?)}";
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

    public ResultSet obtenerNombresEntrenadores(Connection conexion) {
        try {
            String sql = "{CALL Paquete_Clases.Obtener_Nombres_Entrenadores(?)}";
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

   

    public ResultSet obtenerClasePorID(Connection conexion, int idClase) {
        try {
            String sql = "{CALL Paquete_Clases.Obtener_Clases_Por_ID(?, ?)}";
            callableStatement = conexion.prepareCall(sql);
            callableStatement.setInt(1, idClase);
            callableStatement.registerOutParameter(2, OracleTypes.CURSOR);
            callableStatement.execute();
            resultSet = (ResultSet) callableStatement.getObject(2);
            return resultSet;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

  

    public boolean ingresarClases(Connection conexion, String nombre, String descripcion,
            int capacidad, String horario,int entrenadores) {

        try {
            String sql = "{call Paquete_Clases.Ingresar_Clases(?, ?, ?, ?, ?, ?)}";
            callableStatement = conexion.prepareCall(sql);
            callableStatement.setString(1, nombre);
            callableStatement.setString(2, descripcion);
            callableStatement.setInt(3, capacidad);
            callableStatement.setString(4, horario);
            callableStatement.setInt(5, entrenadores);
            callableStatement.execute();
            System.out.println("Clase ingresada con éxito.");
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean actualizarClase(Connection conexion, int idClase, String nombre, String descripcion,
            int capacidad, String horario,
           int entrenadores) {

        try {
            String sql = "{CALL Paquete_Clases.Actualizar_Clases(?, ?, ?, ?, ?, ?, ?)}";
            callableStatement = conexion.prepareCall(sql);

            callableStatement.setInt(1, idClase);
            callableStatement.setString(1, nombre);
            callableStatement.setString(2, descripcion);
            callableStatement.setInt(3, capacidad);
            callableStatement.setString(4, horario);
            callableStatement.setInt(5, entrenadores);
            callableStatement.execute();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarClase(Connection conexion, int idClase) {
        try {
            String sql = "{CALL Paquete_Clases.Eliminar_Clase(?)}";
            callableStatement = conexion.prepareCall(sql);
            callableStatement.setInt(1, idClase);
            callableStatement.execute();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }   
}
