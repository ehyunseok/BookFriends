package evaluation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

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
				pstmt.setString(1, evalDto.userID);
				pstmt.setString(2, evalDto.lectureName);
				pstmt.setString(3, evalDto.professorName);
				pstmt.setInt(4, evalDto.lectureYear);
				pstmt.setString(5, evalDto.semesterDivide);
				pstmt.setString(6, evalDto.lectureDivide);
				pstmt.setString(7, evalDto.evaluationTitle);
				pstmt.setString(8, evalDto.evaluationContent);
				pstmt.setString(9, evalDto.totalScore);
				pstmt.setString(10, evalDto.usabilityScore);
				pstmt.setString(11, evalDto.skillScore);
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
	
}
