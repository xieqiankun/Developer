<%@ page language="java" import="java.util.*" pageEncoding="US-ASCII"%>
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

<title>My JSP 'updateuser.jsp' starting page</title>

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
	<center>
	<hr>
	<p>Update User</p>
	<form action="UserClServlet?flag=update" method="post">
		<table>
			<tr>
				<td>UserID</td>
				<td><input type="text" readonly="readonly" name="userid"
					value="<%=request.getParameter("id")%>"></td>
			</tr>
			<tr>
				<td>UserName</td>
				<td><input type="text" readonly="readonly" name="username"
					value="<%=request.getParameter("username")%>"></td>
			</tr>
			<tr>
				<td>Password</td>
				<td><input type="text" name="password"
					value="<%=request.getParameter("password")%>"></td>
			</tr>
			<tr>
				<td><input type="reset" value="reset"></td>
				<td><input type="submit" value="sumbit"></td>
			</tr>
		</table>
	</form>

	</center>
</body>
</html>
