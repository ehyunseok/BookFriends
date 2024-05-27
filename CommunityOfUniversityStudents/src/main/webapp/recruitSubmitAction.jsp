<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDao"%>
<%@ page import="recruit.RecruitDao"%>
<%@ page import="recruit.RecruitDto"%>
<%@ page import="file.FileDao"%>
<%@ page import="file.FileDto"%>
<%@ page import="java.sql.Timestamp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>모집글 작성</title>
</head>
<body>
<%
    request.setCharacterEncoding("UTF-8");
    String userID = (String) session.getAttribute("userID");
    String recruitTitle = request.getParameter("recruitTitle");
    String recruitContent = request.getParameter("recruitContent");
    String recruitStatus = request.getParameter("recruitStatus");

    if (userID == null || recruitTitle == null || recruitContent == null || recruitStatus == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('모든 내용을 입력해주세요.');");
        script.println("history.back();");
        script.println("</script>");
        script.close();
        return;
    }

    RecruitDao recruitDao = new RecruitDao();
    RecruitDto recruitDto = new RecruitDto();
    recruitDto.setRecruitTitle(recruitTitle);
    recruitDto.setRecruitContent(recruitContent);
    recruitDto.setRecruitStatus(recruitStatus);
    recruitDto.setUserID(userID);
    recruitDto.setRegistDate(new Timestamp(System.currentTimeMillis()));

    int recruitID = recruitDao.write(recruitDto);

    if (recruitID > 0) {
        FileDao fileDao = new FileDao();
        String fileName = request.getParameter("fileName");
        String fileOriginName = request.getParameter("fileOriginName");
        String filePath = request.getParameter("filePath");

        if (fileName != null && fileOriginName != null && filePath != null) {
            FileDto fileDto = new FileDto(fileName, fileOriginName, filePath);
            fileDto.setRecruitID(recruitID);
            fileDto.setPostID(0); // postID는 0으로 설정
            fileDao.saveFile(fileDto);
        }

        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('모집글이 작성되었습니다.');");
        script.println("location.href='recruit.jsp';");
        script.println("</script>");
        script.close();
    } else {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('모집글 작성에 실패했습니다.');");
        script.println("history.back();");
        script.println("</script>");
        script.close();
    }
%>
</body>
</html>
