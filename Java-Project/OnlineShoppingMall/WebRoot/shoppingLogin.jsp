<%@ page language="java" import="java.util.*" pageEncoding="GB18030"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'shoppingLogin.jsp' starting page</title>
    
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
     <table width="80%"  border="1" align="center">
  <tbody>
    <tr>
      <td valign="middle"><jsp:include page="head.jsp"></jsp:include> </td>
    </tr>
    <tr>
      <td>
      <form action="LoginControlServlet" method="post">
      <table width="100%" border="1">
        <tbody>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td width="80%"><table width="70%" border="1" align="center">
              <tbody>
                <tr>
                  <td colspan="2" align="center">User Login System </td>
                </tr>
                <tr>
                  <td width="40%">UserName </td>
                  <td width="60%">
                    <input name="username" type="text" autofocus id="textfield" size="20"></td>
                </tr>
                <tr>
                  <td>Password</td>
                  <td>
                    <input name="password" type="password" id="textfield2" size="20"></td>
                </tr>
                <tr>
                  <td><input type="button" name="submit" id="submit" value="Sign up for free"></td>
                  <td><input type="submit" name="button" id="button" value="submit"></td>
                </tr>
              </tbody>
            </table></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
        </tbody>
      </table>
      </form>
      </td>
    </tr>
    <tr>
      <td><jsp:include page="tail.jsp"></jsp:include></td>
    </tr>
  </tbody>
</table>


  </body>
</html>
