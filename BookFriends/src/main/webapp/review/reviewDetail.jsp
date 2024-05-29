<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDao"%>
<%@ page import="review.ReviewDao"%>
<%@ page import="review.ReviewDto"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.net.URLEncoder"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<title>독서친구</title>
	<!-- 부트스트랩 css 추가하기 -->
	<link rel="stylesheet" href="../css/bootstrap.min.css">
	<!-- 커스텀 css 추가하기 -->
	<link rel="stylesheet" href="../css/custom.css">
	
</head>
<body>
<%
	request.setCharacterEncoding("UTF-8");		
	
// 로그인 상태 관리
	String userID = null;
	if(session.getAttribute("userID") != null){		// 로그인한 상태라서 세션에 userID가 존재할 경우
		userID = (String)session.getAttribute("userID");	// userID에 해당 세션의 값을 저장함
	}
	if(userID == null){		// 로그인 상태가 아닌 경우에는 로그인 페이지로 이동
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href='../user/userLogin.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
	
	// 이메일이 인증되지 않은 회원은 수강 평가를 할 수 없도록 기존 이메일 인증 페이지로 이동하게 함 
	boolean emailChecked = new UserDao().getUserEmailChecked(userID);
	if(emailChecked == false){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href='../user/emailSendConfirm.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
	
	// 해당 서평 아이디 가져오기
	String reviewID =  request.getParameter("reviewID");
	
	if(reviewID == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('reviewID is null.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
	ReviewDao reviewDao = new ReviewDao();
	ReviewDto review = new ReviewDao().getReview(reviewID);
    if (review == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('게시글을 불러올 수 없습니다.');");
        script.println("history.back();");
        script.println("</script>");
        script.close();
        return;
    }

%>

<!-- navigation -->
	<nav class="navbar navbar-expand-lg navbar-light bg-light">
		<a class="navbar-brand" href="../index.jsp">독서친구</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div id="navbar" class="collapse navbar-collapse">
			<ul class="navbar-nav mr-auto">
				<li class="nav-item">
					<a class="nav-link" href="../index.jsp">메인</a>
				</li>
				<li class="nav-item active">
					<a class="nav-link" href="../review/bookReview.jsp"><b>서평</b></a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="../board/board.jsp">자유게시판</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="../recruit/recruit.jsp">독서모임</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="../marcket/market.jsp">중고장터</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="../chat/chat.jsp">채팅</a>
				</li>				
				<li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown">
						회원관리
					</a>
					<div class="dropdown-menu" aria-labelledby="dropdown">
						<a class="dropdown-item" style="color: green;"><b><%= userID %></b> 님 환영합니다.</a>
						<a class="dropdown-item" href="../user/userLogoutAction.jsp">로그아웃</a>
					</div>
				</li>
			</ul>
		</div>
	</nav>
	
<!-- 컨테이너 -->
	<section class="container mb-5">
		<div class="card bg-light mt-3">
			<div class="card-header bg-light">
				<h5 class="card-title"><img class="" src="../images/icon.png" style="height:20px;"> <b><%= review.getUserID() %></b></h5>
				<p class="card-text">조회수: <%= review.getViewCount() %> | 작성일: <%= review.getRegistDate() %></p>
			</div>
			<div class="card-body">
				<h4 class="card-title"><b><%= review.getReviewTitle() %></b></h4>
				<div class="row ml-1">
					<img src="../images/book-icon.png" style="height:20px;"><h5> <%= review.getBookName() %><small> [저자: <%= review.getAuthorName() %> <% if(!review.getPublisher().equals("")){ %> | 출판사: <%= review.getPublisher() %><% }%>]</small></h5>
				</div>
				<div class="card-text mt-1 mb-1 ml-1 mr-1 p-1" style="background: white;">
					<p class="card-text m-3" style="text-align:justify; white-space:pre-wrap;"><%= review.getReviewContent() %></p>
					<div class="col-12 text-right mb-3">
					<% switch(review.getReviewScore()){
					    	case 5:
					  %>
					    ⭐⭐⭐⭐⭐ 5점
					  <% 	break; 
				    		case 4:
					  %>
					    ⭐⭐⭐⭐ 4점
					  <% 	break; 
				    		case 3:
					  %>
					    ⭐⭐⭐ 3점
					  <% 	break; 
				    		case 2:
					  %>
					    ⭐⭐ 2점　
					  <% 	break; 
				    		case 1:
					  %>
					    ⭐ 1점
					  <% 	break; 
				    		case 0:
					  %>
					    👎 0점
					  <% 	break;
					   	} %>
					</div>
				</div>
				<div class="row">
					<div class="col-12 text-right">
						<a style="color: black;" onclick="return confirm('추천하시겠습니까?')" href="./likeReviewAction.jsp?reviewID=<%= review.getReviewID() %>">추천(<%= review.getLikeCount() %>)</a>
						 <%
// 사용자가 작성자와 동일한 경우 수정, 삭제버튼 노출
		if(userID.equals(review.getUserID())){
%>
							 
							 | <a style="color: gray;" onclick="return confirm('수정하시겠습니까?')" data-toggle="modal" href="#updateModal">수정</a> | 
							<a style="color: gray;" onclick="return confirm('삭제하시겠습니까?')" href="./reviewDeleteAction.jsp?reviewID=<%= review.getReviewID() %>">삭제</a>
						</div>
<%
		} else {
%>
						</div>
<%
		}
%>
				</div>
			</div>
		</div>

	</section>
		
<!-- 게시글 수정하기 모달  -->
	<div class="modal fade" id="updateModal" tabindex="-1" role="dialog" aria-labelledby="modal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">서평 수정</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form method="post" action="./reviewUpdateAction.jsp?reviewID=<%= reviewID %>">
						<div class="form-row">
							<div class="form-group col-sm-3">
								<label>카테고리</label>
								<select name="category" class="form-control">
									<option value="선택">선택</option>
									<option value="문학" <% if(review.getCategory().equals("문학")) out.println("selected"); %>>문학</option>
									<option value="사회" <% if(review.getCategory().equals("사회")) out.println("selected"); %>>사회</option>
									<option value="과학" <% if(review.getCategory().equals("과학")) out.println("selected"); %>>과학</option>
									<option value="예술" <% if(review.getCategory().equals("예술")) out.println("selected"); %>>예술</option>
									<option value="역사" <% if(review.getCategory().equals("역사")) out.println("selected"); %>>역사</option>
									<option value="언어(어학)" <% if(review.getCategory().equals("언어(어학)")) out.println("selected"); %>>언어(어학)</option>
									<option value="기타" <% if(review.getCategory().equals("기타")) out.println("selected"); %>>기타</option>
								</select>
							</div>
						</div>
						<div class="form-row">
							<div class="form-group col-sm-12">
								<label>서명</label>
								<input type="text" name="bookName" class="form-control" maxlength="30" value="<%= review.getBookName() %>">
							</div>
						</div>
						<div class="form-row">
							<div class="form-group col-sm-4">
								<label>저자</label>
								<input type="text" name="authorName" class="form-control" maxlength="20" value="<%= review.getAuthorName() %>">
							</div>
							<div class="form-group col-sm-4">
								<label>출판사</label>
								<input type="text" name="publisher" class="form-control" maxlength="20" value="<%= review.getPublisher() %>">
							</div>
							<div class="form-group col-sm-4">
								<label>평점</label>
								<select name="reviewScore" class="form-control">
									<option value="99">선택</option>
									<option value="5" <% if(review.getReviewScore() == 5) out.println("selected"); %>>★★★★★</option>
									<option value="4" <% if(review.getReviewScore() == 4) out.println("selected"); %>>★★★★</option>
									<option value="3" <% if(review.getReviewScore() == 3) out.println("selected"); %>>★★★</option>
									<option value="2" <% if(review.getReviewScore() == 2) out.println("selected"); %>>★★</option>
									<option value="1" <% if(review.getReviewScore() == 1) out.println("selected"); %>>★</option>
									<option value="0" <% if(review.getReviewScore() == 0) out.println("selected"); %>>☆</option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label>제목</label>
							<input type="text" name="reviewTitle" class="form-control" maxlength="30" value="<%= review.getReviewTitle() %>">
						</div>
						<div class="form-group">
							<label>내용</label>
							<textarea name="reviewContent" class="form-control" maxlength="2048" style="height: 180px;"><%= review.getReviewContent() %>"</textarea>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
							<button type="submit" class="btn btn-primary">등록</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
		
<!-- footer -->
	<footer class="fixed-bottom bg-dark text-center mt-5" style="color: #FFFFFF;">
		Copyright &copy; 2024 EhyunSeok All Rights Reserved.
	</footer>
	

<!--  -->
	<!-- jquery js 추가하기 -->
	<script src="../js/jquery.min.js"></script>
	<!-- popper js 추가하기 -->
	<script src="../js/popper.min.js"></script>
	<!-- bootstrap js 추가하기 -->
	<script src="../js/bootstrap.min.js"></script>
</body>
</html>