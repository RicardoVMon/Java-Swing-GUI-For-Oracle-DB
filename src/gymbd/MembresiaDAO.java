package gymbd;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import javax.swing.JOptionPane;
import java.sql.SQLException;
import oracle.jdbc.OracleTypes;

/**
 *
 * @author arian
 */
public class MembresiaDAO {
    private CallableStatement callableStatement = null;
    private ResultSet resultSet = null;
    private Connection connection;
    

    // Leer 
    public ResultSet obtenerMembresias(Connection conexion) {
        try {
            String sql = "{CALL SP_Visualizar_Membresias(?)}";
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

    // Leer  por ID
    public ResultSet obtenerMembresiaPorID(Connection conexion, int idMembresia) {
        try {
            String sql = "{CALL SP_Visualizar_Membresias_ID(?, ?)}";
            callableStatement = conexion.prepareCall(sql);
            callableStatement.setInt(1, idMembresia);
            callableStatement.registerOutParameter(2, OracleTypes.CURSOR);
            callableStatement.execute();
            resultSet = (ResultSet) callableStatement.getObject(2);
            return resultSet;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Crear membresia
    public boolean crearMembresia(Connection conexion, String nombre, double precio, int duracion) {
        try {
            String sql = "{call SP_Crear_Membresias(?, ?, ?)}";
            callableStatement = conexion.prepareCall(sql);

            callableStatement.setString(1, nombre);
            callableStatement.setDouble(2, precio);
            callableStatement.setInt(3, duracion);

            callableStatement.execute();
            
            //System.out.println("Membresía creada con éxito.");
            return true;

        } catch (SQLException e) {
            if (e.getErrorCode() == 20001) {
                JOptionPane.showMessageDialog(null, "Ya existe una membresía con el nombre dado", "Error", JOptionPane.ERROR_MESSAGE);
            } else if (e.getErrorCode() == 20002) {
                JOptionPane.showMessageDialog(null, "El precio de la membresía no puede ser negativo", "Error", JOptionPane.ERROR_MESSAGE);
            } else {
                e.printStackTrace();
            }
            return false;
        }
    }

    // editar 
    public boolean actualizarMembresia(Connection conexion, int idMembresia, String nombre, double precio, int duracion) {
        try {
            String sql = "{CALL SP_Editar_Membresias(?, ?, ?, ?)}";
            callableStatement = conexion.prepareCall(sql);

            callableStatement.setInt(1, idMembresia);
            callableStatement.setString(2, nombre);
            callableStatement.setDouble(3, precio);
            callableStatement.setInt(4, duracion);

            callableStatement.execute();
            return true;

        } catch (SQLException e) {
            if (e.getErrorCode() == 20001) {
                JOptionPane.showMessageDialog(null, "Ya existe una membresía con el nombre dado", "Error", JOptionPane.ERROR_MESSAGE);
            } else if (e.getErrorCode() == 20002) {
                JOptionPane.showMessageDialog(null, "El precio de la membresía no puede ser negativo", "Error", JOptionPane.ERROR_MESSAGE);
            } else {
                e.printStackTrace();
            }
            return false;
        }
    }

    //eliminar/desactivar 
    public boolean eliminarMembresia(Connection conexion, int idMembresia) {
        try {
            String sql = "{CALL SP_Eliminar_Membresias(?)}";
            callableStatement = conexion.prepareCall(sql);
            callableStatement.setInt(1, idMembresia);
            callableStatement.execute();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}
