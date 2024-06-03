<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.mail.Transport"%>
<%@ page import="javax.mail.Message"%>
<%@ page import="javax.mail.Address"%>
<%@ page import="javax.mail.internet.MimeMessage"%>
<%@ page import="javax.mail.internet.InternetAddress"%>
<%@ page import="javax.mail.Authenticator"%>
<%@ page import="javax.mail.Session"%>
<%@ page import="java.util.Properties"%>
<%@ page import="user.UserDao"%>
<%@ page import="util.SHA256"%>
<%@ page import="util.Gmail"%>
<%@ page import="java.io.PrintWriter"%>
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
	}

	boolean emailChecked = userDao.getUserEmailChecked(userID);
	if(emailChecked == true){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 인증된 회원입니다.');");
		script.println("location.href = '../index.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
	
	String host = "http://localhost:8080/BookFriends/";
	String from = "yhdaneys@gmail.com";
	
	userID=(String)session.getAttribute("userID");
	if(userID == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('아이디가 입력되지 않았습니다.');");
		script.println("location.href = '../index.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
	String to = userDao.getUserEmail(userID);
	
	String subject = "회원가입 인증을 위한 이메일 인증 메일입니다.";
	String content = "다음 링크에 접속하여 이메일 인증을 진행해주세요." +
		"<a href='" + host + "./user/emailCheckAction.jsp?code=" + new SHA256().getSHA256(to) + "'>인증하기</a>";
		
	Properties p = new Properties();
	p.put("mail.smtp.user", from);
	p.put("mail.smtp.host", "smtp.gmail.com");
	p.put("mail.smtp.port", "465");
	p.put("mail.smtp.ssl.protocols", "TLSv1.2");
	p.put("mail.smtp.starttls.enable", "true");
	p.put("mail.smtp.auth", "true");
	p.put("mail.smtp.debug", "true");
	p.put("mail.smtp.socketFactory.port", "465");
	p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
	p.put("mail.smtp.socketFactory.fallback", "false");
	
	try {
		Authenticator auth = new Gmail();
		Session ses = Session.getInstance(p, auth);
		ses.setDebug(true);
		MimeMessage msg = new MimeMessage(ses);
		msg.setSubject(subject);
		Address fromAddr = new InternetAddress(from);
		msg.setFrom(fromAddr);
		if(to != null && !to.isEmpty()){
			Address toAddr = new InternetAddress(to);
			msg.addRecipient(Message.RecipientType.TO, toAddr);
			System.out.println(to);
		} else {
			System.out.println("오류: 수신자 이메일 주소를 입력해주세요.");
		}
		msg.setContent(content, "text/html;charset=UTF-8");
		Transport.send(msg);
		
	} catch(Exception e){
		e.printStackTrace();
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('오류가 발생했습니다.');");
		script.println("history.back();");
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
				<li class="nav-item active">
					<a class="nav-link" href="../index.jsp">메인</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="../review/bookReview.jsp">서평</a>
				</li>			
				<li class="nav-item">
					<a class="nav-link" href="../board/board.jsp"><b>자유게시판</b></a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="../recruit/recruit.jsp">독서모임</a>
				</li>			
				<li class="nav-item">
					<a class="nav-link" href="../market/market.jsp">중고장터</a>
				</li>			
				<li class="nav-item">
					<a class="nav-link" href="../chat/chat.jsp">채팅</a>
				</li>			
				<li class="nav-item dropdown active">
					<a class="nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown">
						회원관리
					</a>
					<div class="dropdown-menu" aria-labelledby="dropdown">
						<a class="dropdown-item" href="userLogin.jsp">로그인</a>
						<a class="dropdown-item" href="userJoin.jsp">회원가입</a>
					</div>
				</li>
			</ul>
		</div>
	</nav>
	
<!-- container  -->
	<section class="container mt-5 text-center" style="max-width: 560px">
		<div class="alert alert-success mt-5" role="alert">
			⚠️
			<br>이메일 인증 메일이 전송되었습니다. 
			<br>회원가입 시 입력했던 이메일 계정에서 인증해주세요.
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
