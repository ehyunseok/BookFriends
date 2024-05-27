package file;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.nio.file.Paths;

@WebServlet("/uploadImage")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 5,       // 5 MB
    maxRequestSize = 1024 * 1024 * 10    // 10 MB
)
public class FileUploadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String uploadPath = getServletContext().getRealPath("/") + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            Part filePart = request.getPart("file");
            String fileUrl = "";
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String timeStamp = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
                String newFileName = timeStamp + "_" + fileName;

                String filePath = uploadPath + File.separator + newFileName;
                filePart.write(filePath);

                fileUrl = request.getContextPath() + "/uploads/" + newFileName;
            }

            // JSON 형식으로 응답하기
            if (filePart == null || filePart.getSize() == 0) {
            response.getWriter().write("{\"imageUrl\": \"\", \"message\": \"No file uploaded\"}");
            return;
            }
        } catch (Exception e) {
            response.getWriter().write("{\"error\": \"Error: " + e.getMessage() + "\"}");
        }
    }
}
