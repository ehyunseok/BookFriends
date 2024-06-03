<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDao"%>
<%@ page import="recruit.RecruitDao"%>
<%@ page import="recruit.RecruitDto"%>
<%@ page import="reply.ReplyDto"%>
<%@ page import="reply.ReplyDao"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta http-equiv="Content-Security-Policy" 
	content=
	"default-src 'self'; 
	script-src 'self'; 
	style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; 
	font-src 'self' https://fonts.gstatic.com; 
	img-src 'self' data:;">
	<title>독서친구</title>
	<!-- 부트스트랩 css 추가하기 -->
	<link rel="stylesheet" href="../css/bootstrap.min.css">
	<!-- 커스텀 css 추가하기 -->
	<link rel="stylesheet" href="../css/custom.css">
	<style>
	</style>
</head>
<body>


<%
//검색했을 때 어떤 게시글을 검색했는지 판단할 수 있게
	request.setCharacterEncoding("UTF-8");
	int recruitID = 0;
	String recruitStatus = request.getParameter("recruitStatus") != null ? request.getParameter("recruitStatus") : "전체";
    String searchType = request.getParameter("searchType") != null ? request.getParameter("searchType") : "최신순";
    String search = request.getParameter("search") != null ? request.getParameter("search") : "";
    int pageNumber = request.getParameter("pageNumber") != null ? Integer.parseInt(request.getParameter("pageNumber")) : 0;

    RecruitDao recruitDao = new RecruitDao(); 
    ArrayList<RecruitDto> recruitList = recruitDao.getList(recruitStatus, searchType, search, pageNumber);
    int totalPosts = recruitDao.getTotalPosts(recruitStatus, searchType, search);
    int totalPages = (int) Math.ceil(totalPosts / 5.0);
    int pageBlock = 5;
    int startPage = (pageNumber / pageBlock) * pageBlock + 1;
    int endPage = Math.min(startPage + pageBlock - 1, totalPages);
	
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
				<li class="nav-item active">
					<a class="nav-link" href="./recruit.jsp"><b>독서모임</b></a>
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
	
<!-- container  -->
	<section class="container">
		<form method="get" action="./recruit.jsp" class="form-inline mt-3">
			<select name="recruitStatus" class="form-control mx-1 mt-2">
				<option value="전체">전체</option>
				<option value="모집중" <% if(recruitStatus.equals("모집중")) out.println("selected"); %>>모집중</option>
				<option value="모집완료" <% if(recruitStatus.equals("모집완료")) out.println("selected"); %>>모집완료</option>
			</select>
			<select name="searchType" class="form-control mx-1 mt-2">
				<option value="최신순" <% if(searchType.equals("최신순")) out.println("selected"); %>>최신순</option>
				<option value="조회수순" <% if(searchType.equals("조회수순")) out.println("selected"); %>>조회수순</option>
			</select>
			<input type="text" name="search" class="form-control mx-1 mt-2" placeholder="내용을 입력해주세요." value="<%= search %>">
			<button type="submit" class="btn btn-dark mx-1 mt-2">검색</button>
			<div class="ml-auto">
				<a class="btn btn-primary mx-1 mt-2" href="./recruitRegist.jsp">작성하기</a>
				<a class="btn btn-outline-danger mx-1 mt-2" data-toggle="modal" href="#reportModal">신고</a>
			</div>
		</form>
		<div class="card bg-light mt-3">
			<table class="table table-hover">
				<tbody>
<%
	for(RecruitDto recruit : recruitList) {
		// 댓글 리스트 가져오기
		String recruitIDStr = Integer.toString(recruitID);
		ArrayList<ReplyDto> replyList = new ReplyDao().getListForRecruit(recruitIDStr);
		// 댓글 개수 가져오기
		int countReply = replyList.size();
		String recruitContent = recruit.getRecruitContent().replaceAll("<[^>]*>", ""); // HTML 태그 제거
        String shortContent = recruitContent.length() > 150 ? recruitContent.substring(0, 150) + "..." : recruitContent; // 석점 줄임 처리
%>

			  		<!-- 해당 게시글 번호 페이지로 이동 -->
			  		<tr data-url="./recruitDetail.jsp?recruitID=<%= recruit.getRecruitID() %>">
				  		<td>
				  		<% if(recruit.getRecruitStatus().equals("모집중")){ %>
					    	<span class="badge badge-success">모집중</span>
					    <% } else{ %>
					    	<span class="badge badge-secondary">모집완료</span>
					    <% } %>
						    <span><%= recruit.getRecruitTitle() %></span>
						    <br><span class="ml-3" id="text-ellipsis">
						    <small><%= shortContent %></small></span>
					    	<br>
					    	<div class="row m-1">
						    	<div class="text-left ml-1" style="color:gray;"><img src="../images/icon.png" style="height:12px;"> <%= recruit.getUserID() %> · <%= recruit.getRegistDate() %></div>
						    	<div class="text-right ml-auto" style="color:gray;">
						    		<img src="../images/eye-icon.png" style="height:16px;"> <%= recruit.getViewCount() %>
						    		<img src="../images/bubble-Icon.png" style="height:25px;"> <%= countReply %>
						    	</div>
					    	</div>
					    </td>	
				    </tr>
<%
	}
%>
				</tbody>
			</table>
		</div>
	
	
	
	
<!-- pagination -->
		<nav aria-label="Page navigation" >
		  <ul class="pagination justify-content-center mt-3" style="padding-bottom: 3px;">
		    <li class="page-item <% if(pageNumber == 0) out.print("disabled"); %>">
                <a class="page-link" href="?recruitStatus=<%= recruitStatus %>&searchType=<%= searchType %>&search=<%= search %>&pageNumber=<%= pageNumber - 1 %>">이전</a>
            </li>
<%
    for (int i = startPage; i <= endPage; i++) { 
%>
			<li class="page-item<% if(i == pageNumber + 1) out.print("active"); %>">
            	<a class="page-link" href="./recruit.jsp?recruitStatus=<%= URLEncoder.encode(recruitStatus, "UTF-8") %>&searchType=<%= URLEncoder.encode(searchType, "UTF-8") %>&search=<%= URLEncoder.encode(search, "UTF-8") %>&pageNumber=<%= i - 1 %>"><%= i %></a>
        	</li>
<% } 
%>
		    <li class="page-item <% if(pageNumber >= totalPages - 1) out.print("disabled"); %>">
                <a class="page-link" href="?recruitStatus=<%= recruitStatus %>&searchType=<%= searchType %>&search=<%= search %>&pageNumber=<%= pageNumber + 1 %>">다음</a>
            </li>
		  </ul>
		</nav>
	</section>
	
	
<!-- 신고하기 모달  -->
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
	

<!--  -->
	<!-- jquery js 추가하기 -->
	<script src="../js/jquery.min.js"></script>
	<!-- popper js 추가하기 -->
	<script src="../js/popper.min.js"></script>
	<!-- bootstrap js 추가하기 -->
	<script src="../js/bootstrap.min.js"></script>
	<!-- custom.js 추가하기 -->
	<script src="../js/custom.js"></script>
</body>
</html>