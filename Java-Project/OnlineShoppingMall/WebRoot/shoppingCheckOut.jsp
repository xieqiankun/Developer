<%@ page language="java" import="java.util.*,com.qiankun.model.*" pageEncoding="GB18030"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

UserBean ub = (UserBean)request.getSession().getAttribute("username");

ArrayList<GoodsBean> al = (ArrayList<GoodsBean>)request.getAttribute("showcart");

MyCartBO cart = (MyCartBO)request.getSession().getAttribute("cart");

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'shoppingCheckOut.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<script type="text/javascript">
	
	function orderDetail(){
		window.open("OrderControlServlet","_self");
	
	}
	
	
	</script>

  </head>
  
  <body>
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
            <td><table width="80%" border="1" align="center">
              <tbody>
                <tr>
                  <td colspan="2" align="center">User Information </td>
                </tr>
                <tr>
                  <td width="50%">Username</td>
                  <td width="50%"><input type="text" name="username" value="<%= ub.getUserName() %>"></td>
                </tr>
                <tr>
                  <td>Address </td>
                  <td><input type="text" name="addr" value="<%= ub.getAddr() %>"></td>
                </tr>
                <tr>
                  <td>Tel </td>
                  <td><input type="text" name="tel" value="<%= ub.getPhone() %>"></td>
                </tr>
                <tr>
                  <td>Email </td>
                  <td><input type="text" name="email" value="<%= ub.getEmail() %>"></td>
                </tr>
                <tr>
                  <td><input type="button" name="button" id="button" value="Finish and Check out"></td>
                  <td><input type="button" name="button2" id="button2" value="Change personal Info"></td>
                </tr>
              </tbody>
            </table></td>
          </tr>
          <tr>
            <td><table width="80%" border="1" align="center">
              <tbody>
                <tr>
                  <td width="25%">Item Code </td>
                  <td width="25%">Name </td>
                  <td width="25%">Unit Price </td>
                  <td width="25%">Number</td>
                </tr>
                <%
                	for(int i = 0; i< al.size(); i++){
        			GoodsBean gb = al.get(i);
 	
                	%>
                 <tr>
                  <td><%=gb.getGoodsID()  %></td>
                  <td><%=gb.getGoodsName()  %></td>
                  <td><%=gb.getGoodsPrice()  %></td>
                  <td><%=cart.getGoodsNumByID(gb.getGoodsID()+"")  %></td>
                </tr>
                
                	<%
                	}
                 %>
                
               
                <tr>
                  <td colspan="4">total expense: <%=cart.getTotalExpanse()  %></td>
                </tr>
                <tr>
                  <td colspan="4">Back to cart</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td><input type="button" name="button3" id="button3" onclick="orderDetail()" value="Next"></td>
                </tr>
              </tbody>
            </table></td>
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
  </body>
</html>
