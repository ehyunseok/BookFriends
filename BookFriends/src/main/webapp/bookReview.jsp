<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDao"%>
<%@ page import="review.ReviewDao"%>
<%@ page import="review.ReviewDto"%>
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
	<!-- 부트스트랩 css 추가하기 -->
	<link rel="stylesheet" href="./css/bootstrap.min.css">
	<!-- 커스텀 css 추가하기 -->
	<link rel="stylesheet" href="./css/custom.css">
	<style>
		.table th:nth-child(1), .table td:nth-child(1) { width: 150px; } /* # */
		.table th:nth-child(2), .table td:nth-child(2) { width: 100px; white-space: nowrap;} /* 카테고리 */
		.table th:nth-child(4), .table td:nth-child(3) { width: 1200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; max-width: 1200px; } /* 제목 길면 석점줄임 */
		.table th:nth-child(5), .table td:nth-child(4) { width: 1000px; white-space: nowrap; }  /* 평점 */
		.table th:nth-child(6), .table td:nth-child(5) { width: 300px; white-space: nowrap;} /* 작성자 */
		.table th:nth-child(7), .table td:nth-child(6) { width: 300px; white-space: nowrap;} /* 작성일 */
		.table th:nth-child(8), .table td:nth-child(7) { width: 100px; white-space: nowrap;}  /* 조회수 */
	</style>
</head>
<body>


<%
//검색했을 때 어떤 게시글을 검색했는지 판단할 수 있게~
	request.setCharacterEncoding("UTF-8");
	int reviewID = 0;
	String category = request.getParameter("category") != null ? request.getParameter("category") : "전체";
    String searchType = request.getParameter("searchType") != null ? request.getParameter("searchType") : "최신순";
    String search = request.getParameter("search") != null ? request.getParameter("search") : "";
    int pageNumber = request.getParameter("pageNumber") != null ? Integer.parseInt(request.getParameter("pageNumber")) : 0;

    ReviewDao reviewDao = new ReviewDao();
    ArrayList<ReviewDto> reviewList = reviewDao.getList(category, searchType, search, pageNumber);
    int totalPosts = reviewDao.getTotalReviews(category, searchType, search);
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
		<a class="navbar-brand" href="index.jsp">독서친구</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div id="navbar" class="collapse navbar-collapse">
			<ul class="navbar-nav mr-auto">
				<li class="nav-item">
					<a class="nav-link" href="index.jsp">메인</a>
				</li>
				<li class="nav-item active">
					<a class="nav-link" href="./bookReview.jsp"><b>서평</b></a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="./board.jsp">자유게시판</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="./recruit.jsp">독서모임</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="./market.jsp">중고장터</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="./chat.jsp">채팅</a>
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
	
<!-- container  -->
	<section class="container">
		<form method="get" action="./bookReview.jsp" class="form-inline mt-3">
			<select name="category" class="form-control mx-1 mt-2">
				<option value="전체">전체</option>
				<option value="문학" <% if(category.equals("문학")) out.println("selected"); %>>문학</option>
				<option value="사회" <% if(category.equals("사회")) out.println("selected"); %>>사회</option>
				<option value="과학" <% if(category.equals("과학")) out.println("selected"); %>>과학</option>
				<option value="예술" <% if(category.equals("예술")) out.println("selected"); %>>예술</option>
				<option value="역사" <% if(category.equals("역사")) out.println("selected"); %>>역사</option>
				<option value="언어(어학)" <% if(category.equals("언어(어학)")) out.println("selected"); %>>언어(어학)</option>
				<option value="기타" <% if(category.equals("기타")) out.println("selected"); %>>기타</option>
			</select>
			<select name="searchType" class="form-control mx-1 mt-2">
				<option value="최신순" <% if(searchType.equals("최신순")) out.println("selected"); %>>최신순</option>
				<option value="조회수순" <% if(searchType.equals("조회수순")) out.println("selected"); %>>조회수순</option>
				<option value="추천순" <% if(searchType.equals("추천순")) out.println("selected"); %>>추천순</option>
			</select>
			<input type="text" name="search" class="form-control mx-1 mt-2" placeholder="내용을 입력해주세요." value="<%= search %>">
			<button type="submit" class="btn btn-dark mx-1 mt-2">검색</button>
			<div class="ml-auto">
				<a class="btn btn-primary mx-1 mt-2" data-toggle="modal" href="#registerModal">작성하기</a>
				<a class="btn btn-outline-danger mx-1 mt-2" data-toggle="modal" href="#reportModal">신고</a>
			</div>
		</form>
		<div class="card bg-light mt-3">
			<table class="table table-hover">
				<thead>
					<tr>
						<th scope="col" style="">#</th>
						<th scope="col" style="">카테고리</th>
						<th scope="col" style="">제목</th>
						<th scope="col" style="">평점</th>
						<th scope="col" style="">작성자</th>
						<th scope="col" style="">작성일</th>
						<th scope="col" style="">조회수</th>
					</tr>
				</thead>
				<tbody>
