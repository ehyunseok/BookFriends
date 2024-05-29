<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDao"%>
<%@ page import="java.io.PrintWriter"%>
<%
	UserDao userDao = new UserDao();
	String userID = null;
	if(session.getAttribute("userID") == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href = '../user/userLogin.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
%>
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
				<li class="nav-item">
					<a class="nav-link" href="../review/bookReview.jsp">서평</a>
				</li>			
				<li class="nav-item">
					<a class="nav-link" href="../board/board.jsp">자유게시판</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="../recruit/recruit.jsp">독서모임</a>
				</li>			
				<li class="nav-item">
					<a class="nav-link" href="../market/market.jsp">중고장터</a>
				</li>			
				<li class="nav-item active">
					<a class="nav-link" href="./chat.jsp"><b>채팅</b></a>
				</li>			
				<li class="nav-item dropdown active">
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
	
<!-- container  -->
	<section class="container m-auto text-center" style="max-width: 560px">
		<div class="alert alert-dark mt-5" role="alert">
			⚠️
			<br>페이지를 준비중입니다.
			<br><a class="alert-link" href="../index.jsp">메인 페이지로 이동</a>
		</div>
	</section>
	
	
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
