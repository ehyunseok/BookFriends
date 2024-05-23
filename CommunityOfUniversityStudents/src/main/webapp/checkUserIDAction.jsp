<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDto"%>
<%@ page import="user.UserDao"%>
<%@ page import="java.io.PrintWriter"%>
<%
	request.setCharacterEncoding("UTF-8");
	String userID = request.getParameter("userID");
	if(userID.equals("") || userID == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('아이디를 입력해주세요.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
	
	UserDao userDao = new UserDao();
	boolean isTrue = userDao.checkDuplication(userID);
	if(isTrue == true){//중복된 아이디
		session.setAttribute("userID", userID);
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('아이디가 이미 사용중입니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else { //
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('사용 가능한 아이디입니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
%>