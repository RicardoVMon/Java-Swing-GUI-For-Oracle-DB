package gymbd;

import GUI.Principal;
import javax.swing.JOptionPane;
import java.sql.Connection;
import java.sql.ResultSet;

public class Main {
    
    private static Principal menu;
    private static DBManager dbManager = new DBManager();
    private static Connection connection;
    private static ResultSet resultSet;

    public static void main(String[] args) {
        String[] opciones = {"Probar conexión a base de datos", "Abrir interfaz GUI"};
        int choice = JOptionPane.showOptionDialog(null, 
                "Seleccione una opción para visualizar", 
                "Menu", 
                JOptionPane.DEFAULT_OPTION, 
                JOptionPane.INFORMATION_MESSAGE, 
                null, 
                opciones, 
                opciones[0]);

        switch (choice) {
            case 0:
                probarConexion();
                break;
            case 1:
                menu = new Principal();
                break;
            default:
                System.exit(0);
        }
    }
    
    public static void probarConexion() {

        connection = dbManager.abrirConexion();

        if (connection != null) {
            resultSet = dbManager.ejecutarConsulta(connection, "SELECT * FROM PRUEBA");
            try {
                while (resultSet.next()) {
                    System.out.println(resultSet.getString("first_name") + " " + resultSet.getString("last_name")
                            + resultSet.getString("last_name") + " " + resultSet.getString("job_id"));
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            dbManager.cerrarConexion(connection);
        }

    }
}