<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="reply.ReplyDao"%>
<%@ page import="reply.ReplyDto"%>
<%@ page import="util.SHA256"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="recruit.RecruitDao"%>
<%@ page import="recruit.RecruitDto"%>
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
		script.println("location.href='../user/userLogin.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
	String replyIDStr = request.getParameter("replyID");
	String replyContent = request.getParameter("replyContent");
	
	if(replyIDStr == null || replyContent == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 입력')");
		script.println("history.back();");
		script.println("</script>");
	}
	
	//replyIDStr을 정수로 변환하여 replyID로 저장
	int replyID = Integer.parseInt(replyIDStr);
	
	String recruitID =  new ReplyDao().getRecruitID(replyIDStr);
	if(recruitID == null || recruitID.equals("")){
		PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('게시글 불러오기를 실패했습니다.');");
        script.println("history.back();");
        script.println("</script>");
        script.close();
        return;
	}
	int recruitIDInt = Integer.parseInt(recruitID);
	
	RecruitDto recruit = new RecruitDao().getPost(recruitIDInt);
	if (recruit == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('게시글을 불러올 수 없습니다.');");
        script.println("history.back();");
        script.println("</script>");
        script.close();
        return;
    }
	
	
	ReplyDao replyDao = new ReplyDao();
	int result = replyDao.update(replyID, replyContent);
	if(result == -1){	// 수정 실패
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('댓글 수정 실패');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else {	// 등록 성공
		session.setAttribute("userID", userID);
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('댓글 수정 완료');");
		script.println("location.href='./recruitDetail.jsp?recruitID=" + URLEncoder.encode(recruitID, "UTF-8") + "';");
		script.println("</script>");
		script.close();
		return;
	}
	
%>