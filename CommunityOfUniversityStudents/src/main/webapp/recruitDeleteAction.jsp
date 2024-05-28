<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="recruit.RecruitDao"%>
<%@ page import="user.UserDao"%>
<%@ page import="java.io.PrintWriter"%>
<%
	UserDao userDao = new UserDao();
	String userID = null;
	if(session.getAttribute("userID") == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href = 'userLogin.jsp'");
		script.println("</script>");
		script.close();
		return;
	} else {
		userID = (String)session.getAttribute("userID");
	}

	
	// 요청을 UTF-8 인코딩처리하여 받는다.
	request.setCharacterEncoding("UTF-8");
	
	// 해당 게시글 아이디 가져오기
	String recruitID = null;
	if(request.getParameter("recruitID") != null){
		recruitID = request.getParameter("recruitID");
	}
	
	RecruitDao recruit = new RecruitDao();
	
	if(userID.equals(recruit.getUserID(recruitID))){			// 작성자와 현재 사용자의 아이디가 일치할 경우에만 삭제 가능	
		int result = new RecruitDao().deletePost(recruitID);
		if(result == 1){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('모집글이 삭제되었습니다.');");
			script.println("location.href='recruit.jsp'");
			script.println("</script>");
			script.close();
			return;
		} else {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('오류가 발생했습니다.');");
			script.println("history.back();");
			script.println("</script>");
			script.close();
			return;
		}
	} else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('삭제 권한이 없습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
%>