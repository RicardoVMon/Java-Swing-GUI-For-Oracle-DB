package gymbd;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import oracle.jdbc.OracleTypes;

public class ClienteDAO {

    private CallableStatement callableStatement = null;
    private ResultSet resultSet = null;

    // Método para obtener todos los clientes
    public ResultSet obtenerClientes(Connection conexion) {
        try {
            String sql = "{CALL Obtener_Clientes(?)}";
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

    // Método para obtener un cliente por ID
    public ResultSet obtenerClientePorID(Connection conexion, int idCliente) {
        try {
            String sql = "{CALL Obtener_Cliente_Por_ID(?, ?)}";
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

    // Método para ingresar un cliente
    public boolean ingresarCliente(Connection conexion, String nombre, String apellidoPaterno,
            String apellidoMaterno, int edad, String email,
            String telefono, Integer idMembresia) {

        try {
            String sql = "{call Ingresar_Cliente(?, ?, ?, ?, ?, ?, ?)}";
            callableStatement = conexion.prepareCall(sql);

            callableStatement.setString(1, nombre);
            callableStatement.setString(2, apellidoPaterno);
            callableStatement.setString(3, apellidoMaterno);
            callableStatement.setInt(4, edad);
            callableStatement.setString(5, email);
            callableStatement.setString(6, telefono);

            if (idMembresia != null) {
                callableStatement.setInt(7, idMembresia);
            } else {
                callableStatement.setNull(7, java.sql.Types.INTEGER);
            }

            callableStatement.execute();
            System.out.println("Cliente ingresado con éxito.");
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Método para actualizar un cliente
    public boolean actualizarCliente(Connection conexion, int idCliente, String nombre, String apellidoPaterno,
            String apellidoMaterno, int edad, String email,
            String telefono, Integer idMembresia) {

        try {
            String sql = "{CALL Actualizar_Cliente(?, ?, ?, ?, ?, ?, ?, ?)}";
            callableStatement = conexion.prepareCall(sql);

            callableStatement.setInt(1, idCliente);
            callableStatement.setString(2, nombre);
            callableStatement.setString(3, apellidoPaterno);
            callableStatement.setString(4, apellidoMaterno);
            callableStatement.setInt(5, edad);
            callableStatement.setString(6, email);
            callableStatement.setString(7, telefono);

            if (idMembresia != null) {
                callableStatement.setInt(8, idMembresia);
            } else {
                callableStatement.setNull(8, java.sql.Types.INTEGER);
            }
            callableStatement.execute();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Método para eliminar un cliente
    public boolean eliminarCliente(Connection conexion, int idCliente) {
        try {
            String sql = "{CALL Eliminar_Cliente(?)}";
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
