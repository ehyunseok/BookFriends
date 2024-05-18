package likey;

import java.sql.Connection;
import java.sql.PreparedStatement;

import util.DatabaseUtil;

public class LikeyDao {
	
	// 특정 게시글 추천
	public int like(String userID, String evaluationID, String userIP) {
		String SQL = "INSERT INTO likey VALUES(?, ?, ?);";
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			
			// 디버깅
			System.out.println("userID: " + userID);           
	        System.out.println("evaluationID: " + evaluationID);
	        System.out.println("userIP: " + userIP);
	        
			pstmt.setString(1, userID);
			pstmt.setString(2, evaluationID);
			pstmt.setString(3, userIP);
			return pstmt.executeUpdate();	// 성공
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try { if(conn != null) conn.close();} catch(Exception e ) {e.printStackTrace();}
			try { if(pstmt != null) pstmt.close();} catch(Exception e ) {e.printStackTrace();}
		}
		return -1; // 추천 중복 오류
	}
	

}
