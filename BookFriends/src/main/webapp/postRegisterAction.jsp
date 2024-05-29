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
		script.println("location.href='userLogin.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
	
	String postCategory = null;
	String postTitle = null;
	String postContent = null;
	
	if(request.getParameter("postCategory") != null){
		postCategory = request.getParameter("postCategory");
	}
	if(request.getParameter("postTitle") != null){
		postTitle = request.getParameter("postTitle");
	}
	if(request.getParameter("postContent") != null){
		postContent = request.getParameter("postContent");
	}
	
	
	if(postCategory == null || postTitle == null || postContent == null 
			|| postCategory.equals("") || postTitle.equals("") || postContent.equals("")){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('모든 항목을 입력하세요.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
// 모든 항목을 다 입력했을 경우, 게시글 등록
	BoardDao boardDao = new BoardDao();
	Timestamp currentTimestamp = new Timestamp(System.currentTimeMillis());
	int result = boardDao.write(new BoardDto(0, userID, postCategory, postTitle, postContent, 0, 0, currentTimestamp));
	if(result == -1){	// 등록 실패
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('게시글 등록 실패');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else {	// 등록 성공
		session.setAttribute("userID", userID);
		PrintWriter script = response.getWriter();
		BoardDto boardDto = new BoardDao().getPostAfterResist(userID);
		String postID = boardDto.getPostID() + "";
		script.println("<script>");
		script.println("alert('게시글 등록 완료');");
		script.println("location.href='./postDetail.jsp?postID=" + URLEncoder.encode(postID, "UTF-8") + "';");
		script.println("</script>");
		script.close();
		return;
	}
	
%>