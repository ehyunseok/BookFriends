package recruit;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
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

@WebServlet(name = "CombinedServlet", urlPatterns = {"/recruitWriteAction", "/file-handler"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 5,       // 5 MB
    maxRequestSize = 1024 * 1024 * 10    // 10 MB
)
public class CombinedServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final String uploadDir = Paths.get("C:", "Users", "daney", "DEVFolder", "ProjectsWorkSpace", ".metadata", ".plugins", "org.eclipse.wst.server.core", "tmp1", "wtpwebapps", "BookFriends", "upload").toString();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain; charset=UTF-8");

        System.out.println("Received POST request at /file-handler");  // 디버그 로그 추가

        Part imagePart = request.getPart("image");
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

            response.getWriter().write(saveFilename);
            return;
        }

        System.out.println("Received POST request at /recruitWriteAction");

        String userID = (String) request.getSession().getAttribute("userID");
        if (userID == null) {
            response.sendRedirect("userLogin.jsp");
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

        RecruitDto latestRecruit = recruitDao.getPostAfterResist(userID);

        if (latestRecruit == null) {
            response.sendRedirect("error.jsp");
            return;
        }

        String uploadPath = getServletContext().getRealPath("/uploads");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        Part filePart = request.getPart("file");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String timeStamp = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
            String newFileName = timeStamp + "_" + fileName;

            String filePath = uploadPath + File.separator + newFileName;

            filePart.write(filePath);

            String fileUrl = request.getContextPath() + "/uploads/" + newFileName;

            FileDto fileDto = new FileDto();
            fileDto.setFileName(newFileName);
            fileDto.setFileOriginName(fileName);
            fileDto.setFilePath(fileUrl);
            fileDto.setRecruitID(latestRecruit.getRecruitID());
            fileDto.setPostID(null);

            FileDao fileDao = new FileDao();
            try {
                fileDao.saveFile(fileDto);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect("recruit.jsp");
        System.out.println("Received POST request at /recruitWriteAction");  // 디버그 로그 추가
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        System.out.println("Received GET request at /file-handler");

        String filename = request.getParameter("filename");
        if (filename == null || filename.isEmpty()) {
            response.getWriter().write("Filename is required");
            return;
        }

        String fileFullPath = Paths.get(uploadDir, filename).toString();
        File file = new File(fileFullPath);
        if (!file.exists()) {
            response.getWriter().write("File not found");
            return;
        }

        try (FileInputStream fis = new FileInputStream(file);
             OutputStream os = response.getOutputStream()) {

            String mimeType = getServletContext().getMimeType(file.getAbsolutePath());
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
