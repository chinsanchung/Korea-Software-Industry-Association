<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="board.BoardDBBean"%>
<%@ page import="java.sql.Timestamp" %>
<%request.setCharacterEncoding("utf-8"); %>
<jsp:useBean id="article" scope="page" class="board.BoardDataBean" >
	<jsp:setProperty name="article" property="*" />
</jsp:useBean>
<%
	String pageNum=request.getParameter("pageNum");
	BoardDBBean dbPro=BoardDBBean.getInstance();
	int check=dbPro.updateArticle(article);
	//content=" 0   0은 시간. 0초후에 창이 어쩌고 	
	if(check==1) { %>
		<meta http-equiv="Refresh" content="0;url=list.jsp?pageNum=<%=pageNum%>">
<%	} else {%>
	<script language="JavaScript">
	<!--
		alert("비밀번호가 맞지 않습니다.");
		history.go(-1);
	-->
	</script>
<% } %>
