<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDao"%>
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
				<li class="nav-item">
					<a class="nav-link" href="../review/bookReview.jsp">서평</a>
				</li>				
				<li class="nav-item">
					<a class="nav-link" href="../board/board.jsp">자유게시판</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="../market/market.jsp">중고장터</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="../chat/chat.jsp">채팅</a>
				</li>
				<li class="nav-item dropdown active">
					<a class="nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown">
						<b>회원관리</b>
					</a>
					<div class="dropdown-menu" aria-labelledby="dropdown">
						<a class="dropdown-item" style="color: green;"><b><%= userID %></b> 님 환영합니다.</a>
						<a class="dropdown-item" href="userLogoutAction.jsp">로그아웃</a>
					</div>
				</li>
			</ul>
		</div>
	</nav>
	
<!-- container  -->
	<section class="container mt-5 text-center" style="max-width: 560px">
		<div class="alert alert-warning mt-5" role="alert">
			⚠️
			<br>이메일 인증이 완료되어야 이용할 수 있습니다. 
			<br>인증 메일을 받지 못 하셨나요?
		</div>
		<a href="emailSendAction.jsp" class="btn btn-primary btn-block">인증 메일 다시 받기</a>
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