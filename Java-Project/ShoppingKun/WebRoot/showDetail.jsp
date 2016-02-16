<%@ page language="java" import="java.util.*,com.qiankun.model.*" pageEncoding="GB18030"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

//get goodsbean
GoodsBean gb = (GoodsBean)request.getAttribute("goodsinfo");





%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'showDetail.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<script type="text/javascript">
	
	function returnHall(){
	
		window.open("index.jsp","_self");
	}
	
	function addGoods(id){
	
		window.open("ShoppingControlServlet?type=add&id="+id,"_self");
	
	}
	
	</script>
	
	

  </head>
  
  <body>
   <center>
   <table width="80%" border="1">
  <tbody>
    <tr>
      <td><jsp:include page="head.jsp"></jsp:include> </td>
    </tr>
    <tr>
      <td><table width="100%" border="1">
        <tbody>
          <tr >
            <td colspan="2">&nbsp;</td>
           
          </tr>
          <tr>
            <td width="35%" rowspan="8">&nbsp;</td>
            <td align="center" valign="top"><%=gb.getGoodsName()%> </td>
          </tr>
          <tr>
            <td>number in stock: <%=gb.getGoodsNum() %></td>
          </tr>
          <tr>
            <td>price: <%=gb.getGoodsPrice() %></td>
          </tr>
          <tr>
            <td>style: <%=gb.getType() %> </td>
          </tr>
          <tr>
            <td>publisher: <%=gb.getPublisher() %> </td>
          </tr>
          <tr>
            <td >&nbsp;</td>
          </tr>
          <tr>
            <td  >detail: <%=gb.getGoodsIntro() %> </td>
          </tr>
          <tr>
            <td >&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><input type="submit" name="submit" onclick="addGoods(<%=gb.getGoodsID() %>)" id="submit" value="Buy it">
              <input type="submit" name="submit2" id="submit2" onclick="returnHall()" value="Back to Main"></td>
          </tr>
        </tbody>
      </table></td>
    </tr>
    <tr>
      <td><jsp:include page="tail.jsp"></jsp:include></td>
    </tr>
  </tbody>
</table>
   
   
   </center>
  </body>
</html>
