package reply;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import board.BoardDto;
import util.DatabaseUtil;

public class ReplyDao {

//댓글 작성
		public int write(ReplyDto replyDto) {
			
			String SQL = "INSERT INTO reply VALUES (NULL, ?, ?, ?, 0, ?);";
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			
			try {
				conn = DatabaseUtil.getConnection();
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, replyDto.userID);
				pstmt.setInt(2, replyDto.postID);
				pstmt.setString(3, replyDto.replyContent);
				pstmt.setTimestamp(4, replyDto.replyDate);
				return pstmt.executeUpdate();	// insert구문을 실행한 결과를 반환함
				
			} catch(Exception e) {
				e.printStackTrace();
				System.err.println("Foreign key constraint violation: " + e.getMessage());
			} finally {
				try { if(conn != null) conn.close();} catch(Exception e ) {e.printStackTrace();}
				try { if(pstmt != null) pstmt.close();} catch(Exception e ) {e.printStackTrace();}
			}
			return -1; // db 오류
		}

// 댓글 리스트 불러오기
		public ArrayList<ReplyDto> getList(String postID) {
		    ArrayList<ReplyDto> replyList = null;
		    String SQL = "SELECT * FROM reply "
	                + "WHERE postID = ? "
	                + "ORDER BY replyDate DESC";
		    
		    Connection conn = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    
		    try {
		        conn = DatabaseUtil.getConnection();
		        pstmt = conn.prepareStatement(SQL);
		        pstmt = conn.prepareStatement(SQL);
		        pstmt.setString(1, postID);
		        
		        rs = pstmt.executeQuery();
		        
		        replyList = new ArrayList<ReplyDto>();
		        while (rs.next()) { // 해당 게시글에 댓글을 하나하나 리스트에 담길 수 있게 함
		        	ReplyDto replyDto = new ReplyDto(
		                    rs.getInt(1),
		                    rs.getString(2),
		                    rs.getInt(3),
		                    rs.getString(4),
		                    rs.getInt(5),
		                    rs.getTimestamp(6)
		            );
		        	replyList.add(replyDto);
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        try { if (conn != null) conn.close(); } catch (Exception e ) { e.printStackTrace(); }
		        try { if (pstmt != null) pstmt.close(); } catch (Exception e ) { e.printStackTrace(); }
		        try { if (rs != null) rs.close(); } catch (Exception e ) { e.printStackTrace(); }
		    }
		    
		    return replyList;
		}
		
// 댓글 추천
		public int like(String replyID) {

			String SQL = "UPDATE reply SET likeCount = likeCount + 1 WHERE replyID = ?;";
			// 실행 시 해당 평가의 추천 1씩 증가시킴
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			
			try {
				conn = DatabaseUtil.getConnection();
				pstmt = conn.prepareStatement(SQL);
				pstmt.setInt(1, Integer.parseInt(replyID));
				return pstmt.executeUpdate();	//실행 결과를 반환함
			} catch(Exception e) {
				e.printStackTrace();
			} finally {
				try { if(conn != null) conn.close();} catch(Exception e ) {e.printStackTrace();}
				try { if(pstmt != null) pstmt.close();} catch(Exception e ) {e.printStackTrace();}
			}
			return -1;	//오류 발생
		}
		
// 댓글 삭제
		public int delete(String replyID) {
			
			String SQL = "DELETE FROM reply WHERE replyID = ?";
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			
			try {
				conn = DatabaseUtil.getConnection();
				pstmt = conn.prepareStatement(SQL);
				pstmt.setInt(1, Integer.parseInt(replyID));
				return pstmt.executeUpdate();	//실행 결과를 반환함
			} catch(Exception e) {
				e.printStackTrace();
			} finally {
				try { if(conn != null) conn.close();} catch(Exception e ) {e.printStackTrace();}
				try { if(pstmt != null) pstmt.close();} catch(Exception e ) {e.printStackTrace();}
			}
			return -1;	//오류 발생
		}
		
// 게시글 작성자의 아이디 가져오기
		public String getUserID(String replyID) {
			
			String SQL = "SELECT userID FROM reply WHERE replyID = ?;";
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				conn = DatabaseUtil.getConnection();
				pstmt = conn.prepareStatement(SQL);
				pstmt.setInt(1, Integer.parseInt(replyID));
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
	
// 댓글 가져오기
		public ReplyDto getReply(String replyID) {
			
			if (replyID == null || replyID.isEmpty()) {
		        return null;
		    }
			
			String selectSQL = "SELECT * FROM reply WHERE replyID = ?;";
			
			Connection conn = null;
			PreparedStatement upPstmt = null;
			PreparedStatement selPstmt = null;
			ResultSet rs = null;
			
			try {
				conn = DatabaseUtil.getConnection();
				selPstmt = conn.prepareStatement(selectSQL);
				selPstmt.setInt(1, Integer.parseInt(replyID));
				rs = selPstmt.executeQuery();
				if(rs.next()) {
					ReplyDto reply = new ReplyDto(); 
					reply.setReplyID(rs.getInt("replyID"));
					reply.setUserID(rs.getString("userID"));
					reply.setPostID(rs.getInt("postID"));
					reply.setReplyContent(rs.getString("replyContent"));
					reply.setLikeCount(rs.getInt("likeCount"));
					reply.setReplyDate(rs.getTimestamp("replyDate"));
					return reply;
				}
			} catch(Exception e) {
				e.printStackTrace();
			} finally {
				try { if(conn != null) conn.close();} catch(Exception e ) {e.printStackTrace();}
				try { if(upPstmt != null) upPstmt.close();} catch(Exception e ) {e.printStackTrace();}
				try { if(selPstmt != null) selPstmt.close();} catch(Exception e ) {e.printStackTrace();}
				try { if(rs != null) rs.close();} catch(Exception e ) {e.printStackTrace();}
			}
			return null;
		}
		
// 특정 댓글 추천
		public int likeReply(String replyID) {
			String SQL = "UPDATE reply SET likeCount = likeCount + 1 WHERE replyID = ?;";
			// 실행 시 해당 평가의 추천 1씩 증가시킴
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			
			try {
				conn = DatabaseUtil.getConnection();
				pstmt = conn.prepareStatement(SQL);
				pstmt.setInt(1, Integer.parseInt(replyID));
				return pstmt.executeUpdate();	//실행 결과를 반환함
			} catch(Exception e) {
				e.printStackTrace();
			} finally {
				try { if(conn != null) conn.close();} catch(Exception e ) {e.printStackTrace();}
				try { if(pstmt != null) pstmt.close();} catch(Exception e ) {e.printStackTrace();}
			}
			return -1;	//오류 발생
		}
		
//댓글 삭제
		public int deleteReply(String replyID) {
			
			String SQL = "DELETE FROM reply WHERE replyID = ?;";
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			try {
				conn = DatabaseUtil.getConnection();
				pstmt = conn.prepareStatement(SQL);
				pstmt.setInt(1, Integer.parseInt(replyID));
				return pstmt.executeUpdate();
			} catch(Exception e) {
				e.printStackTrace();
			} finally {
				try { if(conn != null) conn.close();} catch(Exception e ) {e.printStackTrace();}
				try { if(pstmt != null) pstmt.close();} catch(Exception e ) {e.printStackTrace();}
			}
			return -1;
		}
		
		
// 댓글 수정
		public int update(int replyID, String replyContent) {

			String SQL = "UPDATE reply SET replyContent = ? WHERE replyID = ?;";
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				conn = DatabaseUtil.getConnection();
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, replyContent);
				pstmt.setInt(2, replyID);
				return pstmt.executeUpdate();
				
			} catch(Exception e) {
				e.printStackTrace();
			} finally {
				try { if(conn != null) conn.close();} catch(Exception e ) {e.printStackTrace();}
				try { if(pstmt != null) pstmt.close();} catch(Exception e ) {e.printStackTrace();}
				try { if(rs != null) rs.close();} catch(Exception e ) {e.printStackTrace();}
			}
			return -1; // db 오류

		}
//댓글 수 카운트
		public int countReply(String postID) {
			String SQL = "SELECT COUNT(*) FROM reply WHERE postID = ?;";
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				conn = DatabaseUtil.getConnection();
				pstmt = conn.prepareStatement(SQL);
				pstmt.setInt(1, Integer.parseInt(postID));
				rs = pstmt.executeQuery();
				if(rs.next()) {
					return rs.getInt(1);
				}
				
			} catch(Exception e) {
				e.printStackTrace();
			} finally {
				try { if(conn != null) conn.close();} catch(Exception e ) {e.printStackTrace();}
				try { if(pstmt != null) pstmt.close();} catch(Exception e ) {e.printStackTrace();}
				try { if(rs != null) rs.close();} catch(Exception e ) {e.printStackTrace();}
			}
			return -1;
		}

// 댓글의 해당 게시글 아이디 찾기
		public String getPostID(String replyID) {
			
			String SQL = "SELECT postID FROM reply WHERE replyID = ?;";
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				conn = DatabaseUtil.getConnection();
				pstmt = conn.prepareStatement(SQL);
				pstmt.setInt(1, Integer.parseInt(replyID));
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
