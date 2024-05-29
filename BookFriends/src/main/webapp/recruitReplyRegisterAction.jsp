<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="recruit.RecruitDao"%>
<%@ page import="recruit.RecruitDto"%>
<%@ page import="reply.ReplyDao"%>
<%@ page import="reply.ReplyDto"%>
<%@ page import="util.SHA256"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.net.URLEncoder"%>
<%
	request.setCharacterEncoding("UTF-8");

	String userID = null;
	if(session.getAttribute("userID") != null){		// 로그인한 상태라서 세션에 userID가 존재할 경우
		userID = (String)session.getAttribute("userID");	// userID에 해당 세션의 값을 저장함
	}
	if(userID == null){		// 로그인 상태가 아닌 경우에는 로그인 화면으로 이동
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href='userLogin.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
	
    String recruitIDParam = request.getParameter("recruitID");
    String replyContent = request.getParameter("replyContent");

    if (recruitIDParam == null || recruitIDParam.isEmpty()) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('유효하지 않은 recruitID입니다.');");
        script.println("history.back();");
        script.println("</script>");
        script.close();
        return;
    }

    int recruitID = Integer.parseInt(recruitIDParam);
    if (replyContent == null || replyContent.trim().isEmpty()) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('내용을 입력하세요.');");
        script.println("history.back();");
        script.println("</script>");
        script.close();
        return;
    }

		
	RecruitDao recruitDao = new RecruitDao();
	RecruitDto recruit = recruitDao.getPost(recruitID);
	if(recruit == null){
		PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('유효하지 않은 recruitID입니다.');");
        script.println("history.back();");
        script.println("</script>");
        script.close();
        return;
	}
	
	// 내용을 입력하면 댓글이 등록됨
	ReplyDao replyDao = new ReplyDao();
	Timestamp currentTimestamp = new Timestamp(System.currentTimeMillis());
	int result = replyDao.writeForRecruit(new ReplyDto(0, userID, 0, replyContent, 0, currentTimestamp, recruitID));
	if(result == -1){	// 등록 실패
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('댓글 등록 실패');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else {	// 등록 성공
		session.setAttribute("userID", userID);
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('댓글이 등록되었습니다.');");
		script.println("location.href='./recruitDetail.jsp?recruitID=" + URLEncoder.encode(recruitIDParam, "UTF-8") + "';");
		script.println("</script>");
		script.close();
		return;
	}
	
%>