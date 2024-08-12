package gymbd;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import oracle.jdbc.OracleTypes;

public class DBManager {

    private static String jdbcURL = "jdbc:oracle:thin:@localhost:1521:orcl";
    private static String username = "PLENGUAJES";
    private static String password = "PL";
    private CallableStatement callableStatement = null;
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

    public ResultSet ejecutarProcedimiento(Connection conexion, String sql) {
        try {
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

    public Object ejecutarFuncion(Connection conexion, String sql, int tipoSalida) {
        try {
            callableStatement = conexion.prepareCall(sql);
            callableStatement.registerOutParameter(1, tipoSalida);
            callableStatement.execute();
            return callableStatement.getObject(1);
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
            if (callableStatement != null && !callableStatement.isClosed()) {
                callableStatement.close();
                System.out.println("CallableStatement cerrado");
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

