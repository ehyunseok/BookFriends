<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	session.invalidate();	// 현재 사용자가 클라이언트의 모든 세션 정보를 만료하게 함
%>
<<script>
	location.href = '../index.jsp';
</script>