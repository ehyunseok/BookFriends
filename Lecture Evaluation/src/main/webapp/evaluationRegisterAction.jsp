<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="evaluation.EvaluationDto"%>
<%@ page import="evaluation.EvaluationDao"%>
<%@ page import="util.SHA256"%>
<%@ page import="java.io.PrintWriter"%>
<%
	request.setCharacterEncoding("UTF-8");

	String userID = null;
	if(session.getAttribute("userID") != null){		// 로그인한 상태라서 세션에 userID가 존재할 경우
		userID = (String)session.getAttribute("userID");	// userID에 해당 세션의 값을 저장함
	}
	if(userID == null){		// 로그인 상태가 아닌 경우에는 로그인 화면으로 이동
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href='userLogin.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
	
	String lectureName = null;
	String professorName = null;
	int lectureYear = 0;
	String semesterDivide = null;
	String lectureDivide = null;
	String evaluationTitle = null;
	String evaluationContent = null;
	String totalScore = null;
	String skillScore = null;
	String usabilityScore = null;
	
	if(request.getParameter("lectureName") != null){
		lectureName = request.getParameter("lectureName");
	}
	if(request.getParameter("professorName") != null){
		professorName = request.getParameter("professorName");
	}
	if(request.getParameter("lectureYear") != null){
		try{
			lectureYear = Integer.parseInt( request.getParameter("lectureYear") );
		} catch (Exception e){
			e.printStackTrace();
			System.out.println("강의 연도 오류");
		}
	}
	if(request.getParameter("semesterDivide") != null){
		semesterDivide = request.getParameter("semesterDivide");
	}
	if(request.getParameter("lectureDivide") != null){
		lectureDivide = request.getParameter("lectureDivide");
	}
	if(request.getParameter("evaluationTitle") != null){
		evaluationTitle = request.getParameter("evaluationTitle");
	}
	if(request.getParameter("evaluationContent") != null){
		evaluationContent = request.getParameter("evaluationContent");
	}
	if(request.getParameter("totalScore") != null){
		totalScore = request.getParameter("totalScore");
	}
	if(request.getParameter("skillScore") != null){
		skillScore = request.getParameter("skillScore");
	}
	if(request.getParameter("usabilityScore") != null){
		usabilityScore = request.getParameter("usabilityScore");
	}
	
	if(lectureName == null || professorName == null || lectureYear == 0 
			|| semesterDivide == null || lectureDivide == null || evaluationTitle == null 
			|| evaluationContent == null || totalScore == null || skillScore == null 
			|| usabilityScore == null 
			|| lectureName.equals("") || professorName.equals("")
			|| semesterDivide.equals("") || lectureDivide.equals("") || evaluationTitle.equals("") 
			|| evaluationContent.equals("") || totalScore.equals("") || skillScore.equals("") 
			|| usabilityScore.equals("")){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('모든 항목을 입력하세요.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
	// 모든 항목을 다 입력했을 경우, 평가 게시글을 등록한다.
	EvaluationDao evalDao = new EvaluationDao();
	int result = evalDao.write(new EvaluationDto(0, userID, lectureName, professorName, lectureYear, semesterDivide, lectureDivide, evaluationTitle, evaluationContent, totalScore, skillScore, usabilityScore, 0));
	if(result == -1){	// 등록 실패
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('강의 평가 등록 실패');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else {	// 등록 성공
		session.setAttribute("userID", userID);
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('강의 평가 등록 완료');");
		script.println("location.href='index.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
	
%>