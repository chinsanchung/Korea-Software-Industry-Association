<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.spring.springboard.BoardDAO" %>
<%@page import="com.spring.springboard.BoardVO" %>
<%@page import="java.util.ArrayList" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	if(session.getAttribute("loginID") == null) 
		response.sendRedirect("./loginForm.jsp");
	
		request.setCharacterEncoding("utf-8");

		ArrayList<BoardVO> boardList= (ArrayList<BoardVO>)request.getAttribute("boardList");
		String userName= (String)session.getAttribute("userName");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>글 목록</title>
</head>
<body>
<div align="center">
<center>
<h3>Gurm's BoardList</h3>
<h3><font coclor='orange'><%=userName%></font> 님 환영합니다
	<a href='./user.do?method=logout'>LOGOUT</a></h3>
<hr>
<table border='1' cellpadding='0' cellspacing='0' width='700'>
	<tr>
		<th bgcolor='orange'>번호</th>
		<th bgcolor='orange'>제목</th>
		<th bgcolor='orange'>작성자</th>
		<th bgcolor='orange'>등록일</th>
		<th bgcolor='orange'>조회수</th>
	</tr>
<%
	for (int i= 0; i < boardList.size(); i++) {
		BoardVO vo= boardList.get(i);
%>
	<tr>
		<td align='center' width='50'><%=vo.getSeq()%></td>
		<td align='left' width='300'>
		<a href='./board.do?method=getBoard&seq=<%=vo.getSeq()%>'><%=vo.getTitle()%></a></td>
		<td align='center' width='100'><%=vo.getWriter()%></td>
		<td align='center' width='150'><%=vo.getRegdate()%></td>
	</tr>
<%} %>
<!-- JSP를 사용한 방식. vo는 boardVO객체. get메소드가 있어서 get으로 출력가능. 이걸로 하면 10번줄 필요없음
<c:forEach var="vo" items="${boardList}">
	<tr>
		<td align='center' width='50'>${vo.getSeq()}</td>
		<td align='left' width='300'>
		<a href='./board.do?method=getBoard&seq=${vo.getSeq()}'>${vo.getTitle()}</a></td>
		<td align='center' width='100'>${vo.getWriter()}</td>
		<td align='center' width='150'>${vo.getRegdate()}</td>
		<td align='center' width='100'>${vo.getCnt()}</td>
	</tr>
</c:forEach>
 -->
 </table>
 <hr><br>
 <a href='./board.do?method=addBoardForm'>새 글 쓰기</a>
</center>
</div>
</body>
</html>