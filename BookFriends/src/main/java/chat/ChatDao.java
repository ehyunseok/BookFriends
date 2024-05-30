package chat;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import util.DatabaseUtil;

public class ChatDao {
	
	private Connection conn;

//chatList 불러오기	
	public ArrayList<ChatDto> getChatListByID(String senderID, String receiverID, String chatID) {
		ArrayList<ChatDto> chatList = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "SELECT * FROM chat "
				+ "WHERE ( "
				+ "(senderID = ? AND receiverID =?) OR (senderID = ? AND receiverID =?) "
				+ ") "
				+ "AND chatID > ? "
				+ "ORDER BY chatTime";
		
		conn = DatabaseUtil.getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, senderID);
			pstmt.setString(2, receiverID);	//사용자가 수신한 메시지든 발신한 메시지든 모두 다 조회할 수 있게 
			pstmt.setString(3, receiverID);	//
			pstmt.setString(4, senderID);
			pstmt.setString(5, chatID);
			rs = pstmt.executeQuery();
			
			chatList = new ArrayList<>();
			
			while(rs.next()) {
				ChatDto chat = new ChatDto();
				chat.setChatID(rs.getInt("chatID"));
				chat.setSenderID(rs.getString("senderID"));
				chat.setReceiverID(rs.getString("receiverID"));
				chat.setMessage(rs.getString("message"));
				chat.setChatTime(rs.getTimestamp("chatTime"));
				chatList.add(chat);
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
		return chatList;
	}
	
//최근 chatList 불러오기	
	public ArrayList<ChatDto> getChatListByRecent(String senderID, String receiverID, int num) {
		ArrayList<ChatDto> chatList = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "SELECT * FROM chat "
				+ "WHERE "
				+ "( (senderID = ? AND receiverID =?) OR (senderID = ? AND receiverID =?) )"
				+ "AND chatID > ( SELECT MAX(chatID) - ? FROM chat ) "
				+ "ORDER BY chatTime";
		
		conn = DatabaseUtil.getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, senderID);
			pstmt.setString(2, receiverID);	//사용자가 수신한 메시지든 발신한 메시지든 모두 다 조회할 수 있게 
			pstmt.setString(3, receiverID);	//
			pstmt.setString(4, senderID);
			pstmt.setInt(5, num);	//파라미터로 넘어온 num의 값을 chatID에서 뺀 값보다 큰 chatID를 가져와서 최근의 메시지 리스트만 볼 수 있게
			rs = pstmt.executeQuery();
			
			chatList = new ArrayList<>();
			
			while(rs.next()) {
				ChatDto chat = new ChatDto();
				chat.setChatID(rs.getInt("chatID"));
				chat.setSenderID(rs.getString("senderID"));
				chat.setReceiverID(rs.getString("receiverID"));
				chat.setMessage(rs.getString("message"));
				chat.setChatTime(rs.getTimestamp("chatTime"));
				chatList.add(chat);
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null) rs.close();
				if (pstmt != null) pstmt.close();
				if (conn != null) conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return chatList;
	}
	
	
//메시지 작성하기	
	public int submit(String senderID, String receiverID, String message) {
		PreparedStatement pstmt = null;
		String sql = "INSERT INTO chat VALUES (null, ?, ?, ?, NOW());";
		
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, senderID);
			pstmt.setString(2, receiverID);	 
			pstmt.setString(3, message);
			System.out.println("ChatDao-Processed receiverID: '" + receiverID + "'");
			int result= pstmt.executeUpdate();
			System.out.println("Inserted rows: " + result);
			return result;
			
		} catch (SQLException e) {
			e.printStackTrace();
			return -1; // db 오류 시 -1 반환
		} finally {
			try {
				if (pstmt != null) pstmt.close();
				if (conn != null) conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}


	

}
