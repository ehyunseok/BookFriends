<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDao"%>
<%@ page import="board.BoardDao"%>
<%@ page import="board.BoardDto"%>
<%@ page import="review.ReviewDao"%>
<%@ page import="review.ReviewDto"%>
<%@ page import="evaluation.EvaluationDao"%>
<%@ page import="evaluation.EvaluationDto"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.net.URLEncoder"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<title>독서친구</title>
	<!-- 부트스트랩 css 추가하기 -->
	<link rel="stylesheet" href="./css/bootstrap.min.css">
	<!-- 커스텀 css 추가하기 -->
	<link rel="stylesheet" href="./css/custom.css">
	<style>
		.center-container {
			display: flex;
			justify-content: center;
			align-items: center;
			min-height: 20vh;
		}
		.card-wrapper {
			height: 50vh;
			width: 80vh;
		}
		.truncate-text {
		    white-space: nowrap;
		    overflow: hidden;
		    text-overflow: ellipsis;
		    max-width: 500px;
		}
	</style>
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
		script.println("location.href='userLogin.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
	
	// 이메일이 인증되지 않은 회원은 수강 평가를 할 수 없도록 기존 이메일 인증 페이지로 이동하게 함 
	boolean emailChecked = new UserDao().getUserEmailChecked(userID);
	if(emailChecked == false){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href='emailSendConfirm.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
%>

<!-- navigation -->
	<nav class="navbar navbar-expand-lg navbar-light bg-light">
		<a class="navbar-brand" href="index.jsp">독서친구</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div id="navbar" class="collapse navbar-collapse">
			<ul class="navbar-nav mr-auto">
				<li class="nav-item active">
					<a class="nav-link" href="index.jsp"><b>메인</b></a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="./bookReview.jsp">서평</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="./board.jsp">자유게시판</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="./recruit.jsp">독서모임</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="./market.jsp">중고장터</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="./chat.jsp">채팅</a>
				</li>
				<li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown">
						회원관리
					</a>
					<div class="dropdown-menu" aria-labelledby="dropdown">
						<a class="dropdown-item" style="color: green;"><b><%= userID %></b> 님 환영합니다.</a>
						<a class="dropdown-item" href="userLogoutAction.jsp">로그아웃</a>
					</div>
				</li>
			</ul>
		</div>
	</nav>
	
	<section class="container">
		<div class="center-container">
			<div class="row row-cols-1 row-cols-md-2 mt-5">
				<!-- 서평 인기글 -->
				<div class="col card-wrapper">
					<div class="card">
						<div class="card-header text-center">
							<a  href="bookReview.jsp" style="color: black;">
								<h5 class="card-title"><b>서평</b></h5>
							</a>
								<p class="card-text">추천수 top5</p>
						</div>
						<ul class="list-group list-group-flush">
						<%
							ArrayList<ReviewDto> reviewDto = new ArrayList<>();
							reviewDto = new ReviewDao().top5();
							for(int i = 0 ; i < 5; i++){
								ReviewDto review = reviewDto.get(i);
						%>
							<li class="list-group-item" onclick="window.location='./reviewDetail.jsp?reviewID=<%= review.getReviewID() %>'">
									[<%= review.getBookName() %> <small><%= review.getAuthorName() %></small>] 
								<div class="truncate-text">
									<b><%= review.getReviewTitle() %></b>  <small style="font-size:xx-small;">추천:<%= review.getLikeCount() %></small> 
								</div>
									<small><img class="" src="images/icon.png" style="height:12px;"><%= review.getUserID() %></small>
							</li>
						<% 
							}
						%>
						</ul>
					</div>
				</div>
				<!-- 자유게시판 인기글 -->
				<div class="col card-wrapper">
					<div class="card">
						<div class="card-header text-center">
							<a href="board.jsp" style="color: black;">
								<h5 class="card-title"><b>자유게시판</b></h5>
							</a>
								<p class="card-text">인기글 top5</p>
						</div>
						<ul class="list-group list-group-flush">
						<%
							ArrayList<BoardDto> boardList = new ArrayList<BoardDto>();
							boardList = new BoardDao().top5();
							for(int i = 0 ; i < 5; i++){
								BoardDto board = boardList.get(i);
						%>
							<li class="list-group-item" onclick="window.location='./postDetail.jsp?postID=<%= board.getPostID() %>'">
								[<%= board.getPostCategory() %>] 
								<div class="truncate-text">
									<b><%= board.getPostTitle() %></b>  <small style="font-size:xx-small;">추천:<%= board.getLikeCount() %></small>
								</div>
								<div class="sidebyside">
									<small><img class="" src="images/icon.png" style="height:15px;"> <%= board.getUserID() %></small>
								</div>
							</li>
						<% 
							}
						%>
						</ul>
				</div>
			</div>
		</div>
	</div>
	</section>
	
<!-- footer -->
	<footer class="fixed-bottom bg-dark text-center mt-5" style="color: #FFFFFF;">
		Copyright &copy; 2024 EhyunSeok All Rights Reserved.
	</footer>
	

<!-- js추가 -->
	<!-- jquery js 추가하기 -->
	<script src="./js/jquery.min.js"></script>
	<!-- popper js 추가하기 -->
	<script src="./js/popper.min.js"></script>
	<!-- bootstrap js 추가하기 -->
	<script src="./js/bootstrap.min.js"></script>
	<!-- custom.js 추가하기 -->
	<script src="./js/custom.js"></script>
</body>
</html>