<%
	for(ReviewDto review : reviewList) {
%>

			  		<!-- 해당 게시글 번호 페이지로 이동 -->
			  		<tr onclick="window.location='./reviewDetail.jsp?reviewID=<%= review.getReviewID() %>'">	
					    <th scope="row"><%= review.getReviewID() %></th>
					    <td><%= review.getCategory() %></td>
					    <td><%= review.getReviewTitle() %> 
					    	<br><small>(추천: <%= review.getLikeCount() %>)</small>
					    	<br><small>[<%= review.getBookName() %>(<%= review.getAuthorName() %>)]</small>
					    </td>
					  <% switch(review.getReviewScore()){
					    	case 5:
					  %>
					    <td>★★★★★</td>
					  <% 	break; 
				    		case 4:
					  %>
					    <td>★★★★　</td>
					  <% 	break; 
				    		case 3:
					  %>
					    <td>★★★　　</td>
					  <% 	break; 
				    		case 2:
					  %>
					    <td>★★　　　</td>
					  <% 	break; 
				    		case 1:
					  %>
					    <td>★　　　　</td>
					  <% 	break; 
				    		case 0:
					  %>
					    <td>☆　　　　</td>
					  <% 	break;
					   	} %>
					   	<td><%= review.getUserID() %></td>
					    <td><% SimpleDateFormat sdf = new SimpleDateFormat("yy.MM.dd"); 
					    	   out.println(sdf.format(review.getRegistDate())); %>
					    </td>
					    <td><%= review.getViewCount() %></td>
				    </tr>
<%
	}
%>
				</tbody>
				<tfoot></tfoot>				
			</table>
		</div>
	
	
	
	
<!-- pagination -->
		<nav aria-label="Page navigation" >
		  <ul class="pagination justify-content-center mt-3" style="padding-bottom: 3px;">
		    <li class="page-item <% if(pageNumber == 0) out.print("disabled"); %>">
                <a class="page-link" href="?category=<%= category %>&searchType=<%= searchType %>&search=<%= search %>&pageNumber=<%= pageNumber - 1 %>">이전</a>
            </li>
<%
    for (int i = startPage; i <= endPage; i++) { 
%>
			<li class="page-item<% if(i == pageNumber + 1) out.print("active"); %>">
            	<a class="page-link" href="./bookReview.jsp?category=<%= URLEncoder.encode(category, "UTF-8") %>&searchType=<%= URLEncoder.encode(searchType, "UTF-8") %>&search=<%= URLEncoder.encode(search, "UTF-8") %>&pageNumber=<%= i - 1 %>"><%= i %></a>
        	</li>
<% } 
%>
		    <li class="page-item <% if(pageNumber >= totalPages - 1) out.print("disabled"); %>">
                <a class="page-link" href="?category=<%= category %>&searchType=<%= searchType %>&search=<%= search %>&pageNumber=<%= pageNumber + 1 %>">다음</a>
            </li>
		  </ul>
		</nav>
	</section>
	
<!-- 서평 등록하기 모달  -->
	<div class="modal fade" id="registerModal" tabindex="-1" role="dialog" aria-labelledby="modal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">서평 작성</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form method="post" action="./reviewRegisterAction.jsp">
						<div class="form-row">
							<div class="form-group col-sm-3">
								<label>카테고리</label>
								<select name="category" class="form-control">
									<option selected value="선택">선택</option>
									<option value="문학">문학</option>
									<option value="사회">사회</option>
									<option value="과학">과학</option>
									<option value="예술">예술</option>
									<option value="역사">역사</option>
									<option value="언어(어학)">언어(어학)</option>
									<option value="기타">기타</option>
								</select>
							</div>
						</div>
						<div class="form-row">
							<div class="form-group col-sm-12">
								<label>서명</label>
								<input type="text" name="bookName" class="form-control" maxlength="500">
							</div>
						</div>
						<div class="form-row">
							<div class="form-group col-sm-4">
								<label>저자</label>
								<input type="text" name="authorName" class="form-control" maxlength="100">
							</div>
							<div class="form-group col-sm-4">
								<label>출판사</label>
								<input type="text" name="publisher" class="form-control" maxlength="20">
							</div>
							<div class="form-group col-sm-4">
								<label>평점</label>
								<select name="reviewScore" class="form-control">
									<option value="99" selected>선택</option>
									<option value="5">★★★★★</option>
									<option value="4">★★★★</option>
									<option value="3">★★★</option>
									<option value="2">★★</option>
									<option value="1">★</option>
									<option value="0">☆</option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label>제목</label>
							<input type="text" name="reviewTitle" class="form-control" maxlength="100">
						</div>
						<div class="form-group">
							<label>내용</label>
							<textarea name="reviewContent" class="form-control" maxlength="2048" style="height: 180px;"></textarea>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
							<button type="submit" class="btn btn-primary">등록</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>

	
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
					<form action="./reportAction.jsp" method="post">
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
	<script src="./js/jquery.min.js"></script>
	<!-- popper js 추가하기 -->
	<script src="./js/popper.min.js"></script>
	<!-- bootstrap js 추가하기 -->
	<script src="./js/bootstrap.min.js"></script>
</body>
</html>