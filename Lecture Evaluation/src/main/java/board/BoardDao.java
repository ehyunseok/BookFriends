package board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import util.DatabaseUtil;

public class BoardDao {

	//사용자가 게시글을 작성할 수 있는 함수
		public int write(BoardDto boardDto) {
			
			String SQL = "INSERT INTO board VALUES (NULL, ?, ?, ?, ?, 0, 0, ?);";
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				conn = DatabaseUtil.getConnection();
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, boardDto.userID);
				pstmt.setString(2, boardDto.postCategory);
				pstmt.setString(3, boardDto.postTitle);
				pstmt.setString(4, boardDto.postContent);
				pstmt.setTimestamp(5, boardDto.postDate);
				return pstmt.executeUpdate();	// insert구문을 실행한 결과를 반환함
				
			} catch(Exception e) {
				e.printStackTrace();
			} finally {
				try { if(conn != null) conn.close();} catch(Exception e ) {e.printStackTrace();}
				try { if(pstmt != null) pstmt.close();} catch(Exception e ) {e.printStackTrace();}
				try { if(rs != null) rs.close();} catch(Exception e ) {e.printStackTrace();}
			}
			return -1; // db 오류

		}

// 자유게시판 리스트 불러오기(조회, 검색)
		public ArrayList<BoardDto> getList(String postCategory, String searchType, String search, int pageNumber) {
		    if (postCategory.equals("전체")) {
		    	postCategory = "";
		    }
		    
		    ArrayList<BoardDto> boardList = null;
		    String SQL = "";
		    
		    Connection conn = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    
		    try {
		        conn = DatabaseUtil.getConnection();
		        
		        if (searchType.equals("최신순")) {
		            SQL = "SELECT * FROM board "
		                + "WHERE postCategory LIKE ? "
		                + "AND CONCAT(userID, postTitle, postContent) LIKE ? "
		                + "ORDER BY postDate DESC LIMIT ?, ?";
		        } else if (searchType.equals("조회수순")) {
		            SQL = "SELECT * FROM board "
		                + "WHERE postCategory LIKE ? "
		                + "AND CONCAT(userID, postTitle, postContent) LIKE ? "
		                + "ORDER BY viewCount DESC LIMIT ?, ?";
		        } else if (searchType.equals("추천순")) {
		        	SQL = "SELECT * FROM board "
			                + "WHERE postCategory LIKE ? "
			                + "AND CONCAT(userID, postTitle, postContent) LIKE ? "
			                + "ORDER BY likeCount DESC LIMIT ?, ?";
			        }
		        
		        pstmt = conn.prepareStatement(SQL);
		        pstmt.setString(1, "%" + postCategory + "%");
		        pstmt.setString(2, "%" + search + "%");
		        pstmt.setInt(3, pageNumber * 5); // offset 계산
		        pstmt.setInt(4, pageNumber * 5 + 6); // row count
		        
		        rs = pstmt.executeQuery();
		        
		        boardList = new ArrayList<BoardDto>(); // 조회 결과를 저장하는 리스트를 초기화함
		        while (rs.next()) { // 모든 게시글이 존재할 때마다 리스트에 담길 수 있게 함
		        	BoardDto boardDto = new BoardDto(
		                    rs.getInt(1),
		                    rs.getString(2),
		                    rs.getString(3),
		                    rs.getString(4),
		                    rs.getString(5),
		                    rs.getInt(6),
		                    rs.getInt(7),
		                    rs.getTimestamp(8)
		            );
		            boardList.add(boardDto);
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        try { if (conn != null) conn.close(); } catch (Exception e ) { e.printStackTrace(); }
		        try { if (pstmt != null) pstmt.close(); } catch (Exception e ) { e.printStackTrace(); }
		        try { if (rs != null) rs.close(); } catch (Exception e ) { e.printStackTrace(); }
		    }
		    
		    return boardList;
		}
		
// 게시글 추천
		public int like(String postID) {

			String SQL = "UPDATE board SET likeCount = likeCount + 1 WHERE postID = ?;";
			// 실행 시 해당 평가의 추천 1씩 증가시킴
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			
			try {
				conn = DatabaseUtil.getConnection();
				pstmt = conn.prepareStatement(SQL);
				pstmt.setInt(1, Integer.parseInt(postID));
				return pstmt.executeUpdate();	//실행 결과를 반환함
			} catch(Exception e) {
				e.printStackTrace();
			} finally {
				try { if(conn != null) conn.close();} catch(Exception e ) {e.printStackTrace();}
				try { if(pstmt != null) pstmt.close();} catch(Exception e ) {e.printStackTrace();}
			}
			return -1;	//오류 발생
		}
		
// 강의평가 삭제
		public int delete(String postID) {
			
			String SQL = "DELETE FROM board WHERE postID = ?";
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			
			try {
				conn = DatabaseUtil.getConnection();
				pstmt = conn.prepareStatement(SQL);
				pstmt.setInt(1, Integer.parseInt(postID));
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
		public String getUserID(String postID) {
			
			String SQL = "SELECT userID FROM board WHERE postID = ?;";
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				conn = DatabaseUtil.getConnection();
				pstmt = conn.prepareStatement(SQL);
				pstmt.setInt(1, Integer.parseInt(postID));
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

	
		
// 게시글 가져오기
		public BoardDto getPost(String postID) {
			
			String updateSQL = "UPDATE board SET viewCount = viewCount + 1 WHERE postID = ?;"; 
			String selectSQL = "SELECT * FROM board WHERE postID = ?;";
			
			Connection conn = null;
			PreparedStatement upPstmt = null;
			PreparedStatement selPstmt = null;
			ResultSet rs = null;
			
			try {
				conn = DatabaseUtil.getConnection();
				
				upPstmt = conn.prepareStatement(updateSQL);
				upPstmt.setInt(1, Integer.parseInt(postID));
				upPstmt.executeUpdate();
				
				selPstmt = conn.prepareStatement(selectSQL);
				selPstmt.setInt(1, Integer.parseInt(postID));
				rs = selPstmt.executeQuery();
				if(rs.next()) {
					BoardDto board = new BoardDto(); 
					board.setPostID(rs.getInt(1));
					board.setUserID(rs.getString(2));
					board.setPostCategory(rs.getString(3));
					board.setPostTitle(rs.getString(4));
					board.setPostContent(rs.getString(5));
					board.setViewCount(rs.getInt(6));
					board.setLikeCount(rs.getInt(7));
					board.setPostDate(rs.getTimestamp(8));
					return board;
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
		
		// 특정 게시글 추천
		public int likePost(String postID) {
			String SQL = "UPDATE board SET likeCount = likeCount + 1 WHERE postID = ?;";
			// 실행 시 해당 평가의 추천 1씩 증가시킴
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			
			try {
				conn = DatabaseUtil.getConnection();
				pstmt = conn.prepareStatement(SQL);
				pstmt.setInt(1, Integer.parseInt(postID));
				return pstmt.executeUpdate();	//실행 결과를 반환함
			} catch(Exception e) {
				e.printStackTrace();
			} finally {
				try { if(conn != null) conn.close();} catch(Exception e ) {e.printStackTrace();}
				try { if(pstmt != null) pstmt.close();} catch(Exception e ) {e.printStackTrace();}
			}
			return -1;	//오류 발생
		}
		
//게시글 삭제
		public int deletePost(String postID) {
			
			String SQL = "DELETE FROM board WHERE postID = ?;";
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			try {
				conn = DatabaseUtil.getConnection();
				pstmt = conn.prepareStatement(SQL);
				pstmt.setInt(1, Integer.parseInt(postID));
				return pstmt.executeUpdate();
			} catch(Exception e) {
				e.printStackTrace();
			} finally {
				try { if(conn != null) conn.close();} catch(Exception e ) {e.printStackTrace();}
				try { if(pstmt != null) pstmt.close();} catch(Exception e ) {e.printStackTrace();}
			}
			return -1;
		}
		
		
// 게시글 수정
		public int update(int postID, String postCategory, String postTitle, String postContent) {

			String SQL = "UPDATE board SET postCategory = ?, postTitle = ?, postContent = ? WHERE postID = ?;";
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				conn = DatabaseUtil.getConnection();
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, postCategory);
				pstmt.setString(2, postTitle);
				pstmt.setString(3, postContent);
				pstmt.setInt(4, postID);
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
		
}
