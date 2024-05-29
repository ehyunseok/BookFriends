<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDao"%>
<%@ page import="board.BoardDao"%>
<%@ page import="board.BoardDto"%>
<%@ page import="reply.ReplyDto"%>
<%@ page import="reply.ReplyDao"%>
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
	
	// 해당 게시글 아이디 가져오기
	String postID =  request.getParameter("postID");
	
	if(postID == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('postID가 null값입니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
	BoardDao boardDao = new BoardDao();
	BoardDto board = new BoardDao().getPost(postID);
    if (board == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('게시글을 불러올 수 없습니다.');");
        script.println("history.back();");
        script.println("</script>");
        script.close();
        return;
    }
	// 댓글 리스트 가져오기
	ArrayList<ReplyDto> replyList = new ReplyDao().getList(postID);
	
	// 댓글 개수 가져오기
	int countReply = replyList.size();
    
%>

<!-- navigation -->
	<nav class="navbar navbar-expand-lg navbar-light bg-light">
		<a class="navbar-brand" href="index.jsp">독서친구</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div id="navbar" class="collapse navbar-collapse">
			<ul class="navbar-nav mr-auto">
				<li class="nav-item">
					<a class="nav-link" href="index.jsp">메인</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="./bookReview.jsp">서평</a>
				</li>
				<li class="nav-item active">
					<a class="nav-link" href="./board.jsp"><b>자유게시판</b></a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="./recruit.jsp">독서모임</a>
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
	
<!-- 컨테이너 -->
	<section class="container">
		<div>
			<div class="card bg-light mt-3">
				<div class="card-header bg-light">
					<h5 class="card-title"><img src="images/icon.png" style="height:20px;"> <b><%= board.getUserID() %></b></h5>
					<p class="card-text">조회수: <%= board.getViewCount() %> | 작성일: <%= board.getPostDate() %></p>
				</div>
				<div class="card-body">
					<h4 class="card-title"><b><%= board.getPostTitle() %></b></h4>
					<p class="card-text" style="text-align:justify; white-space:pre-wrap;"><%= board.getPostContent() %>
					</p>
					<div class="row">
						<div class="col-12 text-right">
							<a style="color: black;" onclick="return confirm('추천하시겠습니까?')" href="./likePostAction.jsp?postID=<%= board.getPostID() %>">추천(<%= board.getLikeCount() %>)</a>
<%
// 사용자가 작성자와 동일한 경우 수정, 삭제버튼 노출
		if(userID.equals(board.getUserID())){
%>
							 
							 | <a style="color: gray;" onclick="return confirm('수정하시겠습니까?')" data-toggle="modal" href="#updateModal">수정</a> | 
							<a style="color: gray;" onclick="return confirm('삭제하시겠습니까?')" href="./deletePostAction.jsp?postID=<%= board.getPostID() %>">삭제</a>
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
				<form method="post" action="./replyRegisterAction.jsp">
					<input type="hidden" name="postID" value="<%= postID %>">
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
							<h5><img class="" src="images/icon.png" style="height:20px;"> <b><%= replyDto.getUserID() %></b></h5>
							<small><%= replyDto.getReplyDate() %></small>
							<p style="text-align:justify; white-space:pre-wrap; padding-top:10px; font-size:large;"><%= replyDto.getReplyContent() %></p>
							<div class="text-right">
							
								<a style="color: black;" onclick="return confirm('추천하시겠습니까?')" href="./likeReplyAction.jsp?replyID=<%= replyDto.getReplyID() %>">추천(<%= replyDto.getLikeCount() %>)</a>
<%
		if(userID.equals(replyDto.getUserID())){
%>								 		
								 | <a style="color: gray;" onclick="return confirm('수정하시겠습니까?')" data-toggle="modal" href="#updateReplyModal<%= replyDto.getReplyID() %>">수정</a> | 
								<a style="color: gray;" onclick="return confirm('삭제하시겠습니까?')" href="./deleteReplyAction.jsp?replyID=<%= replyDto.getReplyID() %>">삭제</a>
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
									<form method="post" action="./updateReplyAction.jsp?replyID=<%= replyDto.getReplyID() %>">
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
	
	
		
<!-- 게시글 수정하기 모달  -->
	<div class="modal fade" id="updateModal" tabindex="-1" role="dialog" aria-labelledby="modal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">게시글 수정</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form method="post" action="./postUpdateAction.jsp?postID=<%= postID %>">
						<div class="form-row">
							<div class="form-group col-sm-4">
								<label>카테고리</label>
								<select name="postCategory" class="form-control">
									<option value="질문">질문</option>
									<option value="맛집 추천">맛집 추천</option>
									<option value="사담">사담</option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label>제목</label>
							<input type="text" name="postTitle" class="form-control" maxlength="30" value="<%= board.getPostTitle() %>">
						</div>
						<div class="form-group">
							<label>내용</label>
							<textarea name="postContent" class="form-control" maxlength="2048" style="height: 180px;" ><%= board.getPostContent() %></textarea>
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