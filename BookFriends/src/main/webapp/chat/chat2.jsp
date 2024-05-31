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

    String receiverID = null;
    if (request.getParameter("receiverID") != null) {
        receiverID = (String) request.getParameter("receiverID");
    }
    System.out.println("receiverID=" + receiverID);

    if (receiverID == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('수신자가 지정되지 않았습니다.');");
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
                    <!-- 검색창 -->
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text" id="glass"></span>
                        </div>
                        <input type="text" class="form-control" placeholder="Search...">
                    </div>
                    <!-- 목록 -->
                    <ul class="list-unstyled chat-list mt-2 mb-0" id="peopleList">
                    <%
                    ChatDao chatDao = new ChatDao();
                    ArrayList<UserDto> chatFriends = chatDao.getChatFriends(userID);
                    request.setAttribute("chatFriends", chatFriends);
                    ChatDto chatDto = new ChatDto();
                    int num = 1;
                   	if(chatFriends != null){
                   		for(UserDto user : chatFriends){
                   			// 현재 페이지의 receiverID와 각 사용자의 userID를 비교
                            String activeClass = "";
                            if(receiverID != null && receiverID.equals(user.getUserID())) {
                                activeClass = " active"; // 일치하면 active 클래스를 추가
                            }
                    %>
                        <li class="clearfix<%= activeClass %>" data-url="./chat2.jsp?receiverID=<%= user.getUserID() %>">
                            <img src="../images/icon.png" alt="avatar">
                            <div class="about">
                                <div class="name"><%= user.getUserID() %></div>
                                <div class="status">
                                <% if(num%2 != 0) { %><i class="fa fa-circle online"></i>online
                                <% } else { %>
                                	<i class="fa fa-circle offline"></i>offline
                                <% } %>
                                </div>
                            </div>
                        </li>
                    <%
                    	num++;
                    		}
                   		} 
                	%>
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
                                    <h6 class="m-b-0"><%= receiverID %></h6>
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
	//페이지 이동
	$(document).ready(function() {
	    // 'li' 요소에 클릭 이벤트 핸들러를 추가합니다.
	    $("#peopleList").on("click", "li", function() {
	        var url = $(this).data("url"); // 'data-url' 속성에서 URL을 가져옵니다.
	        window.location.href = url; // 해당 URL로 페이지를 리다이렉트합니다.
	    });
	});

	//전송 버튼 누른 다음 액션
    $(document).ready(function() {
        $('#sendsvg').click(function() {
            var message = $('#message').val().trim(); //공백 제거
            if (message.length === 0) {
                $('#dangerModal').modal('show');
            } else {
                submitFunction();
            }
        });
     	// 엔터 키를 눌렀을 때 메시지 전송
        $('#message').keypress(function(event) {
            if (event.which === 13 && !event.shiftKey) { // 13은 엔터 키의 키 코드입니다. shiftKey가 같이 눌리지 않았는지 확인합니다.
                event.preventDefault(); // 엔터 키 기본 이벤트(새 줄 입력)를 방지합니다.
                var message = $('#message').val().trim();
                if (message.length > 0) { // 메시지가 비어 있지 않은 경우에만 전송합니다.
                    submitFunction();
                }
            }
        });
    });
    
    

    //모달 자동 닫기 함수
    function autoCloseModal(modalId) {
        $(modalId).modal('show');
        setTimeout(function() {
            $(modalId).modal('hide');
        }, 1000); // 1초 후에 모달 닫기
    }

    // 서버 응답에 따라 모달 표시를 처리하는 함수
    function handleServerResponse(result) {
        result = result.trim();
        switch (result) {
            case "1":
                autoCloseModal('#successModal');
                break;
            case "0":
                autoCloseModal('#dangerModal');
                break;
            default:
                autoCloseModal('#warningModal');
                break;
        }
    }

    // 메시지를 보내는 함수
    function submitFunction() {
        var senderID = '<%= userID %>';
        var receiverID = decodeURIComponent('<%= URLEncoder.encode(receiverID, "UTF-8") %>');
        var message = $('#message').val();
        $.ajax({
            type: "POST",
            url: "/BookFriends/chatSubmitServlet",
            data: {
                senderID: senderID,
                receiverID: receiverID,
                message: message
            },
            success: function(result) {
                console.log('Raw result from server: ' + result);
                result = result.trim(); // 공백과 제어 문자를 제거함
                handleServerResponse(result);
                if (result == "1") {
                    $('#message').val(''); // 메시지 제출 완료 후 작성란 비우기
                    $('#chatList').scrollTop($('#chatList')[0].scrollHeight); // 채팅 목록을 가장 최근 메시지로 스크롤
                }
            }
        });
    }

    function formatChatTime(timestamp) {
        var parts = timestamp.split(/[- :]/);
        var date = new Date(parts[0], parts[1] - 1, parts[2], parts[3], parts[4], parts[5]);
        var year = date.getFullYear().toString().slice(2); // 년도 뒤 두 자리
        var month = (date.getMonth() + 1).toString().padStart(2, '0'); // 월
        var day = date.getDate().toString().padStart(2, '0'); // 일
        var hours = date.getHours();
        var minutes = date.getMinutes().toString().padStart(2, '0');
        var ampm = hours >= 12 ? 'PM' : 'AM';
        hours = hours % 12;
        hours = hours ? hours : 12; // 0시는 12시로 변환
        return year + '.' + month + '.' + day + ' ' + hours + ':' + minutes + ' ' + ampm;
    }

    function addChat(senderID, message, chatTime) {
        var userID = '<%= userID %>';
        console.log("senderID = "+ senderID);
        var isSender = senderID === userID;
        var formattedChatTime = formatChatTime(chatTime);
        var messageClass = isSender ? 'my-message' : 'other-message';
        var alignClass = isSender ? ' align-left' : ' align-right';
        var infoClass = isSender ? 'info-left' : 'info-right';
        var avatarPlacement = isSender ? '' : '<div class="avatar"><img src="../images/icon.png" alt="avatar"></div>';
		var name = isSender? 'me' : senderID;
        var chatHtml =
            '<li class="clearfix ' + alignClass + '">' +
                '<div class="message-data ' + infoClass + '">' +
                    avatarPlacement +
                    '<div class="message-info">' +
                        '<span class="sender-id">' + name + '</span>' +
                        '<span class="time">' + formattedChatTime + '</span>' +
                    '</div>' +
                '</div>' +
                '<div class="message ' + messageClass + '">' + message + '</div>' +
            '</li>';
        $('#chatList').append(chatHtml);
        $('#chatList').scrollTop($('#chatList')[0].scrollHeight);
    }

    function chatListFunction(type) {
        var userID = '<%= userID %>';
        var receiverID = decodeURIComponent('<%= URLEncoder.encode(receiverID, "UTF-8") %>');
        $.ajax({
            type: "POST",
            url: "/BookFriends/chatListServlet",
            data: {
                senderID: userID,
                receiverID: receiverID,
                listType: type
            },
            success: function(data) {
                try {
                    if (data == "") return;
                    var parsed = JSON.parse(data);
                    var result = parsed.result;
                    for (var i = 0; i < result.length; i++) {
                        addChat(result[i][0].value, result[i][2].value, result[i][3].value);
                    }
                    lastID = Number(parsed.last);
                } catch (e) {
                    console.error("JSON 파싱 에러:", e);
                }
            },
            error: function(xhr, status, error) {
                console.error("Error 발생: " + status + ", " + error);
            }
        });
    }

    function getInfiniteChat() {
        setInterval(function() {
            chatListFunction(lastID);
        }, 3000);
    }

    $(document).ready(function() {
        chatListFunction('ten');
        getInfiniteChat();
    });
</script>

<!-- 메시지 작성 응답 -->
<div class="modal fade" id="successModal" tabindex="-1" role="dialog" aria-labelledby="successModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content" id="modalS">
            <div class="modal-body text-center">
                메시지 전송 성공!
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="warningModal" tabindex="-1" role="dialog" aria-labelledby="warningModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content" id="modalW">
            <div class="modal-body text-center">
                데이터베이스 오류 발생!
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="dangerModal" tabindex="-1" role="dialog" aria-labelledby="dangerModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content" id="modalD">
            <div class="modal-body text-center">
                메시지를 입력해주세요.
            </div>
        </div>
    </div>
</div>

<%
    String message = null;
    if (session.getAttribute("message") != null) {
        message = (String) session.getAttribute("message");
    }
    String messageType = null;
    if (session.getAttribute("messageType") != null) {
        messageType = (String) session.getAttribute("messageType");
    }
    if (message != null) {
%>
<div class="modal fade" id="messageModal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="vertical-alignment-helper">
        <div class="modal-dialog vertical-align-center">
            <div class="modal-content <% if (messageType.equals("오류메시지")) out.println("panel-warning"); %>">
                <div class="modal-header panel-heading">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden>&times;</span>
                        <span class="sr-only">close</span>
                    </button>
                    <h4 class="modal-title"><%= messageType %></h4>
                </div>
                <div class="modal-body">
                    <%= message %>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    $('#messageModal').modal("show");
</script>
<%
        session.removeAttribute("message");
        session.removeAttribute("messageType");
    }
%>

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
