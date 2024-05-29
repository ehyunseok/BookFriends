package file;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import util.DatabaseUtil;

public class FileDao {

	private Connection conn;
	
    public FileDao() {
        try {
            String dbURL = "jdbc:mysql://localhost:3306/lectureevaluation";
            String dbID = "root";
            String dbPassword = "mysql";
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("파일 업로드 db와 연결완료");
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
        } catch(Exception e) {
            e.printStackTrace();
        }
    }

    public void saveFile(FileDto fileDto) {
        String sql = "INSERT INTO file (fileName, fileOriginName, filePath, recruitID, postID) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, fileDto.getFileName());
            pstmt.setString(2, fileDto.getFileOriginName());
            pstmt.setString(3, fileDto.getFilePath());
            if (fileDto.getRecruitID() != null) {
                pstmt.setInt(4, fileDto.getRecruitID());
            } else {
                pstmt.setNull(4, java.sql.Types.INTEGER);
            }
            if (fileDto.getPostID() != null) {
                pstmt.setInt(5, fileDto.getPostID());
            } else {
                pstmt.setNull(5, java.sql.Types.INTEGER);
            }
            pstmt.executeUpdate();
            System.out.println("File saved successfully to DB.");
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error saving file to DB: " + e.getMessage());
        }
    }
}
