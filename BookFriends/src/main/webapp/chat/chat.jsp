<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDao"%>
<%@ page import="user.UserDto"%>
<%@ page import="chat.ChatDao"%>
<%@ page import="chat.ChatDto"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>독서친구</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="../css/bootstrap.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="../css/custom.css">
    <link rel="stylesheet" href="../css/chat.css">
    <!-- Font Awesome -->
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" />
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Bootstrap JS -->
    <script src="../js/bootstrap.min.js"></script>
</head>
<body>

<%
    request.setCharacterEncoding("UTF-8");

    // 로그인 상태 관리
    String userID = null;
    if (session.getAttribute("userID") != null) { // 로그인한 상태라서 세션에 userID가 존재할 경우
        userID = (String) session.getAttribute("userID"); // userID에 해당 세션의 값을 저장함
    }
    if (userID == null) { // 로그인 상태가 아닌 경우에는 로그인 페이지로 이동
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
    if (emailChecked == false) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("location.href='../user/emailSendConfirm.jsp'");
        script.println("</script>");
        script.close();
        return;
    }

%>
<%
	if(userID != null){
%>
<script type="text/javascript">
$(document).ready(function(){
	getInfiniteUnread();
});

</script>
<%
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
                <a class="nav-link" href="../recruit/recruit.jsp">독서모임</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="../market/market.jsp">중고장터</a>
            </li>
            <li class="nav-item active">
                <a class="nav-link" href="./chat.jsp"><b>채팅</b></a>
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

<!-- container  -->
<section class="container">
    <div class="ml-auto text-right">
        <a class="btn btn-danger mx-1 mt-2" data-toggle="modal" href="#reportModal">신고</a>
    </div>
    <div class="row clearfix mt-1">
        <div class="col-lg-12">
            <div class="card chat-app">
                <!-- 사용자가 채팅했던 이용자 리스트 -->
                <div id="plist" class="people-list">
                    
                    <!-- 읽지 않은 메시지 알림 -->
                    <ul class="list-unstyled chat-list mt-2 mb-0" id="peopleList">
                        <li class="clearfix">
                            <img src="../images/icon.png" alt="avatar">
                            <div class="about">
                                <div class="name">userID</div>
                                <div class="status">
                                	<i class="fa fa-circle online"></i>online
                                </div>
                            </div>
                        </li>
                    </ul>
                    <ul class="list-unstyled chat-list mt-2 mb-0" id="peopleList">
                        <li class="clearfix">
                            <div class="about">
                            	<div class="card mt-5 text-center" style="width:200px;">
									  <div class="card-header">
									    New Message
									  </div>
									  <div class="card-body">
									    <h5 class="card-title">새로운 메시지</h5>
									    <p class="card-text"><span id="unread" class="badge badge-info">1</span></p>
									  </div>
								</div>
                            </div>
                        </li>
                    </ul>
                </div>
                <!-- 채팅창 -->
                <div class="chat">
                    <div class="chat-header clearfix">
                        <div class="row">
                            <div class="col-lg-6">
                                <a href="javascript:void(0);" data-toggle="modal" data-target="#view_info">
                                    <img src="../images/icon.png" alt="avatar">
                                </a>
                                <div class="chat-about">
                                    <h6 class="m-b-0">석이현</h6>
                                    <small>Last seen: 2 hours ago</small>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="chat-history">
                    	<ul class="m-b-0" id="chatList">
                    	</ul>
                    </div>
                    <div class="chat-message clearfix fixed">
                        <div class="input-group mb-0">
                            <div class="input-group-prepend">
                                <span class="input-group-text" id="sendsvg"></span>
                                <div class="clearfix"></div>
                            </div>
                            <textarea id="message" class="form-control" placeholder="메시지를 입력하세요..." maxlength="300" style="resize: none; overflow: auto;"></textarea>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
function getUnread() {
	$.ajax({
		type:"POST",
		url:  '<%= request.getContextPath() %>/chatUnread',
		data: {
			userID: encodeURIComponent('<%= userID %>'),
		},
		success: function(result){
			if(result>=1){
				showUnread(result);
			} else{
				showUnread('');
			}
		}
	});
}
function getInfiniteUnread(){
	setInterval(function(){
		getUnread();
	}, 4000);
}
function showUnread(result){
	$('#unread').html(result);
}


</script>

<!-- 신고하기 모달 -->
<div class="modal fade" id="reportModal" tabindex="-1" role="dialog" aria-labelledby="modal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modal">신고하기</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form action="../reportAction.jsp" method="post">
                    <div class="form-group">
                        <label>신고 제목</label>
                        <input type="text" name="reportTitle" class="form-control" maxlength="30">
                    </div>
                    <div class="form-group">
                        <label>신고 내용</label>
                        <textarea name="reportContent" class="form-control" maxlength="2048" style="height: 180px;"></textarea>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                        <button type="submit" class="btn btn-danger">신고하기</button>
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

</body>
</html>
