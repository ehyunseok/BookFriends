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
	
	int reviewID = 0;
	
	if(request.getParameter("reviewID") != null){
		reviewID = Integer.parseInt(request.getParameter("reviewID") );
	}
	if(reviewID == 0){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('reviewID가 null입니다.')");
		script.println("history.back();");
		script.println("</script>");
	}
	
	String bookName = request.getParameter("bookName");	
	String authorName = request.getParameter("authorName");	
	String publisher = request.getParameter("publisher");	
	String category = request.getParameter("category");
	String reviewTitle = request.getParameter("reviewTitle");
	String reviewContent = request.getParameter("reviewContent");	
	String reviewScoreStr = request.getParameter("reviewScore");
	int reviewScore = 0;
	
	try {
        reviewScore = Integer.parseInt(reviewScoreStr);
    } catch (NumberFormatException e) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('평점을 선택세요.');");
        script.println("history.back();");
        script.println("</script>");
        script.close();
        return;
    }

    if (authorName == null || authorName.equals("") ||
        bookName == null || bookName.equals("") ||
        category == null || category.equals("") || category.equals("선택") ||
        reviewTitle == null || reviewTitle.equals("") ||
        reviewContent == null || reviewContent.equals("") ||
        reviewScore < 0 || reviewScore > 5) {

        PrintWriter script = response.getWriter();
        if (authorName == null || authorName.equals("")) {
            script.println("<script>");
            script.println("alert('저자명을 입력하세요.');");
        } else if (bookName == null || bookName.equals("")) {
            script.println("<script>");
            script.println("alert('서명을 입력하세요.');");
        } else if (category == null || category.equals("") || category.equals("선택")) {
            script.println("<script>");
            script.println("alert('카테고리를 선택하세요.');");
        } else if (reviewTitle == null || reviewTitle.equals("")) {
            script.println("<script>");
            script.println("alert('제목을 입력하세요.');");
        } else if (reviewContent == null || reviewContent.equals("")) {
            script.println("<script>");
            script.println("alert('내용을 입력하세요.');");
        } else if (reviewScore < 1 || reviewScore > 5) {
            script.println("<script>");
            script.println("alert('평점을 선택하세요.');");
        }
        script.println("history.back();");
        script.println("</script>");
        script.close();
        return;
    }

    ReviewDao reviewDao = new ReviewDao();
    int result = reviewDao.update(reviewID, category, bookName, authorName, publisher,
            						reviewTitle, reviewContent, reviewScore);

    String reviewIDStr = Integer.toString(reviewID);
	
	if(result == -1){	// 수정 실패
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('서평 수정 실패');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else {	// 수정 성공
		session.setAttribute("userID", userID);
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('서평 수정 완료');");
		script.println("location.href='./reviewDetail.jsp?reviewID=" + URLEncoder.encode(reviewIDStr, "UTF-8") + "';");
		script.println("</script>");
		script.close();
		return;
	}
	
%>