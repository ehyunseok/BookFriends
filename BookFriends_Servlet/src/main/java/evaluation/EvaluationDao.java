package evaluation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import org.apache.commons.text.StringEscapeUtils;

import board.BoardDto;
import util.DatabaseUtil;

public class EvaluationDao {

	//사용자가 강의 평가를 작성할 수 있는 함수
		public int write(EvaluationDto evalDto) {
			
			String SQL = "INSERT INTO EVALUATION VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0);";
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				conn = DatabaseUtil.getConnection();
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, StringEscapeUtils.escapeHtml4(evalDto.userID));
				pstmt.setString(2, StringEscapeUtils.escapeHtml4(evalDto.lectureName));
				pstmt.setString(3, StringEscapeUtils.escapeHtml4(evalDto.professorName));
				pstmt.setInt(4, evalDto.lectureYear);
				pstmt.setString(5, StringEscapeUtils.escapeHtml4(evalDto.semesterDivide));
				pstmt.setString(6, StringEscapeUtils.escapeHtml4(evalDto.lectureDivide));
				pstmt.setString(7, StringEscapeUtils.escapeHtml4(evalDto.evaluationTitle));
				pstmt.setString(8, StringEscapeUtils.escapeHtml4(evalDto.evaluationContent));
				pstmt.setString(9, StringEscapeUtils.escapeHtml4(evalDto.totalScore));
				pstmt.setString(10, StringEscapeUtils.escapeHtml4(evalDto.usabilityScore));
				pstmt.setString(11, StringEscapeUtils.escapeHtml4(evalDto.skillScore));
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

// 강의평가 리스트 불러오기(메인, 검색)
		public ArrayList<EvaluationDto> getList(String lectureDivide, String searchType, String search, int pageNumber) {
		    if (lectureDivide.equals("전체")) {
		        lectureDivide = "";
		    }
		    
		    ArrayList<EvaluationDto> evalList = null;
		    String SQL = "";
		    
		    Connection conn = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    
		    try {
		        conn = DatabaseUtil.getConnection();
		        
		        if (searchType.equals("최신순")) {
		            SQL = "SELECT * FROM evaluation "
		                + "WHERE lectureDivide LIKE ? "
		                + "AND CONCAT(lectureName, professorName, evaluationTitle, evaluationContent) LIKE ? "
		                + "ORDER BY evaluationID DESC LIMIT ?, ?";
		        } else if (searchType.equals("추천순")) {
		            SQL = "SELECT * FROM evaluation "
		                + "WHERE lectureDivide LIKE ? "
		                + "AND CONCAT(lectureName, professorName, evaluationTitle, evaluationContent) LIKE ? "
		                + "ORDER BY likeCount DESC LIMIT ?, ?";
		        }
		        
		        pstmt = conn.prepareStatement(SQL);
		        pstmt.setString(1, "%" + lectureDivide + "%");
		        pstmt.setString(2, "%" + search + "%");
		        pstmt.setInt(3, pageNumber * 5); // offset 계산
		        pstmt.setInt(4, pageNumber * 5 + 6); // row count
		        
		        rs = pstmt.executeQuery();
		        
		        evalList = new ArrayList<EvaluationDto>(); // 조회 결과를 저장하는 리스트를 초기화함
		        while (rs.next()) { // 모든 게시글이 존재할 때마다 리스트에 담길 수 있게 함
		            EvaluationDto evalDto = new EvaluationDto(
		                    rs.getInt(1),
		                    rs.getString(2),
		                    rs.getString(3),
		                    rs.getString(4),
		                    rs.getInt(5),
		                    rs.getString(6),
		                    rs.getString(7),
		                    rs.getString(8),
		                    rs.getString(9),
		                    rs.getString(10),
		                    rs.getString(11),
		                    rs.getString(12),
		                    rs.getInt(13)
		            );
		            evalList.add(evalDto);
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        try { if (conn != null) conn.close(); } catch (Exception e ) { e.printStackTrace(); }
		        try { if (pstmt != null) pstmt.close(); } catch (Exception e ) { e.printStackTrace(); }
		        try { if (rs != null) rs.close(); } catch (Exception e ) { e.printStackTrace(); }
		    }
		    
		    return evalList;
		}
		
// 강의평가 추천
		public int like(String evaluationID) {

			String SQL = "UPDATE evaluation SET likeCount = likeCount + 1 WHERE evaluationID = ?;";
			// 실행 시 해당 평가의 추천 1씩 증가시킴
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			
			try {
				conn = DatabaseUtil.getConnection();
				pstmt = conn.prepareStatement(SQL);
				pstmt.setInt(1, Integer.parseInt(evaluationID));
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
		public int delete(String evaluationID) {
			
			String SQL = "DELETE FROM evaluation WHERE evaluationID = ?";
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			
			try {
				conn = DatabaseUtil.getConnection();
				pstmt = conn.prepareStatement(SQL);
				pstmt.setInt(1, Integer.parseInt(evaluationID));
				return pstmt.executeUpdate();	//실행 결과를 반환함
			} catch(Exception e) {
				e.printStackTrace();
			} finally {
				try { if(conn != null) conn.close();} catch(Exception e ) {e.printStackTrace();}
				try { if(pstmt != null) pstmt.close();} catch(Exception e ) {e.printStackTrace();}
			}
			return -1;	//오류 발생
		}
		
// 강의평가 작성자의 아이디 가져오기
		public String getUserID(String evaluationID) {
			
			String SQL = "SELECT userID FROM evaluation WHERE evaluationID = ?;";
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				conn = DatabaseUtil.getConnection();
				pstmt = conn.prepareStatement(SQL);
				pstmt.setInt(1, Integer.parseInt(evaluationID));
				rs = pstmt.executeQuery();
				if(rs.next()) {
					return rs.getString(1);	// 이메일 인증이 완료된 사용자일 경우 true 반환 
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

		// 인기글 5개 불러오기
		public ArrayList<EvaluationDto> top5() {
		    ArrayList<EvaluationDto> evalList = null;
		    String SQL = "SELECT * FROM evaluation ORDER BY likeCount DESC LIMIT 5";
		    
		    Connection conn = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    
		    try {
		        conn = DatabaseUtil.getConnection();
		        pstmt = conn.prepareStatement(SQL);
		        rs = pstmt.executeQuery();
		        
		        evalList = new ArrayList<EvaluationDto>();
		        while (rs.next()) {
		        	EvaluationDto evalDto = new EvaluationDto(
		        			rs.getInt(1),
		                    rs.getString(2),
		                    rs.getString(3),
		                    rs.getString(4),
		                    rs.getInt(5),
		                    rs.getString(6),
		                    rs.getString(7),
		                    rs.getString(8),
		                    rs.getString(9),
		                    rs.getString(10),
		                    rs.getString(11),
		                    rs.getString(12),
		                    rs.getInt(13)
		            );
		            evalList.add(evalDto);
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        try { if (conn != null) conn.close(); } catch (Exception e ) { e.printStackTrace(); }
		        try { if (pstmt != null) pstmt.close(); } catch (Exception e ) { e.printStackTrace(); }
		        try { if (rs != null) rs.close(); } catch (Exception e ) { e.printStackTrace(); }
		    }
		    
		    return evalList;
		}
		
}
