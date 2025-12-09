package util;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConnection クラスは、MySQL データベースとの接続を提供するユーティリティクラスです。
 */
public class DBConnection {
//  private static final String URL = "jdbc:mysql://localhost:3306/abc_system";
//  private static final String USER = "root";
//  private static final String PASSWORD = "";
  // AWSのRDS接続用
//  private static final String URL = "jdbc:mysql://abc-db.c7yye40qgcj3.ap-northeast-3.rds.amazonaws.com:3306/abc_system";
//  private static final String USER = "admin";
//  private static final String PASSWORD = "pass1234";

  private static final boolean IS_PROD = "PROD".equals(System.getenv("ENV"));

  private static final String URL = IS_PROD ?
		    "jdbc:mysql://databasemain.c5woismkkuts.ap-northeast-3.rds.amazonaws.com:3306/abc_system" :
		    "jdbc:mysql://localhost:3306/abc_system";


  
  private static final String USER = IS_PROD ? "admin" : "root";
  private static final String PASSWORD = IS_PROD ? "Kuma2025" : "";
    /**
     * データベースとの接続を取得します。
     *
     * <p>ドライバが見つからない場合は SQLException をスローします。</p>
     *
     * @return データベースへの Connection オブジェクト
     * @throws SQLException ドライバが見つからない、または接続に失敗した場合
     */
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("JDBC driver not found", e);
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}