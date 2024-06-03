package board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import org.apache.commons.text.StringEscapeUtils;
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
			pstmt.setString(1, StringEscapeUtils.escapeHtml4(boardDto.userID));
			pstmt.setString(2, StringEscapeUtils.escapeHtml4(boardDto.postCategory));
			pstmt.setString(3, StringEscapeUtils.escapeHtml4(boardDto.postTitle));
			pstmt.setString(4, StringEscapeUtils.escapeHtml4(boardDto.postContent));
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
        ArrayList<BoardDto> list = new ArrayList<>();
        String SQL = "";
        if (postCategory.equals("전체")) {
            postCategory = "";
        }

        // Sort by searchType
        String orderByClause = "";
        switch (searchType) {
            case "조회수순":
                orderByClause = " ORDER BY viewCount DESC";
                break;
            case "추천순":
                orderByClause = " ORDER BY likeCount DESC";
                break;
            case "최신순":
            default:
                orderByClause = " ORDER BY postDate DESC";
                break;
        }

        SQL = "SELECT * FROM board WHERE postCategory LIKE ? AND CONCAT(userID, postTitle, postContent) LIKE ?" + orderByClause + " LIMIT ?, ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setString(1, "%" + postCategory + "%");
            pstmt.setString(2, "%" + search + "%");
            pstmt.setInt(3, pageNumber * 5);
            pstmt.setInt(4, 5);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    BoardDto boardDto = new BoardDto(
                        rs.getInt("postID"),
                        rs.getString("userID"),
                        rs.getString("postCategory"),
                        rs.getString("postTitle"),
                        rs.getString("postContent"),
                        rs.getInt("viewCount"),
                        rs.getInt("likeCount"),
                        rs.getTimestamp("postDate")
                    );
                    list.add(boardDto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int getTotalPosts(String postCategory, String searchType, String search) {
        if (postCategory.equals("전체")) {
            postCategory = "";
        }

        int totalPosts = 0;
        String SQL = "SELECT COUNT(*) FROM board WHERE postCategory LIKE ? AND CONCAT(userID, postTitle, postContent) LIKE ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setString(1, "%" + postCategory + "%");
            pstmt.setString(2, "%" + search + "%");
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    totalPosts = rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return totalPosts;
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
			pstmt.setString(1, StringEscapeUtils.escapeHtml4(postCategory));
			pstmt.setString(2, StringEscapeUtils.escapeHtml4(postTitle));
			pstmt.setString(3, StringEscapeUtils.escapeHtml4(postContent));
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
		
// 게시글 등록할 때 postID 정보 가져오기
	public BoardDto getPost(int postID) {
	    String SQL = "SELECT * FROM board WHERE postID = ?";
	    
	    try (Connection conn = DatabaseUtil.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(SQL)) {
	         
	        pstmt.setInt(1, postID);
	        try (ResultSet rs = pstmt.executeQuery()) {
	            if (rs.next()) {
	                BoardDto board = new BoardDto();
	                board.setPostID(rs.getInt("postID"));
	                board.setUserID(rs.getString("userID"));
	                board.setPostTitle(rs.getString("postTitle"));
	                board.setPostContent(rs.getString("postContent"));
	                board.setLikeCount(rs.getInt("likeCount"));
	                board.setPostDate(rs.getTimestamp("postDate"));
	                board.setViewCount(rs.getInt("viewCount"));
	                return board;
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return null;
	}
		
// 방금 작성한 게시글 가져오기
	public BoardDto getPostAfterResist(String userID) {
		String selLPSQL = "SELECT MAX(postID) FROM board WHERE userID = ?;";
		
		String selectSQL = "SELECT * FROM board WHERE postID = ?;";
		
		try (Connection conn = DatabaseUtil.getConnection();
				PreparedStatement slpPstmt = conn.prepareStatement(selLPSQL);){
			
			//1. 사용자가 가장 최신에 작성한 글의 아이디를 가져온다.
			slpPstmt.setString(1, userID);
			try(ResultSet rs = slpPstmt.executeQuery();){
				int lastPostID = -1;
				if(rs.next()) {
					lastPostID = rs.getInt(1);
				}
				
				if(lastPostID == -1) {
					return null;	// 주어진 userID로 postID를 찾지 못함 
				}
				
				//2. lastPostID로 게시글을 조회감
				try(PreparedStatement selPstmt = conn.prepareStatement(selectSQL);){
					selPstmt.setInt(1, lastPostID);
					try(ResultSet rs2 = selPstmt.executeQuery();){
						if(rs2.next()) {
							BoardDto board = new BoardDto(); 
							board.setPostID(rs2.getInt(1));
							board.setUserID(rs2.getString(2));
							board.setPostCategory(rs2.getString(3));
							board.setPostTitle(rs2.getString(4));
							board.setPostContent(rs2.getString(5));
							board.setViewCount(rs2.getInt(6));
							board.setLikeCount(rs2.getInt(7));
							board.setPostDate(rs2.getTimestamp(8));
							return board;
						}
					}
				}
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
		
		

// 인기글 5개 불러오기
	public ArrayList<BoardDto> top5() {
	    ArrayList<BoardDto> boardList = null;
	    String SQL = "SELECT * FROM board ORDER BY likeCount DESC LIMIT 5";
	    
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    
	    try {
	        conn = DatabaseUtil.getConnection();
	        pstmt = conn.prepareStatement(SQL);
	        rs = pstmt.executeQuery();
	        
	        boardList = new ArrayList<BoardDto>();
	        while (rs.next()) {
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
		
}
