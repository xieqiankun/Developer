<%@ page language="java" import="java.util.*,com.qiankun.model.*"
	pageEncoding="GB18030"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
ArrayList<GoodsBean> al = (ArrayList<GoodsBean>)request.getAttribute("cartresult");

MyCartBO cart = (MyCartBO)request.getSession().getAttribute("cart");


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>My JSP 'showMycart.jsp' starting page</title>

<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
<script type="text/javascript">
	
	function delAll(){
		window.open("ShoppingControlServlet?type=delall","_self");
	}
	function next(){
		window.open("UserLoginControlServlet","_self");
	}
	
	
	</script>



</head>

<body>
	<table width="80%" border="1" align="center">
		<tbody>
			<tr>
				<td valign="middle"><jsp:include page="head.jsp"></jsp:include>
				</td>
			</tr>
			<tr>
				<td>
					<form action="ShoppingControlServlet?type=update" method="post">
						<table width="100%" border="1">
							<tbody>
								<tr>
									<td colspan="6">Shopping now</td>
								</tr>
								<tr>
									<td width="25%">ID</td>
									<td width="25%">Name</td>
									<td width="25%">Price</td>
									<td width="25%" colspan="3">Number</td>
								</tr>
								<%
          	for(int i = 0; i< al.size(); i++){
          	GoodsBean gb = al.get(i);
          	%>
          	<tr>
            <td width="25%"><%= gb.getGoodsID() %></td>
            <td width="25%"><%= gb.getGoodsName() %></td>
            <td width="25%"><%= gb.getGoodsPrice() %></td>
            <td width="8%"><input type="hidden" name="goodsid" value="<%=gb.getGoodsID() %>" ><input type="text" name="newnum" size="1" value="<%=cart.getGoodsNumByID(gb.getGoodsID()+"") %>" ></td>
            <td width="8%"><a href="ShoppingControlServlet?type=del&id=<%= gb.getGoodsID() %>">Delete</a></td>
            <td><a href="ShowGoodsControlServlet?type=showdetail&id=<%= gb.getGoodsID() %>">Detail </a></td>
         	 </tr>
          	
          	
          	<%
          	}
          
          
           %>
          
          
          <tr>
            <td>&nbsp;</td>
            <td><input type="button" name="submit" id="submit" onclick="delAll()" value="Empty Them"></td>
            <td><input type="submit" name="submit2" id="submit2" value="Change Number"></td>
            <td colspan="3">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="6">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="6"><table width="100%" border="1">
              <tbody>
                <tr>
                  <td>Total amount:<%= cart.getTotalExpanse() %> </td>
                  <td><input type="button" name="submit3" onclick="next()" id="submit3" value="Next"></td>
                </tr>
              </tbody>
            </table>
							</td>
         
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
