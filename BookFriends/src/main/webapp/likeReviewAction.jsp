<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="review.ReviewDao"%>
<%@ page import="user.UserDao"%>
<%@ page import="likey.LikeyDao"%>
<%@ page import="java.io.PrintWriter"%>
<%!

// 현재 사용자의 IP 주소를 db에 저장
	public static String getClientIP(HttpServletRequest request){
		String ip = request.getHeader("X-FORWARDED-FOR");
		if(ip == null || ip.length() == 0){
			ip = request.getHeader("Proxy-Client-IP");
		}
		if(ip == null || ip.length() == 0){
			ip = request.getHeader("WL-Proxy-Client-IP");
		}
		if(ip == null || ip.length() == 0){
			ip = request.getRemoteAddr();
		}
		return ip;
	}
%>
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
	String reviewID = null;
	if(request.getParameter("reviewID") != null){
		reviewID = request.getParameter("reviewID");
	}
	
	ReviewDao reviewDao = new ReviewDao();
	
	LikeyDao likeyDao = new LikeyDao();
	//like함수 실행
	int result = likeyDao.likeReview(userID, reviewID, getClientIP(request));	
	
	if(result == 1){
		result = reviewDao.like(reviewID);
		if(result == 1){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('서평을 추천했습니다.');");
			script.println("history.back();");
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
		script.println("alert('이미 추천한 서평입니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
	
%>