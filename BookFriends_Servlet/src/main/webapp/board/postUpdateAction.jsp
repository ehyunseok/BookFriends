<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.BoardDao"%>
<%@ page import="board.BoardDto"%>
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
		script.println("location.href='../user/userLogin.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
	int postID = 0;
	String postCategory = null;
	String postTitle = null;
	String postContent = null;
	
	if(request.getParameter("postID") != null){
		postID = Integer.parseInt( request.getParameter("postID") );
	}
	if(postID == 0){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('postID == null')");
		script.println("history.back();");
		script.println("</script>");
	}
	
	if(request.getParameter("postCategory") != null){
		postCategory = request.getParameter("postCategory");
	}
	if(request.getParameter("postTitle") != null){
		postTitle = request.getParameter("postTitle");
	}
	if(request.getParameter("postContent") != null){
		postContent = request.getParameter("postContent");
	}
	
	if(request.getParameter("postCategory") == null || request.getParameter("postTitle") == null || request.getParameter("postContent") == null 
			|| request.getParameter("postCategory").equals("") || request.getParameter("postTitle").equals("") || request.getParameter("postContent").equals("")){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('모든 항목을 입력하세요.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
	// 모든 항목을 다 입력했을 경우, 평가 게시글을 수정한다.
	BoardDao boardDao = new BoardDao();
	int result = boardDao.update(postID, postCategory, postTitle, postContent);
	
	String postIDStr = postID + "";
	
	if(result == -1){	// 수정 실패
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('게시글 수정 실패');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else {	// 등록 성공
		session.setAttribute("userID", userID);
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('게시글 수정 완료');");
		script.println("location.href='./postDetail.jsp?postID=" + URLEncoder.encode(postIDStr, "UTF-8") + "';");
		script.println("</script>");
		script.close();
		return;
	}
	
%>