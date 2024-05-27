<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="recruit.RecruitDao"%>
<%@ page import="recruit.RecruitDto"%>
<%@ page import="file.FileDao" %>
<%@ page import="file.FileDto" %>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.IOException" %>
<%@ page import="javax.servlet.ServletException" %>
<%@ page import="javax.servlet.http.HttpServlet" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="javax.servlet.http.Part"%>
<%@ page import="java.nio.file.Paths"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>독서 친구 - 모임 모집 작성</title>
</head>
<body>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
    
    // 글 정보를 받아서 recruit 테이블에 저장
    String userID = (String) session.getAttribute("userID");
    String recruitTitle = request.getParameter("recruitTitle");
    String recruitStatus = request.getParameter("recruitStatus");
    String recruitContent = request.getParameter("recruitContent");

    if(recruitTitle == null || recruitStatus == null || recruitContent == null ||
       recruitTitle.equals("") || recruitStatus.equals("") || recruitContent.equals("")){
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('모든 항목을 작성해주세요.');");
        script.println("history.back();");
        script.println("</script>");
        script.close();
    }
    
    RecruitDao recruitDao = new RecruitDao();
    Timestamp registDate = new Timestamp(new Date().getTime());
    RecruitDto recruitDto = new RecruitDto(0, userID, recruitStatus, recruitTitle, recruitContent, registDate, 0);
    int result = recruitDao.write(recruitDto);
    
    if(result > 0) {
        int recruitID = result; // 방금 작성한 recruitID 가져오기
        
        // 파일 업로드 처리
        String uploadPath = application.getRealPath("/") + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        DiskFileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);

        try {
            List<FileItem> formItems = upload.parseRequest(request);

            if (formItems != null && formItems.size() > 0) {
                for (FileItem item : formItems) {
                    if (!item.isFormField() && item.getSize() > 0) { // 파일이 존재하고 크기가 0이 아닌 경우 처리
                        String fileName = new File(item.getName()).getName();
                        String filePath = uploadPath + File.separator + fileName;
                        File storeFile = new File(filePath);
                        item.write(storeFile);
 
                        // 파일 정보를 DB에 저장
                        FileDao fileDao = new FileDao();
                        FileDto fileDto = new FileDto(fileName, item.getName(), filePath); // filePath 추가
                        fileDto.setRecruitID(recruitID); // recruitID를 설정
                        fileDto.setPostID(0); // postID는 0으로 설정
                        fileDao.saveFile(fileDto);
                    }
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('모집글 작성 완료');");
        script.println("location.href='recruit.jsp';");
        script.println("</script>");
        script.close();
    } else {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('모집글 작성 실패');");
        script.println("history.back();");
        script.println("</script>");
        script.close();
    }
%>
</body>
</html>
