<%@ page language="java" import="java.util.*,java.sql.*,com.qiankun.model.*"
	pageEncoding="US-ASCII"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>My JSP 'loginCL.jsp' starting page</title>

<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

</head>

<body>
	<%
		String u = request.getParameter("username");
		String p = request.getParameter("password");

		UserBeanControl ubc = new UserBeanControl();

		if (ubc.checkUser(u, p)) {
			response.sendRedirect("wel.jsp?user=" + u);
		} else {
			response.sendRedirect("login.jsp");
		}
	%>



</body>
</html>
