<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="review.ReviewDao"%>
<%@ page import="review.ReviewDto"%>
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
	
	String bookName = request.getParameter("bookName");	
	String authorName = request.getParameter("authorName");	
	String publisher = request.getParameter("publisher");	
	String category = request.getParameter("category");
	String reviewTitle = request.getParameter("reviewTitle");
	String reviewContent = request.getParameter("reviewContent");	
	String reviewScoreStr = request.getParameter("reviewScore");
	int reviewScore = Integer.parseInt(reviewScoreStr);
	
	if(reviewScoreStr == null || reviewScoreStr.equals("")  ||
			authorName == null || authorName.equals("") 	||
			bookName == null || bookName.equals("") 		||
			category == null || category.equals("") 		||
			category == "선택" || category.equals("선택") 		||
			reviewTitle == null || reviewTitle.equals("")	||
			reviewContent == null || reviewContent.equals("")||
			reviewScore == 99
			){
		if(reviewScoreStr == null || reviewScoreStr.equals("")){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('평점을 선택하세요.');");
			script.println("history.back();");
			script.println("</script>");
			script.close();
			return;
		}
		if(authorName == null || authorName.equals("")){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('저자명을 입력하세요.');");
			script.println("history.back();");
			script.println("</script>");
			script.close();
			return;
		}
		
		if(bookName == null || bookName.equals("")){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('서명을 입력하세요.');");
			script.println("history.back();");
			script.println("</script>");
			script.close();
			return;
		}
		
		if(category == null || category.equals("")||
				category == "선택" || category.equals("선택")
				){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('카테고리를 선택하세요.');");
			script.println("history.back();");
			script.println("</script>");
			script.close();
			return;
		}
		if(reviewTitle == null || reviewTitle.equals("")){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('제목을 입력하세요.');");
			script.println("history.back();");
			script.println("</script>");
			script.close();
			return;
		}
		if(reviewContent == null || reviewContent.equals("")){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('내용을 입력하세요.');");
			script.println("history.back();");
			script.println("</script>");
			script.close();
			return;
		}
		if(reviewScore == 99){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('평점을 선택하세요.');");
			script.println("history.back();");
			script.println("</script>");
			script.close();
			return;
		}
	}
	
// 모든 항목을 다 입력했을 경우, 게시글 등록
	ReviewDao reviewDao = new ReviewDao();
	Timestamp currentTimestamp = new Timestamp(System.currentTimeMillis());
	int result = reviewDao.write(new ReviewDto(0, userID, bookName, authorName, publisher, category, reviewTitle, reviewContent, reviewScore, currentTimestamp, 0, 0));
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
		ReviewDto reviewDto = new ReviewDao().getReviewAfterRegist(userID);
		if (reviewDto == null) {
		    script.println("<script>");
		    script.println("alert('리뷰를 찾을 수 없습니다.');");
		    script.println("history.back();");
		    script.println("</script>");
		} else {
		    String reviewID = reviewDto.getReviewID() + "";
		    script.println("<script>");
		    script.println("alert('서평 등록 완료');");
		    script.println("location.href='./reviewDetail.jsp?reviewID=" + URLEncoder.encode(reviewID, "UTF-8") + "';");
		    script.println("</script>");
		}
		return;
	}
	
%>