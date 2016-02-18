<%@ page language="java" import="java.util.*,com.qiankun.model.*"
	pageEncoding="GB18030"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";

	//use goodsbeanBO() to achieve seperate page
	String s_pageNow = request.getParameter("s_pageNow");
	int pageNow = 1;
	if(s_pageNow != null){
		pageNow = Integer.parseInt(s_pageNow);
	}
	
	GoodsBeanBO gbb = new GoodsBeanBO();
	ArrayList<GoodsBean> al = gbb.getGoodsByPage(12, pageNow);

	//get total pageCount
	int pageCount = gbb.getPageCount(12);
%>

<table width="100%" height="100%" border="1">
	<tbody>
		<tr>
			<td colspan="3">Recomment Items</td>
		</tr>

		<%
			for (int i = 0; i < 12; i++) {
				GoodsBean gb = null;
				if (i % 3 == 0)
					if (i / 3 % 2 == 0)
						out.println("<tr>");
				if(i < al.size())
					gb = al.get(i);
				else {
					gb = al.get(al.size()-1);
				}
					
		%>
		<td width="33%"><a
			href="ShowGoodsControlServlet?type=showdetail&id=<%=gb.getGoodsID()%>"><%=gb.getGoodsName()%></a></td>

		<%
			if ((i + 1) % 3 == 0)
					if ((i + 1) / 3 % 2 == 1)
						out.println("</tr>");

			}
		%>

		<tr>
			<td colspan="3" align="center">
				<%
					for (int i = 1; i <= pageCount; i++) {
				%> <a href="ShowGoodsControlServlet?type=showpage&pageNow=<%=i %>">[<%=i%>]
			</a> <%
 	}
 %>
			</td>
		</tr>
	</tbody>
</table>