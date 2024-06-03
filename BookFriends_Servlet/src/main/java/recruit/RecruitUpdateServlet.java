package recruit;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
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

@WebServlet(name = "RecruitUpdateServlet", urlPatterns = {"/recruitUpdate"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 5,       // 5 MB
    maxRequestSize = 1024 * 1024 * 10    // 10 MB
)
public class RecruitUpdateServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final String uploadDir = Paths.get("C:", "BookFriends", "uploads").toString();

    @Override
    public void init() throws ServletException {
        File uploadDir = new File(getServletContext().getRealPath("/") + this.uploadDir);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
    }
    
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String recruitID = request.getParameter("recruitID");
        if (recruitID == null) {
            response.sendRedirect("recruit.jsp");
            return;
        }

        RecruitDao recruitDao = new RecruitDao();
        RecruitDto recruit = recruitDao.getPost(recruitID);
        if (recruit == null) {
            response.sendRedirect("error.jsp");
            return;
        }

        request.setAttribute("recruit", recruit);
        request.getRequestDispatcher("/recruitUpdate.jsp").forward(request, response);
    }
    

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain; charset=UTF-8");

        System.out.println("Received POST request at /recruitUpdate");  // 디버그 로그

        String userID = (String) request.getSession().getAttribute("userID");
        if (userID == null) {
            response.sendRedirect("userLogin.jsp");
            return;
        }

        int recruitID = Integer.parseInt(request.getParameter("recruitID"));
        String recruitTitle = request.getParameter("recruitTitle");
        String recruitContent = request.getParameter("recruitContent");
        String recruitStatus = request.getParameter("recruitStatus");

        RecruitDto recruitDto = new RecruitDto();
        recruitDto.setRecruitID(recruitID);
        recruitDto.setUserID(userID);
        recruitDto.setRecruitTitle(recruitTitle);
        recruitDto.setRecruitContent(recruitContent);
        recruitDto.setRecruitStatus(recruitStatus);

        RecruitDao recruitDao = new RecruitDao();
        int result = recruitDao.update(recruitDto);

        if (result == -1) {
            response.sendRedirect("error.jsp");
            return;
        }

        Part imagePart = request.getPart("uploadFile");
        if (imagePart != null && imagePart.getSize() > 0) {
            String orgFilename = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
            String uuid = UUID.randomUUID().toString().replaceAll("-", "");
            String extension = orgFilename.substring(orgFilename.lastIndexOf(".") + 1);
            String saveFilename = uuid + "." + extension;
            String fileFullPath = Paths.get(uploadDir, saveFilename).toString();

            File dir = new File(uploadDir);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            File uploadFile = new File(fileFullPath);
            imagePart.write(uploadFile.getAbsolutePath());

            System.out.println("File uploaded successfully: " + saveFilename);
            System.out.println("File saved to: " + fileFullPath);

            // DB에 파일 메타데이터 저장
            FileDto fileDto = new FileDto();
            fileDto.setFileName(saveFilename);
            fileDto.setFileOriginName(orgFilename);
            fileDto.setFilePath(uploadDir);
            fileDto.setRecruitID(recruitID);
            fileDto.setPostID(null);  // postID가 필요한 경우 수정

            FileDao fileDao = new FileDao();
            fileDao.saveFile(fileDto);

            response.getWriter().write("{\"fileName\": \"" + saveFilename + "\", \"uploadPath\": \"" + request.getContextPath() + "/uploads" + "\"}");
        }

        String recruitIDStr = Integer.toString(recruitID);
        response.sendRedirect("recruit/recruitDetail.jsp?recruitID=" + recruitIDStr);
    }
}
