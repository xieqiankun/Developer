<%@ page language="java"
	import="java.util.*,java.sql.*,com.qiankun.model.*"
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

<title>My JSP 'wel.jsp' starting page</title>

<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
<script type="text/javascript">
<!--
	function abc() {
		return window.confirm("Are you sure?");
	}
	-->
</script>

</head>

<body>
	<center>
		<%
			//prevent user login ilegally
			String u = (String) session.getAttribute("myName");
			if (u == null) {
				response.sendRedirect("login.jsp");
				return;
			}
		%>
		Welcome Here!<%=(String) session.getAttribute("myName")%><br>

		<h3>User List</h3>
		<%
			int pageSize = 3;

			int pageNow = Integer.parseInt((String) (request
					.getAttribute("pageNow")));

			String s_pageCount = (String) request.getAttribute("pageCount");
			int pageCount = Integer.parseInt(s_pageCount);

			//call userbeanControl show function
			//	UserBeanControl ubc = new UserBeanControl();
			//	ArrayList<UserBean> al = ubc.getResultByPage(pageNow, pageSize);
			ArrayList<UserBean> al = (ArrayList<UserBean>) request
					.getAttribute("result");
		%>
		<table border=1>
			<tr>
				<td>Number</td>
				<td>User Name</td>
				<td>Password</td>
				<td>Change User</td>
				<td>Delete User</td>
			</tr>
			<%
				for (int i = 0; i < al.size(); i++) {
					UserBean ub = al.get(i);
			%>
			<tr>
				<td><%=ub.getUserNum()%></td>
				<td><%=ub.getUserName()%></td>
				<td><%=ub.getPasswd()%></td>
				<td><a
					href="updateuser.jsp?username=<%=ub.getUserName() %>&password=<%=ub.getPasswd()%>&id=<%=ub.getUserNum()%>">Change
						Him/Her</a></td>
				<td><a onclick="return abc()"
					href="UserClServlet?flag=del&userID=<%=ub.getUserNum()%>">Delete
						Him/Her</a></td>
			</tr>

			<%
				}
			%>


		</table>
		<%
			//	System.out.println(pageNow+" "+ pageCount);
			if (pageNow > 1)
				out.println("<a href=UserClServlet?flag=seperate&pageNow="
						+ (pageNow - 1) + ">Befor</a>");
			for (int i = pageNow; (i <= pageCount && i < pageNow + 5); i++) {
				out.println("<a href=UserClServlet?flag=seperate&pageNow=" + i
						+ ">[" + i + "]</a>");
			}
			if (pageNow < pageCount)
				out.println("<a href=UserClServlet?flag=seperate&pageNow="
						+ (pageNow + 1) + ">Next</a>");
		%>

		<br> <a href="main.jsp">Back To Main</a><br> <a
			href="login.jsp">Go To Login</a>



	</center>
</body>
</html>
