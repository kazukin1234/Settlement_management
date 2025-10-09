package util;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConnection クラスは、MySQL データベースとの接続を提供するユーティリティクラスです。
 */
public class DBConnection {


	private static final boolean IS_PROD = !"LOCAL".equalsIgnoreCase(System.getenv("ENV"));
	//環境変数 ENV=LOCAL ならローカルDBに接続
    //それ以外（本番/EC2上など）はRDSに接続
	
	
   //ENV=LOCAL → IS_PROD = false → ローカルDBへ接続
   //ENV が LOCAL 以外（PRODや未設定） → IS_PROD = true → RDSへ接続
  private static final String URL = IS_PROD ?
      "jdbc:mysql://localhost:3306/abc_system" :
      "jdbc:mysql://localhost:3306/abc_system";
  
  //IS_PROD=true → AWS RDSのエンドポイントへ接続
  //IS_PROD=false → ローカル MySQL へ接続
  
  //http://localhost:9164/abc_system_protype/LoginServlet
  //jdbc:mysql://database-seisankanri.c5woismkkuts.ap-northeast-3.rds.amazonaws.com:3306/abc_system
  private static final String USER = IS_PROD ? "admin" : "root";
  private static final String PASSWORD = IS_PROD ? "Kuma2025" : "";
  
  
  
//private static final String URL = "jdbc:mysql://localhost:9164/abc_system_protype";
//private static final String USER = "root";
//private static final String PASSWORD = "";
// AWSのRDS接続用
	//String URL = "jdbc:mysql://database-seisankanri.c5woismkkuts.ap-northeast-3.rds.amazonaws.com:3306/abc_system_protype";
	//String USER = "admin"; // RDS作成時に設定したマスターユーザー
	//String PASSWORD = "Kuma2025"; // マスターユーザーのパスワード

  
  
  
  
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