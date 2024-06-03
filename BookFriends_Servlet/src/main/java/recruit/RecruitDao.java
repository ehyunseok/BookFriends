package recruit;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import org.apache.commons.text.StringEscapeUtils;
import util.DatabaseUtil;

public class RecruitDao {

//사용자가 모집글을 작성할 수 있는 함수
	public int write(RecruitDto recruitDto) {
		
		String SQL = "INSERT INTO recruit VALUES (NULL, ?, ?, ?, ?, ?, 0);";
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, recruitDto.userID);
			pstmt.setString(2, recruitDto.recruitStatus);
			pstmt.setString(3, recruitDto.recruitTitle);
			pstmt.setString(4, recruitDto.recruitContent);
			pstmt.setTimestamp(5, recruitDto.registDate);
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

// 모집글 리스트 불러오기(조회, 검색)
	public ArrayList<RecruitDto> getList(String recruitStatus, String searchType, String search, int pageNumber) {
        ArrayList<RecruitDto> list = new ArrayList<>();
        String SQL = "";
        if (recruitStatus.equals("전체")) {
        	recruitStatus = "";
        }

        // Sort by searchType
        String orderByClause = "";
        switch (searchType) {
            case "조회수순":
                orderByClause = " ORDER BY viewCount DESC";
                break;
            case "최신순":
            default:
                orderByClause = " ORDER BY registDate DESC";
                break;
        }

        SQL = "SELECT * FROM recruit WHERE recruitStatus LIKE ? AND CONCAT(userID, recruitTitle, recruitContent) LIKE ?" + orderByClause + " LIMIT ?, ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setString(1, "%" + recruitStatus + "%");
            pstmt.setString(2, "%" + search + "%");
            pstmt.setInt(3, pageNumber * 5);
            pstmt.setInt(4, 5);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                	RecruitDto recruitDto = new RecruitDto(
                        rs.getInt("recruitID"),
                        rs.getString("userID"),
                        rs.getString("recruitStatus"),
                        rs.getString("recruitTitle"),
                        rs.getString("recruitContent"),
                        rs.getTimestamp("registDate"),
                        rs.getInt("viewCount")
                    );
                    list.add(recruitDto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int getTotalPosts(String recruitStatus, String searchType, String search) {
        if (recruitStatus.equals("전체")) {
        	recruitStatus = "";
        }

        int totalPosts = 0;
        String SQL = "SELECT COUNT(*) FROM recruit WHERE recruitStatus LIKE ? AND CONCAT(userID, recruitTitle, recruitContent) LIKE ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setString(1, "%" + recruitStatus + "%");
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

		
// 모집글 작성자의 아이디 가져오기
	public String getUserID(String recruitID) {
		
		String SQL = "SELECT userID FROM recruit WHERE recruitID = ?;";
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, Integer.parseInt(recruitID));
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
	public RecruitDto getPost(String recruitID) {
		
		String updateSQL = "UPDATE recruit SET viewCount = viewCount + 1 WHERE recruitID = ?;"; 
		String selectSQL = "SELECT * FROM recruit WHERE recruitID = ?;";
		
		Connection conn = null;
		PreparedStatement upPstmt = null;
		PreparedStatement selPstmt = null;
		ResultSet rs = null;
		
		try {
			conn = DatabaseUtil.getConnection();
			
			upPstmt = conn.prepareStatement(updateSQL);
			upPstmt.setInt(1, Integer.parseInt(recruitID));
			upPstmt.executeUpdate();
			
			selPstmt = conn.prepareStatement(selectSQL);
			selPstmt.setInt(1, Integer.parseInt(recruitID));
			rs = selPstmt.executeQuery();
			if(rs.next()) {
				RecruitDto recruit = new RecruitDto(); 
				recruit.setRecruitID(rs.getInt(1));
				recruit.setUserID(rs.getString(2));
				recruit.setRecruitStatus(rs.getString(3));
				recruit.setRecruitTitle( rs.getString(4));
				recruit.setRecruitContent(rs.getString(5));
				recruit.setRegistDate(rs.getTimestamp(6));
				recruit.setViewCount(rs.getInt(7));
				return recruit;
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	

//모집글 삭제
	public int deletePost(String recruitID) {
		
		String SQL = "DELETE FROM recruit WHERE recruitID = ?;";
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, Integer.parseInt(recruitID));
			return pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try { if(conn != null) conn.close();} catch(Exception e ) {e.printStackTrace();}
			try { if(pstmt != null) pstmt.close();} catch(Exception e ) {e.printStackTrace();}
		}
		return -1;
	}
		
		
// 모집글 수정
	public int update(RecruitDto recruit) {

		String SQL = "UPDATE recruit SET recruitStatus = ?, recruitTitle = ?, recruitContent = ? WHERE recruitID = ?;";
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, recruit.getRecruitStatus());
			pstmt.setString(2, recruit.getRecruitTitle());
			pstmt.setString(3, recruit.getRecruitContent());
			pstmt.setInt(4, recruit.getRecruitID());
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
		
// 모집글 등록할 때 recruitID 정보 가져오기
	public RecruitDto getPost(int recruitID) {
	    String SQL = "SELECT * FROM recruit WHERE recruitID = ?";
	    
	    try (Connection conn = DatabaseUtil.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(SQL)) {
	         
	        pstmt.setInt(1, recruitID);
	        try (ResultSet rs = pstmt.executeQuery()) {
	            if (rs.next()) {
	            	RecruitDto recruit = new RecruitDto();
	            	recruit.setRecruitID(rs.getInt("recruitID"));
	            	recruit.setUserID(rs.getString("userID"));
	            	recruit.setRecruitStatus(rs.getString("recruitStatus"));
	            	recruit.setRecruitTitle(rs.getString("recruitTitle"));
	            	recruit.setRecruitContent(rs.getString("recruitContent"));
	            	recruit.setViewCount(rs.getInt("viewCount"));
	            	recruit.setRegistDate(rs.getTimestamp("registDate"));
	                return recruit;
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return null;
	}
		
// 방금 작성한 모집글 가져오기
	public RecruitDto getPostAfterResist(String userID) {
	    String selLPSQL = "SELECT MAX(recruitID) FROM recruit WHERE userID = ?;";
	    
	    String selectSQL = "SELECT * FROM recruit WHERE recruitID = ?;";
	    
	    try (Connection conn = DatabaseUtil.getConnection();
	            PreparedStatement slpPstmt = conn.prepareStatement(selLPSQL);){
	        
	        //1. 사용자가 가장 최신에 작성한 글의 아이디를 가져온다.
	        slpPstmt.setString(1, userID);
	        try(ResultSet rs = slpPstmt.executeQuery();){
	            int lastRecruitID = -1;
	            if(rs.next()) {
	                lastRecruitID = rs.getInt(1);
	            }
	            
	            if(lastRecruitID == -1) {
	                return null;    // 주어진 userID로 recruitID를 찾지 못함 
	            }
	            
	            //2. lastRecruitID로 게시글을 조회감
	            try(PreparedStatement selPstmt = conn.prepareStatement(selectSQL);){
	                selPstmt.setInt(1, lastRecruitID);
	                try(ResultSet rs2 = selPstmt.executeQuery();){
	                    if(rs2.next()) {
	                        RecruitDto recruit = new RecruitDto(); 
	                        recruit.setRecruitID(rs2.getInt(1));
	                        recruit.setUserID(rs2.getString(2));
	                        recruit.setRecruitStatus(rs2.getString(3));
	                        recruit.setRecruitTitle(rs2.getString(4));
	                        recruit.setRecruitContent(rs2.getString(5));
	                        recruit.setRegistDate(rs2.getTimestamp(6));
	                        recruit.setViewCount(rs2.getInt(7));
	                        return recruit;
	                    }
	                }
	            }
	        }
	    } catch(Exception e) {
	        e.printStackTrace();
	    }
	    return null;
	}
		

// 최신 모집글 5개 불러오기
	public ArrayList<RecruitDto> top5() {
	    ArrayList<RecruitDto> recruitList = null;
	    String SQL = "SELECT * FROM board ORDER BY regist DESC LIMIT 5";
	    
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    
	    try {
	        conn = DatabaseUtil.getConnection();
	        pstmt = conn.prepareStatement(SQL);
	        rs = pstmt.executeQuery();
	        
	        recruitList = new ArrayList<RecruitDto>();
	        while (rs.next()) {
	        	RecruitDto recruitDto = new RecruitDto(
	                    rs.getInt(1),
	                    rs.getString(2),
	                    rs.getString(3),
	                    rs.getString(4),
	                    rs.getString(5),
	                    rs.getTimestamp(6),
	                    rs.getInt(7)
	            );
	        	recruitList.add(recruitDto);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try { if (conn != null) conn.close(); } catch (Exception e ) { e.printStackTrace(); }
	        try { if (pstmt != null) pstmt.close(); } catch (Exception e ) { e.printStackTrace(); }
	        try { if (rs != null) rs.close(); } catch (Exception e ) { e.printStackTrace(); }
	    }
	    
	    return recruitList;
	}
		
}
