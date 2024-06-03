<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDto"%>
<%@ page import="user.UserDao"%>
<%@ page import="util.SHA256"%>
<%@ page import="java.io.PrintWriter"%>
<%
	request.setCharacterEncoding("UTF-8");
	String userID = null;
	String userPassword = null;
	if(request.getParameter("userID") != null){
		userID = request.getParameter("userID");
	}
	if(request.getParameter("userPassword") != null){
		userPassword = request.getParameter("userPassword");
	}
	if(userID == null || userPassword == null || userID.equals("")|| userPassword.equals("")){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력되지 않은 항목이 있습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
	
	UserDao userDao = new UserDao();
	int result = userDao.login(userID, SHA256.getSHA256(userPassword));
	if(result == 1){//로그인 성공
		session.setAttribute("userID", userID); 	// 세션값 설정
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href='../index.jsp'");
		script.println("</script>");
		script.close();
		return;
	} else if(result == 0) {//비밀번호 틀림
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('비밀번호가 틀렸습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else if(result == -1) {//존재하지 않는 아이디
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('존재하지 않는 아이디입니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else if(result == -2) {//DB 오류
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('DB 오류 발생');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
%>