package review;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import org.apache.commons.text.StringEscapeUtils;

import board.BoardDto;
import evaluation.EvaluationDto;
import util.DatabaseUtil;

public class ReviewDao {

//사용자가 서평을 작성할 수 있는 함수
	public int write(ReviewDto reviewDto) {
		
		String SQL = "INSERT INTO review "
				   + "VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, 0);";
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, StringEscapeUtils.escapeHtml4(reviewDto.userID));
			pstmt.setString(2, StringEscapeUtils.escapeHtml4(reviewDto.bookName));
			pstmt.setString(3, StringEscapeUtils.escapeHtml4(reviewDto.authorName));
			pstmt.setString(4, StringEscapeUtils.escapeHtml4(reviewDto.publisher));
			pstmt.setString(5, StringEscapeUtils.escapeHtml4(reviewDto.category));
			pstmt.setString(6, StringEscapeUtils.escapeHtml4(reviewDto.reviewTitle));
			pstmt.setString(7, StringEscapeUtils.escapeHtml4(reviewDto.reviewContent));
			pstmt.setInt(8, reviewDto.reviewScore);
			pstmt.setTimestamp(9, reviewDto.registDate);
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

// 서평리스트 리스트 불러오기(메인, 검색)
		public ArrayList<ReviewDto> getList(String category , String searchType, String search, int pageNumber) {
	        ArrayList<ReviewDto> list = new ArrayList<>();
	        String SQL = "";
	        if (category.equals("전체")) {
	        	category = "";
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
	                orderByClause = " ORDER BY registDate DESC";
	                break;
	        }

	        SQL = "SELECT * FROM review "
	        		+ "WHERE category LIKE ? "
	        		+ "AND CONCAT(userID, reviewTitle, reviewContent, bookName, authorName, publisher) LIKE ?" 
	        		+ orderByClause + " LIMIT ?, ?";

	        try (Connection conn = DatabaseUtil.getConnection();
	             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
	            pstmt.setString(1, "%" + category + "%");
	            pstmt.setString(2, "%" + search + "%");
	            pstmt.setInt(3, pageNumber * 5);
	            pstmt.setInt(4, 5);
	            try (ResultSet rs = pstmt.executeQuery()) {
	                while (rs.next()) {
	                    ReviewDto reviewDto = new ReviewDto(
	                        rs.getInt("reviewID"),
	                        rs.getString("userID"),
	                        rs.getString("bookName"),
	                        rs.getString("authorName"),
	                        rs.getString("publisher"),
	                        rs.getString("category"),
	                        rs.getString("reviewTitle"),
	                        rs.getString("reviewContent"),
	                        rs.getInt("reviewScore"),
	                        rs.getTimestamp("registDate"),
	                        rs.getInt("likeCount"),
	                        rs.getInt("viewCount")
	                    );
	                    list.add(reviewDto);
	                }
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	        return list;
	    }

	    public int getTotalReviews(String category, String searchType, String search) {
	        if (category.equals("전체")) {
	        	category = "";
	        }

	        int totalReviews = 0;
	        String SQL = "SELECT COUNT(*) FROM review "
	        		+ "WHERE category LIKE ? "
	        		+ "AND CONCAT(userID, reviewTitle, reviewContent, bookName, authorName, publisher) LIKE ?";

	        try (Connection conn = DatabaseUtil.getConnection();
	             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
	            pstmt.setString(1, "%" + category + "%");
	            pstmt.setString(2, "%" + search + "%");
	            try (ResultSet rs = pstmt.executeQuery()) {
	                if (rs.next()) {
	                	totalReviews = rs.getInt(1);
	                }
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	        return totalReviews;
	    }
		
	   
//////////////////////////////////////////
 // 서평 추천
	public int like(String reviewID) {

		String SQL = "UPDATE review SET likeCount = likeCount + 1 WHERE reviewID = ?;";
		// 실행 시 해당 평가의 추천 1씩 증가시킴
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, Integer.parseInt(reviewID));
			return pstmt.executeUpdate();	//실행 결과를 반환함
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try { if(conn != null) conn.close();} catch(Exception e ) {e.printStackTrace();}
			try { if(pstmt != null) pstmt.close();} catch(Exception e ) {e.printStackTrace();}
		}
		return -1;	//오류 발생
 		}
 		
 // 서평 작성자의 아이디 가져오기
	public String getUserID(String reviewID) {
		
		String SQL = "SELECT userID FROM review WHERE reviewID = ?;";
 			
 			Connection conn = null;
 			PreparedStatement pstmt = null;
 			ResultSet rs = null;
 			
 			try {
 				conn = DatabaseUtil.getConnection();
 				pstmt = conn.prepareStatement(SQL);
 				pstmt.setInt(1, Integer.parseInt(reviewID));
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

 // 서평 읽기
	public ReviewDto getReview(String reviewID) {
		
		String updateSQL = "UPDATE review SET viewCount = viewCount + 1 WHERE reviewID = ?;"; 
		String selectSQL = "SELECT * FROM review WHERE reviewID = ?;";
		
		Connection conn = null;
		PreparedStatement upPstmt = null;
		PreparedStatement selPstmt = null;
		ResultSet rs = null;
		
		try {
			conn = DatabaseUtil.getConnection();
			
			upPstmt = conn.prepareStatement(updateSQL);
			upPstmt.setInt(1, Integer.parseInt(reviewID));
			upPstmt.executeUpdate();
			
			selPstmt = conn.prepareStatement(selectSQL);
			selPstmt.setInt(1, Integer.parseInt(reviewID));
			rs = selPstmt.executeQuery();
			if(rs.next()) {
				ReviewDto review = new ReviewDto(); 
				review.setReviewID(rs.getInt(1));
				review.setUserID(rs.getString(2));
				review.setBookName(rs.getString(3));
				review.setAuthorName(rs.getString(4));
				review.setPublisher(rs.getString(5));
				review.setCategory(rs.getString(6));
				review.setReviewTitle(rs.getString(7));
				review.setReviewContent(rs.getString(8));
				review.setReviewScore(rs.getInt(9));
				review.setRegistDate(rs.getTimestamp(10));
				review.setLikeCount(rs.getInt(11));
				review.setViewCount(rs.getInt(12));
				return review;
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
	 		
 		
 //서평 삭제
	public int deletePost(String reviewID) {
		
		String SQL = "DELETE FROM review WHERE reviewID = ?;";
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, Integer.parseInt(reviewID));
			return pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try { if(conn != null) conn.close();} catch(Exception e ) {e.printStackTrace();}
			try { if(pstmt != null) pstmt.close();} catch(Exception e ) {e.printStackTrace();}
		}
		return -1;
	}
 		
 		
 // 서평 수정
	public int update(int reviewID, String category, String bookName, String authorName,
			String publisher, String reviewTitle, String reviewContent, int reviewScore) {

		String SQL = "UPDATE review "
				+ "SET "
				+ "  category = ? "
				+ ", bookName = ? "
				+ ", authorName = ? "
				+ ", publisher = ? "
				+ ", reviewTitle = ? "
				+ ", reviewContent = ? "
				+ ", reviewScore = ? "
				+ "WHERE reviewID = ?;";
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, StringEscapeUtils.escapeHtml4(category));
			pstmt.setString(2, StringEscapeUtils.escapeHtml4(bookName));
			pstmt.setString(3, StringEscapeUtils.escapeHtml4(authorName));
			pstmt.setString(4, StringEscapeUtils.escapeHtml4(publisher));
			pstmt.setString(5, StringEscapeUtils.escapeHtml4(reviewTitle));
			pstmt.setString(6, StringEscapeUtils.escapeHtml4(reviewContent));
			pstmt.setInt(7, reviewScore);
			pstmt.setInt(8, reviewID);
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
 		
 // 서평 등록할 때 reviewID 정보 가져오기
	public ReviewDto getReviewInfo(int reviewID) {
	    String SQL = "SELECT * FROM review WHERE reviewID = ?";
	    
	    try (Connection conn = DatabaseUtil.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(SQL)) {
	         
	        pstmt.setInt(1, reviewID);
	        try (ResultSet rs = pstmt.executeQuery()) {
	            if (rs.next()) {
	            	ReviewDto review = new ReviewDto(); 
					review.setReviewID(rs.getInt(1));
					review.setUserID(rs.getString(2));
					review.setBookName(rs.getString(3));
					review.setAuthorName(rs.getString(4));
					review.setPublisher(rs.getString(5));
					review.setCategory(rs.getString(6));
					review.setReviewTitle(rs.getString(7));
					review.setReviewContent(rs.getString(8));
					review.setReviewScore(rs.getInt(9));
					review.setRegistDate(rs.getTimestamp(10));
					review.setLikeCount(rs.getInt(11));
					review.setViewCount(rs.getInt(12));
					return review;
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return null;
	}
 		
 // 방금 작성한 서평 가져오기
	public ReviewDto getReviewAfterRegist(String userID) {
		String selLPSQL = "SELECT MAX(reviewID) FROM review WHERE userID = ?;";
		
		String selectSQL = "SELECT * FROM review WHERE reviewID = ?;";
		
		try (Connection conn = DatabaseUtil.getConnection();
				PreparedStatement slpPstmt = conn.prepareStatement(selLPSQL);){
			
			//1. 사용자가 가장 최신에 작성한 글의 아이디를 가져온다.
			slpPstmt.setString(1, userID);
			try(ResultSet rs = slpPstmt.executeQuery();){
				int lastReviewID = -1;
				if(rs.next()) {
					lastReviewID = rs.getInt(1);
				}
				
				if(lastReviewID == -1) {
					return null;	// 주어진 userID로 reviewID를 찾지 못함 
				}
				
				//2. lastReviewID로 게시글을 조회감
				try(PreparedStatement selPstmt = conn.prepareStatement(selectSQL);){
					selPstmt.setInt(1, lastReviewID);
					try(ResultSet rs2 = selPstmt.executeQuery();){
						if(rs2.next()) {
							ReviewDto review = new ReviewDto(); 
							review.setReviewID(rs2.getInt(1));
							review.setUserID(rs2.getString(2));
							review.setBookName(rs2.getString(3));
							review.setAuthorName(rs2.getString(4));
							review.setPublisher(rs2.getString(5));
							review.setCategory(rs2.getString(6));
							review.setReviewTitle(rs2.getString(7));
							review.setReviewContent(rs2.getString(8));
							review.setReviewScore(rs2.getInt(9));
							review.setRegistDate(rs2.getTimestamp(10));
							review.setLikeCount(rs2.getInt(11));
							review.setViewCount(rs2.getInt(12));
							return review;
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
	public ArrayList<ReviewDto> top5() {
	    ArrayList<ReviewDto> reviewList = null;
	    String SQL = "SELECT * FROM review ORDER BY likeCount DESC LIMIT 5";
	    
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    
	    try {
	        conn = DatabaseUtil.getConnection();
	        pstmt = conn.prepareStatement(SQL);
	        rs = pstmt.executeQuery();
	        
	        reviewList = new ArrayList<ReviewDto>();
	        while (rs.next()) {
	        	ReviewDto reviewDto = new ReviewDto(
	                    rs.getInt(1),
	                    rs.getString(2),
	                    rs.getString(3),
	                    rs.getString(4),
	                    rs.getString(5),
	                    rs.getString(6),
	                    rs.getString(7),
	                    rs.getString(8),
	                    rs.getInt(9),
	                    rs.getTimestamp(10),
	                    rs.getInt(11),
	                    rs.getInt(12)
	            );
	        	reviewList.add(reviewDto);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try { if (conn != null) conn.close(); } catch (Exception e ) { e.printStackTrace(); }
	        try { if (pstmt != null) pstmt.close(); } catch (Exception e ) { e.printStackTrace(); }
	        try { if (rs != null) rs.close(); } catch (Exception e ) { e.printStackTrace(); }
	    }
	    
	    return reviewList;
	}
	 		

}
