package likey;

import java.sql.Connection;
import java.sql.PreparedStatement;

import util.DatabaseUtil;

public class LikeyDao {
	
// 특정 강의평가글 추천
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
	
// 특정 게시글 추천
	public int likePost(String userID, String postID, String userIP) {
		String SQL = "INSERT INTO likeyPost VALUES(?, ?, ?);";
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			
			// 디버깅
			System.out.println("userID: " + userID);           
			System.out.println("postID: " + postID);
			System.out.println("userIP: " + userIP);
			pstmt.setString(1, userID);
			pstmt.setString(2, postID);
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
	
// 특정 댓글 추천
	public int likeReply(String userID, String replyID, String userIP) {
		String SQL = "INSERT INTO likeyReply VALUES(?, ?, ?);";
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			
			// 디버깅
			System.out.println("userID: " + userID);           
			System.out.println("replyID: " + replyID);
			System.out.println("userIP: " + userIP);
			pstmt.setString(1, userID);
			pstmt.setString(2, replyID);
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
	
// 특정 서평글 추천
	public int likeReview(String userID, String reviewID, String userIP) {
		String SQL = "INSERT INTO likeyReview VALUES(?, ?, ?);";
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			
			// 디버깅
			System.out.println("userID: " + userID);           
			System.out.println("reviewID: " + reviewID);
			System.out.println("userIP: " + userIP);
			pstmt.setString(1, userID);
			pstmt.setString(2, reviewID);
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
