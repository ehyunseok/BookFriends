<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDao"%>
<%@ page import="util.SHA256"%>
<%@ page import="java.io.PrintWriter"%>
<%
	request.setCharacterEncoding("UTF-8");
	String code = null;
	if(request.getParameter("code") != null){
		code = request.getParameter("code");
	}
	
	UserDao userDao = new UserDao();
	String userID = null;
	if(session.getAttribute("userID") != null){
		userID = (String)session.getAttribute("userID");
	}
	if(userID == null || userID.equals("")){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href='../user/userLogin.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
	
	// 사용자의 이메일 받기
	String userEmail = userDao.getUserEmail(userID);
	
	// 현재 사용자가 보낸 코드가 해당 사용자의 이메일 해시값과 일치하는지 확인하기
	boolean isRight = ( new SHA256().getSHA256(userEmail).equals(code) ) ? true : false;
	if(isRight  == true){
		userDao.setUserEmailChecked(userID);		// 인증 완료시 userEmailChecked를 true로 번경
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('인증이 완료되었습니다.');");
		script.println("location.href='../index.jsp'");
		script.println("</script>");
		script.close();
		return;
		
	} else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 코드입니다.');");
		script.println("location.href='../index.jsp'");
		script.println("</script>");
		script.close();
		return;
	}

%>