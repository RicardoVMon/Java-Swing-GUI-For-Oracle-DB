package gymbd;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import oracle.jdbc.OracleTypes;

public class ClienteDAO {

    private CallableStatement callableStatement = null;
    private ResultSet resultSet = null;

    public ResultSet obtenerClientes(Connection conexion) {
        try {
            String sql = "{CALL Paquete_Clientes.Obtener_Clientes(?)}";
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

    public ResultSet obtenerNombresClientes(Connection conexion) {
        try {
            String sql = "{CALL Paquete_Clientes.Obtener_Nombres_Clientes(?)}";
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

    public ResultSet obtenerMembresias(Connection conexion) {
        try {
            String sql = "{CALL Paquete_Clientes.Obtener_Membresias(?)}";
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

    public ResultSet obtenerClientePorID(Connection conexion, int idCliente) {
        try {
            String sql = "{CALL Paquete_Clientes.Obtener_Cliente_Por_ID(?, ?)}";
            callableStatement = conexion.prepareCall(sql);
            callableStatement.setInt(1, idCliente);
            callableStatement.registerOutParameter(2, OracleTypes.CURSOR);
            callableStatement.execute();
            resultSet = (ResultSet) callableStatement.getObject(2);
            return resultSet;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean ingresarCliente(Connection conexion, String nombre, String apellidoPaterno,
            String apellidoMaterno, int edad, String email,
            String telefono, String membresia) {

        try {
            String sql = "{call Paquete_Clientes.Ingresar_Cliente(?, ?, ?, ?, ?, ?, ?)}";
            callableStatement = conexion.prepareCall(sql);
            callableStatement.setString(1, nombre);
            callableStatement.setString(2, apellidoPaterno);
            callableStatement.setString(3, apellidoMaterno);
            callableStatement.setInt(4, edad);
            callableStatement.setString(5, email);
            callableStatement.setString(6, telefono);
            callableStatement.setString(7, membresia);
            callableStatement.execute();
            System.out.println("Cliente ingresado con éxito.");
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean actualizarCliente(Connection conexion, int idCliente, String nombre, String apellidoPaterno,
            String apellidoMaterno, int edad, String email,
            String telefono, String nombreMembresia) {

        try {
            String sql = "{CALL Paquete_Clientes.Actualizar_Cliente(?, ?, ?, ?, ?, ?, ?, ?)}";
            callableStatement = conexion.prepareCall(sql);

            callableStatement.setInt(1, idCliente);
            callableStatement.setString(2, nombre);
            callableStatement.setString(3, apellidoPaterno);
            callableStatement.setString(4, apellidoMaterno);
            callableStatement.setInt(5, edad);
            callableStatement.setString(6, email);
            callableStatement.setString(7, telefono);
            callableStatement.setString(8, nombreMembresia);
            callableStatement.execute();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarCliente(Connection conexion, int idCliente) {
        try {
            String sql = "{CALL Paquete_Clientes.Eliminar_Cliente(?)}";
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
