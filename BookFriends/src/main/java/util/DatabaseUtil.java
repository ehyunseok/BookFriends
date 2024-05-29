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
			System.out.println("연결완료");
			return DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
	
}
