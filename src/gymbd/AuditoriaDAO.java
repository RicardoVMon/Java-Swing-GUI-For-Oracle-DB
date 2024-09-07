package gymbd;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import oracle.jdbc.OracleTypes;

public class AuditoriaDAO {

    private CallableStatement callableStatement = null;
    private ResultSet resultSet = null;

    public ResultSet obtenerAuditoria(Connection conexion) {
        try {
            String sql = "{CALL Paquete_Auditoria.SP_Obtener_Auditoria(?)}";
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

}
