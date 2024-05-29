<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDao"%>
<%@ page import="recruit.RecruitDao"%>
<%@ page import="recruit.RecruitDto"%>
<%@ page import="reply.ReplyDto"%>
<%@ page import="reply.ReplyDao"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.net.URLEncoder"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<!-- csp 보안
	`default-src 'self'` 기본 출처는 자신의 도메인만 허용
	`script-src 'self'` 스크립트는 현재 자신의 도메인만 허용
	`style-src` 스타일 허용
	`font-src` 폰트 허용
	`img-src` 이미지 허용  -->
	<meta http-equiv="Content-Security-Policy" content="default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com; img-src 'self' data:;">
	<title>독서친구</title>
	<!-- 부트스트랩 css 추가하기 -->
	<link rel="stylesheet" href="../css/bootstrap.min.css">
	<!-- 커스텀 css 추가하기 -->
	<link rel="stylesheet" href="../css/custom.css">
	
</head>
<body>
<!-- showdown 라이브러리 추가 -->
<script src="https://cdn.jsdelivr.net/npm/showdown@1.9.1/dist/showdown.min.js"></script>

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
	
	// 해당 게시글 아이디 가져오기
	String recruitID =  request.getParameter("recruitID");
	
	if(recruitID == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('recruitID가 null값입니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	System.out.println("recruitID= "+ recruitID);
	
	RecruitDao recruitDao = new RecruitDao();
	RecruitDto recruit = new RecruitDao().getPost(recruitID);
	System.out.println("recruit= "+ recruit);
    if (recruit == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('모집글을 불러올 수 없습니다.');");
        script.println("history.back();");
        script.println("</script>");
        script.close();
        return;
    }
    
	// 댓글 리스트 가져오기
	ArrayList<ReplyDto> replyList = new ReplyDao().getListForRecruit(recruitID);
	
	// 댓글 개수 가져오기
	int countReply = replyList.size();
    
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
					<a class="nav-link" href="../board//board.jsp">자유게시판</a>
				</li>
				<li class="nav-item active">
					<a class="nav-link" href="../recruit/recruit.jsp"><b>독서모임</b></a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="../market/market.jsp">중고장터</a>
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
	<section class="container">
		<div>
			<div class="card bg-light mt-3">
				<div class="card-header bg-light">
					<h5 class="card-title"><img class="" src="../images/icon.png" style="height:20px;"> <b><%= recruit.getUserID() %></b></h5>
					<p class="card-text">조회수: <%= recruit.getViewCount() %> | 작성일: <%= recruit.getRegistDate() %></p>
				</div>
				<div class="card-body">
					<div class="row">
						<div>
						<% if(recruit.getRecruitStatus().equals("모집중")){ %>
					    	<span class="badge badge-success">모집중</span>
					    <% } else{ %>
					    	<span class="badge badge-secondary">모집완료</span>
					    <% } %>
					    </div>
						<h4 class="card-title"><b><%= recruit.getRecruitTitle() %></b></h4>
					</div>
					<div id="markdownContent" style="text-align:justify; white-space:pre-wrap;"><%= recruit.getRecruitContent() %></div>
					
					<div class="row">
						<div class="col-12 text-right">
<%
// 사용자가 작성자와 동일한 경우 수정, 삭제버튼 노출
		if(userID.equals(recruit.getUserID())){
%>
							 
							<a style="color: gray;" onclick="return confirm('수정하시겠습니까?')" href="<%= request.getContextPath() %>\recruit/recruitUpdate.jsp?recruitID=<%= recruit.getRecruitID() %>">수정</a> | 
							<a style="color: gray;" onclick="return confirm('삭제하시겠습니까?')" href="./recruitDeleteAction.jsp?recruitID=<%= recruit.getRecruitID() %>">삭제</a>
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
		</div>
			
			
			
<!-- 댓글 작성 -->
		<div class="card mt-3">
			<div class="card-header">comment</div>
			<div class="card-body">
				<form method="post" action="./recruitReplyRegisterAction.jsp">
					<input type="hidden" name="recruitID" value="<%= recruitID %>">
					<textarea name="replyContent" class="form-control" maxlength="2048" style="height: 100px;"></textarea>
					<div class="text-right">
						<button type="submit" class="btn btn-primary mt-1">작성</button>
					</div>
				</form>
			</div>
		</div>
		
<!-- 댓글 리스트 -->		
		<div id="comments-area">
			<div class="card mb-5 mt-2">
				<div class="card-header"><b><%= countReply %></b>개의 댓글</div>
				<div class="card-body">
					<ul class="list-group list-group-flush">
<%	
	for(ReplyDto replyDto : replyList){
%>		
						<li class="list-group-item m-1">
							<h5><img class="" src="../images/icon.png" style="height:20px;"> <b><%= replyDto.getUserID() %></b></h5>
							<small><%= replyDto.getReplyDate() %></small>
							<p style="text-align:justify; white-space:pre-wrap; padding-top:10px; font-size:large;"><%= replyDto.getReplyContent() %></p>
							<div class="text-right">
<%
		if(userID.equals(replyDto.getUserID())){
%>								 		
								<a style="color: gray;" onclick="return confirm('수정하시겠습니까?')" data-toggle="modal" href="#updateReplyModal<%= replyDto.getReplyID() %>">수정</a> | 
								<a style="color: gray;" onclick="return confirm('삭제하시겠습니까?')" href="../deleteReplyAction.jsp?replyID=<%= replyDto.getReplyID() %>">삭제</a>
<%
		}
%>							
							</div>
						</li>
<!-- 댓글 수정하기 모달 -->
					<div class="modal fade" id="updateReplyModal<%= replyDto.getReplyID() %>" tabindex="-1" role="dialog" aria-labelledby="modal">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<h5 class="modal-title" id="modal">댓글 수정</h5>
									<button type="button" class="close" data-dismiss="modal" aria-label="Close">
										<span aria-hidden="true">&times;</span>
									</button>
								</div>
								<div class="modal-body">
									<form method="post" action="./recruitReplyUpdateAction.jsp?replyID=<%= replyDto.getReplyID() %>">
										<div class="form-row">
											<textarea name="replyContent" class="form-control" maxlength="2048" style="height: 180px;"><%= replyDto.getReplyContent() %></textarea>
										</div>
										<div class="modal-footer">
											<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
											<button type="submit" class="btn btn-primary">수정</button>
										</div>
									</form>
								</div>
							</div>
						</div>
					</div>
<%
	}
%>						
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
	<script src="../js/jquery.min.js"></script>
	<!-- popper js 추가하기 -->
	<script src="../js/popper.min.js"></script>
	<!-- bootstrap js 추가하기 -->
	<script src="../js/bootstrap.min.js"></script>
	<!-- 마크다운 -->
	<script>
    window.onload = function() {
        // Showdown Converter 생성
        var converter = new showdown.Converter(),
            text      = `<%= recruit.getRecruitContent() %>`, // JSP에서 마크다운 데이터 가져오기
            html      = converter.makeHtml(text); // 마크다운을 HTML로 변환

        // 변환된 HTML을 페이지에 삽입
        document.getElementById('markdownContent').innerHTML = html;
    };
</script>
</body>
</html>