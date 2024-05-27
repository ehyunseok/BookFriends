<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDao"%>
<%@ page import="recruit.RecruitDao"%>
<%@ page import="recruit.RecruitDto"%>
<%@ page import="file.FileDao"%>
<%@ page import="file.FileDto"%>
<%@ page import="java.sql.Timestamp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>독서친구</title>
    <link rel="stylesheet" href="./css/bootstrap.min.css">
    <link rel="stylesheet" href="./css/custom.css">
    <style>
        #editor {
            width: auto;
            margin: 0 auto;
        }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
    <script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
</head>
<body>
<%
    request.setCharacterEncoding("UTF-8");

    String userID = null;
    if (session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID");
    }
    if (userID == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인을 해주세요.');");
        script.println("location.href='userLogin.jsp'");
        script.println("</script>");
        script.close();
        return;
    }

    boolean emailChecked = new UserDao().getUserEmailChecked(userID);
    if (emailChecked == false) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("location.href='emailSendConfirm.jsp'");
        script.println("</script>");
        script.close();
        return;
    }
%>

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
            <li class="nav-item">
                <a class="nav-link" href="./board.jsp">자유게시판</a>
            </li>
            <li class="nav-item active">
                <a class="nav-link" href="./recruit.jsp"><b>독서모임</b></a>
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

<section class="container mt-3 mb-5">
    <div class="">
        <div class="card-body">
            <form action="<%= request.getContextPath() %>/recruitWriteAction" method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <input class="" name="recruitTitle" placeholder="모집글 제목을 작성해주세요."
                           style="height: 50px; width:100%; border: none; background:transparent;"></input>
                </div>
                <div class="form-group">
                    <input name="recruitStatus" value="모집중" type="hidden">
                </div>
                <div class="form-group">
                    <input type="hidden" id="recruitContent" name="recruitContent" maxlength="2048">
                </div>
                <div id="editor"></div>
                <div class="row ml-auto mt-3">
                    <a class="btn btn-outline-secondary mr-1" href="./recruit.jsp">취소</a>
                    <button type="submit" class="btn btn-primary">작성</button>
                </div>
            </form>
        </div>
    </div>
</section>

<!-- toast ui editor 추가 -->
<script>
const contextPath = '<%= request.getContextPath() %>';
const editor = new toastui.Editor({
    el: document.querySelector('#editor'),
    height: '500px',
    initialEditType: 'markdown',
    previewStyle: 'vertical',
    initialValue: '[독서 모임 모집 내용 예시]\n- 모임 주제 : \n- 모임 목표 : \n- 예상 모임 일정(횟수) : \n- 예상 모임 내용 간략히 : \n- 예상 모집인원 : \n- 모임 소개와 개설 이유 : \n- 모임 관련 주의사항 : \n- 모임에 지원할 수 있는 방법을 남겨주세요. (이메일, 카카오 오픈채팅방, 구글폼 등.)',
    hooks: {
        async addImageBlobHook(blob, callback) {
            try {
                const formData = new FormData();
                formData.append('image', blob);

                console.log('Sending request to:', `${contextPath}/file-handler`);  // 디버그 로그 추가

                const response = await fetch(`${contextPath}/file-handler`, {
                    method: 'POST',
                    body: formData,
                });

                if (response.ok) {
                    const filename = await response.text();
                    const imageUrl = `${contextPath}/file-handler?filename=${filename}`;
                    console.log('Image uploaded successfully:', imageUrl);
                    callback(imageUrl, 'image alt attribute');
                } else {
                    console.error('Image upload failed:', response.statusText);
                }
            } catch (error) {
                console.error('Image upload failed:', error);
            }
        }
    }
});

    $('form').on('submit', function (e) {
        var editorContent = editor.getMarkdown();
        $('#recruitContent').val(editorContent);
        if (!editorContent.trim()) {
            alert('내용을 입력해주세요.');
            e.preventDefault();
        }
    });
</script>

<footer class="fixed-bottom bg-dark text-center mt-5" style="color: #FFFFFF;">
    Copyright &copy; 2024 EhyunSeok All Rights Reserved.
</footer>

<script src="./js/jquery.min.js"></script>
<script src="./js/popper.min.js"></script>
<script src="./js/bootstrap.min.js"></script>
</body>
</html>

