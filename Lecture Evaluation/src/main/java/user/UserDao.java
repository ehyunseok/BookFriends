package user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DatabaseUtil;

public class UserDao {
	
//로그인
	public int login(String userID, String userPassword) {
		
		String SQL = "SELECT userPassword FROM user WHERE userID = ?;";
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				if(rs.getString(1).equals(userPassword)) {
					return 1;	// 로그인 성공
				} else {
					return 0;	// 비번 틀림
				}
			}
			return -1;	// 아이디 없음
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try { if(conn != null) conn.close();} catch(Exception e ) {e.printStackTrace();}
			try { if(pstmt != null) pstmt.close();} catch(Exception e ) {e.printStackTrace();}
			try { if(rs != null) rs.close();} catch(Exception e ) {e.printStackTrace();}
		}
		return -2; // db 오류

	}
	
	
//회원가입
	public int join(UserDto user) {
		String SQL = "INSERT INTO user VALUES(?, ?, ?, ?, ?);";
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserEmail());
			pstmt.setString(4, user.getUserEmailHash());
			pstmt.setBoolean(5, Boolean.parseBoolean(user.getUserEmailChecked()));
			return pstmt.executeUpdate();	// 회원가입 성공
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try { if(conn != null) conn.close();} catch(Exception e ) {e.printStackTrace();}
			try { if(pstmt != null) pstmt.close();} catch(Exception e ) {e.printStackTrace();}
		}
		return -1; // 회원가입 실패
	}
	
	
//이메일 확인
	public boolean getUserEmailChecked(String userID) {
		
		String SQL = "SELECT userEmailChecked FROM user WHERE userID = ?;";
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getBoolean(1);	// 이메일 인증이 완료된 사용자일 경우 true 반환 
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try { if(conn != null) conn.close();} catch(Exception e ) {e.printStackTrace();}
			try { if(pstmt != null) pstmt.close();} catch(Exception e ) {e.printStackTrace();}
			try { if(rs != null) rs.close();} catch(Exception e ) {e.printStackTrace();}
		}
		return false;
	}

	
//이메일 인증 완료 처리
	public boolean setUserEmailChecked(String userID) {
		
		String SQL = "UPDATE user SET userEmailChecked = true WHERE userID = ?;";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.executeUpdate();
			return true;
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try { if(conn != null) conn.close();} catch(Exception e ) {e.printStackTrace();}
			try { if(pstmt != null) pstmt.close();} catch(Exception e ) {e.printStackTrace();}
			try { if(rs != null) rs.close();} catch(Exception e ) {e.printStackTrace();}
		}
		return false;
	}
	
	
//회원 이메일 조회
	public String getUserEmail(String userID) {
		
		String SQL = "SELECT userEmail FROM user WHERE userID = ?;";
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try { if(conn != null) conn.close();} catch(Exception e ) {e.printStackTrace();}
			try { if(pstmt != null) pstmt.close();} catch(Exception e ) {e.printStackTrace();}
			try { if(rs != null) rs.close();} catch(Exception e ) {e.printStackTrace();}
		}
		return null;
	}
	
	
	
}
