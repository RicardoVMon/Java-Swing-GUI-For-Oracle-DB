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
                probarConexionFuncion();
                break;
            case 1:
                menu = new Principal();
                break;
            default:
                System.exit(0);
        }
    }

    public static void probarConexionFuncion() {
        connection = dbManager.abrirConexion();

        if (connection != null) {
            // Llamada a una función que retorna un número
            Object resultado = dbManager.ejecutarFuncion(connection, "{? = call CANTIDAD_CLIENTES()}", java.sql.Types.NUMERIC);

            if (resultado != null) {
                System.out.println("Resultado de la función: " + resultado);
            } else {
                System.out.println("No se pudo obtener el resultado de la función");
            }

            dbManager.cerrarConexion(connection);
        }
    }

}
