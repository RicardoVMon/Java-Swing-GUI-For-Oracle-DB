package gymbd;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class DBManager {

    private static String jdbcURL = "jdbc:oracle:thin:@localhost:1521:orcl";
    private static String username = "PLENGUAJES";
    private static String password = "PL";
    private Statement statement = null;
    private ResultSet resultSet = null;

    public Connection abrirConexion() {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection conexion = DriverManager.getConnection(jdbcURL, username, password);
            System.out.println("Conexión establecida");
            return conexion;
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("No se pudo establecer la conexión");
            return null;
        }
    }

    public ResultSet ejecutarConsulta(Connection conexion, String sql) {
        try {
            statement = conexion.createStatement();
            resultSet = statement.executeQuery(sql);
            return resultSet;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public void cerrarConexion(Connection conexion) {
        try {
            if (resultSet != null && !resultSet.isClosed()) {
                resultSet.close();
                System.out.println("ResultSet cerrado");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            if (statement != null && !statement.isClosed()) {
                statement.close();
                System.out.println("Statement cerrado");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            if (conexion != null && !conexion.isClosed()) {
                conexion.close();
                System.out.println("Conexión cerrada");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
