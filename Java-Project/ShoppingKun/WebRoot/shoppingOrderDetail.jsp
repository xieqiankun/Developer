<%@ page language="java" import="java.util.*,com.qiankun.model.*" pageEncoding="GB18030"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

OrderInfoBean oib = (OrderInfoBean)request.getAttribute("orderinfo");


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'shoppingOrderDetail.jsp' starting page</title>
    
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
      <td valign="middle"><jsp:include page="head.jsp"></jsp:include> </td>
    </tr>
    <tr>
      <td><table width="100%" border="1">
        <tbody>
          <tr>
            <td align="center">Check Infomation </td>
          </tr>
          <tr>
            <td align="center">
            Order detail</td>
          </tr>
          <tr>
            <td><table width="100%" border="1">
              <tbody>
                <tr>
                  <td width="10%">Order Num</td>
                  <td width="14%">Receiver</td>
                  <td width="20%">Address</td>
                  <td width="14%">Phone</td>
                  <td width="10%">Total Price</td>
                  <td width="15%">E-mail</td>
                  <td width="11%">&nbsp;</td>
          
                </tr>
                <tr>
                  <td><%=oib.getOrderId()  %></td>
                  <td><%=oib.getUserName()  %></td>
                  <td><%=oib.getAddr() %></td>
                  <td><%=oib.getPhone() %></td>
                  <td><%=oib.getTotalPrice()  %></td>
                  <td><%=oib.getEmail() %></td>
                  <td><a href="ShoppingControlServlet?type=show">Detail</a></td>
                </tr>
              </tbody>
            </table>
              </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
        </tbody>
      </table>
      </td>
    </tr>
    <tr>
      <td><jsp:include page="tail.jsp"></jsp:include> </td>
    </tr>
  </tbody>
</table>


  </body>
</html>
