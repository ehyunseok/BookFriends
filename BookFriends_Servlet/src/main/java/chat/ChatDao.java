package chat;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import org.apache.commons.text.StringEscapeUtils;

import user.UserDto;
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
				chat.setMessage(StringEscapeUtils.escapeHtml4(rs.getString("message")));
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
				+ "AND chatID > ( SELECT MAX(chatID) - ? "
				+ 					"FROM chat "
				+ 					"WHERE(senderID = ? AND receiverID = ?) OR (senderID = ? AND receiverID = ?) "
				+ 				")"
				+ "ORDER BY chatTime";
		
		conn = DatabaseUtil.getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, senderID);
			pstmt.setString(2, receiverID);	//사용자가 수신한 메시지든 발신한 메시지든 모두 다 조회할 수 있게 
			pstmt.setString(3, receiverID);	//
			pstmt.setString(4, senderID);
			pstmt.setInt(5, num);	//파라미터로 넘어온 num의 값을 chatID에서 뺀 값보다 큰 chatID를 가져와서 최근의 메시지 리스트만 볼 수 있게
			pstmt.setString(6, senderID);
			pstmt.setString(7, receiverID);	 
			pstmt.setString(8, receiverID);	
			pstmt.setString(9, senderID);
			rs = pstmt.executeQuery();
			
			chatList = new ArrayList<>();
			
			while(rs.next()) {
				ChatDto chat = new ChatDto();
				chat.setChatID(rs.getInt("chatID"));
				chat.setSenderID(rs.getString("senderID"));
				chat.setReceiverID(rs.getString("receiverID"));
				chat.setMessage(StringEscapeUtils.escapeHtml4(rs.getString("message")));
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
		String sql = "INSERT INTO chat VALUES (null, ?, ?, ?, NOW(), false);";
		
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, senderID);
			pstmt.setString(2, receiverID);	 
			pstmt.setString(3, StringEscapeUtils.escapeHtml4(message));
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

// 메시지를 읽으면 readChat이 true로 변경됨
	public int readChat(String senderID, String receiverID) {
		PreparedStatement pstmt = null;
		String sql = "UPDATE chat SET chatRead = true WHERE (senderID = ? AND receiverID = ?)";
		
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, senderID);
			pstmt.setString(2, receiverID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return -1;
	}
	
	
// 읽지 않은 메시지 개수
	public int countUnreadChat(String userID) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "SELECT COUNT(chatID) FROM chat WHERE senderID = ? AND chatRead = false";
		
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt("COUNT(chatID)");
			}
			return 0;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return -1;
	}
	
	
// 채팅한 유저들 찾기
    public ArrayList<UserDto> getChatFriends(String userID) {
        ArrayList<UserDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String SQL = "SELECT DISTINCT userID "
                    + "FROM ("
                    +   "SELECT receiverID AS userID "
                    +   "FROM chat "
                    +   "WHERE senderID = ? "
                    +   "UNION "
                    +   "SELECT senderID AS userID "
                    +   "FROM chat "
                    +   "WHERE receiverID = ?"
                    + ") AS all_chats "
                    + "ORDER BY userID ASC;";
        
        try {
            conn = DatabaseUtil.getConnection();  // 데이터베이스 연결 가져오기
            pstmt = conn.prepareStatement(SQL);    // SQL 쿼리 준비
            pstmt.setString(1, userID);           
            pstmt.setString(2, userID);           
            
            rs = pstmt.executeQuery();            // 쿼리 실행 및 결과 저장

            while (rs.next()) {                   // 결과 집합 순회
                UserDto user = new UserDto();     // UserDto 객체 생성
                user.setUserID(rs.getString("userID"));  // userID 설정
                list.add(user);                   // 리스트에 추가
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        
        return list;  // 완성된 리스트 반환
    }
}
