<%@ page language="java" import="java.util.*" pageEncoding="US-ASCII"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>My JSP 'index.jsp' starting page</title>
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
	<table width="80%" border="1" align="center">
		<tbody>
			<tr>
				<th colspan="2" scope="row"><jsp:include page="head.jsp"></jsp:include>
				</th>
			</tr>
			<tr>
				<th width="21%" height="100%" scope="row"><jsp:include page="left.jsp"></jsp:include></th>
				<th scope="row"><jsp:include page="right.jsp"></jsp:include></th>
			</tr>
			<tr>
				<th colspan="2" scope="row"><jsp:include page="tail.jsp"></jsp:include>
				</th>
			</tr>
		</tbody>
	</table>
</body>
</html>
