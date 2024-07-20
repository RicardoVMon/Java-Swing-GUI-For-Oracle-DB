package gymbd;

import GUI.Test;
import GUI.Principal;
import java.sql.Connection;
import java.sql.ResultSet;

public class Main {
    
    private static Principal menu;

    private static DBManager dbManager = new DBManager();
    private static Connection connection;
    private static ResultSet resultSet;

    public static void main(String[] args) {
        
        menu = new Principal();
        
//        connection = dbManager.abrirConexion();
//
//        if (connection != null) {
//            resultSet = dbManager.ejecutarConsulta(connection, "SELECT * FROM PRUEBA");
//            try {
//                while (resultSet.next()) {
//                    System.out.println(resultSet.getString("first_name") + " " + resultSet.getString("last_name")
//
//                            + resultSet.getString("last_name") + " " + resultSet.getString("job_id"));
//                }
//            } catch (Exception e) {
//                e.printStackTrace();
//            }
//            dbManager.cerrarConexion(connection);
//        }

    }
}
