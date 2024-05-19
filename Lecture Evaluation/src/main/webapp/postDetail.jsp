<%@page import="board.BoardDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDao"%>
<%@ page import="board.BoardDao"%>
<%@ page import="board.BoardDto"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.net.URLEncoder"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<title>이현대학교 대나무숲</title>
	<!-- 부트스트랩 css 추가하기 -->
	<link rel="stylesheet" href="./css/bootstrap.min.css">
	<!-- 커스텀 css 추가하기 -->
	<link rel="stylesheet" href="./css/custom.css">
	
</head>
<body>
<%
//검색했을 때 어떤 게시글을 검색했는지 판단할 수 있게~
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
		<a class="navbar-brand" href="index.jsp">이현대학교 대나무숲</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div id="navbar" class="collapse navbar-collapse">
			<ul class="navbar-nav mr-auto">
				<li class="nav-item active">
					<a class="nav-link" href="index.jsp">메인</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="./courseReview.jsp">강의평가</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="./board.jsp">자유게시판</a>
				</li>
				<li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown">
						회원관리
					</a>
					<div class="dropdown-menu" aria-labelledby="dropdown">
<!-- 사용자가 로그인한 상태가 아닐 경우 로그인/회원가입이 보이게-->
<%
	if(userID == null){
%>
						<a class="dropdown-item" href="userLogin.jsp">로그인</a>
						<a class="dropdown-item" href="userJoin.jsp">회원가입</a>
<%
	} else {
%> 	<!-- 로그인 했을 경우 로그아웃만 보이게 -->
						<a class="dropdown-item" style="color: green;"><b><%= userID %></b> 님 환영합니다.</a>
						<a class="dropdown-item" href="userLogoutAction.jsp">로그아웃</a>
<%
	}
%>						
					</div>
				</li>
			</ul>
		</div>
	</nav>
	<section class="container">
		<div class="card bg-light mt-3">
			<div class="card-header bg-light">
				<h5 class="card-title"><b>개똥이</b></h5>
				<p class="card-text">조회수: 0 | 작성일: 2024.05.05</p>
			</div>
			<div class="card-body">
				<h4 class="card-title"><b>제목</b></h4>
				<p class="card-text" style="text-align:justify; white-space:pre-wrap;">내용
				</p>
				<div class="row">
					<div class="col-12 text-right">
						<a style="color: black;" onclick="return confirm('추천하시겠습니까?')" href="#">추천(1)</a> | 
						<a style="color: gray;" onclick="return confirm('삭제하시겠습니까?')" href="#">삭제</a>
					</div>
				</div>
			</div>
		</div>
		<div class="card mt-2">
			<div class="card-header">comment</div>
			<div class="card-body">
				<form method="post" action="./replyRegisterAction.jsp">
					<input type="text" name="replyContent" class="form-control" maxlength="2048" style="height: 100px;">
					<div class="text-right">
						<button type="submit" class="btn btn-primary mt-1">작성</button>
					</div>
				</form>
			</div>
		</div>
		<div id="comments-area">
			<div class="card mb-5 mt-2">
				<div class="card-header">1개의 댓글</div>
				<div class="card-body">
				<ul class="list-group list-group-flush">
					<li class="list-group-item m-1">
						<h5><b>작성자</b></h5>
						<p>댓글내용댓글내용</p>
						<div class="text-right">
							<a style="color: gray;" onclick="return confirm('삭제하시겠습니까?')">삭제</a>
						</div>
					</li>
					<li class="list-group-item m-1">
						<h5><b>작성자</b></h5>
						<p>댓글내용댓글내용</p>
						<div class="text-right">
							<a style="color: gray;" onclick="return confirm('삭제하시겠습니까?')">삭제</a>
						</div>
					</li>
				</ul>
				</div>
			</div>
		</div>
	</section>	
	
	
<!-- footer -->
	<footer class="fixed-bottom bg-dark text-center mt-5" style="color: #FFFFFF;">
		Copyright &copy; 2024 EhyunSeok All Rights Reserved.
	</footer>
	

<!--  -->
	<!-- jquery js 추가하기 -->
	<script src="./js/jquery.min.js"></script>
	<!-- popper js 추가하기 -->
	<script src="./js/popper.min.js"></script>
	<!-- bootstrap js 추가하기 -->
	<script src="./js/bootstrap.min.js"></script>
</body>
</html>