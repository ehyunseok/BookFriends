package user;

import java.sql.Connection;
import java.sql.PreparedStatement;

import util.DatabaseUtil;

// Database Access Object
public class UserDao {
	
	public int join(String userId, String userPassword) {
		String SQL = "INSERT INTO user VALUES (?, ?)";
		try {
//			Class.forName("com.mysql.jdbc.Driver");

			
			Connection conn = DatabaseUtil.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userId);
			pstmt.setString(2, userPassword);
			return pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
		
	}

}
