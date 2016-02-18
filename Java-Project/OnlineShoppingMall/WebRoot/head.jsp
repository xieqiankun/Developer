<%@ page language="java" import="java.util.*" pageEncoding="GB18030"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<table width="100%" border="1">
  <tbody>
    <tr>
      <th colspan="3" bgcolor="#CECBCB" scope="row">&nbsp;</th>
    </tr>
    <tr>
      <th width="20%" rowspan="2" scope="row"></th>
      <th rowspan="2" scope="row">KunKun Shopping Mall</th>
      <th width="20%" scope="row">My Account </th>
    </tr>
    <tr>
      <th scope="row"><a href="ShoppingControlServlet?type=show">My Cart </a></th>
    </tr>
    <tr>
      <th colspan="3" bgcolor="#C7BCBC" scope="row">&nbsp;</th>
    </tr>
    <tr>
      <th colspan="3" scope="row"><table width="100%" border="1">
        <tbody>
          <tr>
           	
            <td width="11%">&nbsp;</td>
            <td width="11%"><a href="index.jsp">Home page</a> </td>
            <td width="11%">&nbsp;</td>
            <td width="11%">Movie </td>
            <td width="11%">&nbsp;</td>
            <td width="11%">Books </td>
            <td width="11%">&nbsp;</td>
            <td width="11%">About us </td>
            <td width="11%">&nbsp;</td>
          </tr>
        </tbody>
      </table></th>
    </tr>
  </tbody>
</table>
