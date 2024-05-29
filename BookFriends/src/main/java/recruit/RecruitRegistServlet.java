package recruit;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import file.FileDao;
import file.FileDto;

@WebServlet(name = "RecruitRegistServlet", urlPatterns = {"/recruitWrite", "/display"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 5,       // 5 MB
    maxRequestSize = 1024 * 1024 * 10    // 10 MB
)
public class RecruitRegistServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final String uploadDir = Paths.get("C:", "BookFriends", "uploads").toString();
    
 // 업로드 디렉토리가 존재하지 않으면 생성
    @Override
    public void init() throws ServletException {
        File uploadDir = new File(getServletContext().getRealPath("/") + this.uploadDir);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain; charset=UTF-8");

        System.out.println("Received POST request at /recruitWrite");

        try {
            Part imagePart = request.getPart("uploadFile");
            if (imagePart != null && imagePart.getSize() > 0) {
                String orgFilename = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                String uuid = UUID.randomUUID().toString().replaceAll("-", "");
                String extension = orgFilename.substring(orgFilename.lastIndexOf(".") + 1);
                String saveFilename = uuid + "." + extension;
                String fileFullPath = Paths.get(uploadDir, saveFilename).toString();

                File uploadFile = new File(fileFullPath);
                Files.createDirectories(uploadFile.getParentFile().toPath());
                imagePart.write(uploadFile.getAbsolutePath());

                System.out.println("File uploaded successfully: " + saveFilename);
                System.out.println("File saved to: " + fileFullPath);

                FileDto fileDto = new FileDto();
                fileDto.setFileName(saveFilename);
                fileDto.setFileOriginName(orgFilename);
                fileDto.setFilePath(uploadDir);
                FileDao fileDao = new FileDao();
                fileDao.saveFile(fileDto);

                response.getWriter().write("{\"fileName\": \"" + saveFilename + "\", \"uploadPath\": \"" + request.getContextPath() + "/uploads" + "\"}");
                return;
            }
        } catch (ServletException | IOException e) {
            System.out.println("Image file part is not present or there was an error processing the file: " + e.getMessage());
        }

        // 이 부분은 이미지가 없어도 실행됩니다.
        String userID = (String) request.getSession().getAttribute("userID");
        if (userID == null) {
            response.sendRedirect("../user/userLogin.jsp");
            return;
        }

        String recruitTitle = request.getParameter("recruitTitle");
        String recruitContent = request.getParameter("recruitContent");
        String recruitStatus = "모집중";
        Timestamp registDate = new Timestamp(System.currentTimeMillis());

        RecruitDto recruitDto = new RecruitDto();
        recruitDto.setUserID(userID);
        recruitDto.setRecruitTitle(recruitTitle);
        recruitDto.setRecruitContent(recruitContent);
        recruitDto.setRecruitStatus(recruitStatus);
        recruitDto.setRegistDate(registDate);

        RecruitDao recruitDao = new RecruitDao();
        int result = recruitDao.write(recruitDto);

        if (result == -1) {
            response.sendRedirect("error.jsp");
            return;
        }

        // 최근 등록된 모집 게시글 정보를 가져와서 리다이렉트
        String recruitID = Integer.toString((recruitDao.getPostAfterResist(userID)).getRecruitID());
        response.sendRedirect("recruit/recruitDetail.jsp?recruitID=" + recruitID);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        System.out.println("Received GET request at /display");

        String filename = request.getParameter("fileName");
        if (filename == null || filename.isEmpty()) {
            response.getWriter().write("Filename is required");
            return;
        }

        File file = new File(uploadDir, filename);
        if (!file.exists()) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("File not found");
            return;
        }

        try (FileInputStream fis = new FileInputStream(file);
             OutputStream os = response.getOutputStream()) {

            String mimeType = Files.probeContentType(file.toPath());
            if (mimeType == null) {
                mimeType = "application/octet-stream";
            }

            response.setContentType(mimeType);
            response.setContentLengthLong(file.length());

            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                os.write(buffer, 0, bytesRead);
            }
        }
    }
}
