package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DatabaseUtil {

	public static Connection getConnection() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/lectureevaluation";
			String dbID = "root";
			String dbPassword = "mysql";
			Class.forName("com.mysql.cj.jdbc.Driver");
			System.out.println("DB 연결 완료");
			return DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch(Exception e){
			System.out.println("DB 연결 실패: " + e.getMessage());
			return null;
		}
	}
	
}
