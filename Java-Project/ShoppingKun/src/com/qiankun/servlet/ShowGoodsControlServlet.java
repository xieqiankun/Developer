package com.qiankun.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.qiankun.model.GoodsBean;
import com.qiankun.model.GoodsBeanBO;

/**
 * Servlet implementation class ShowGoodsControlServlet
 */
@WebServlet("/ShowGoodsControlServlet")
public class ShowGoodsControlServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ShowGoodsControlServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		//get type
		String type = request.getParameter("type");
		
		if(type.equals("showdetail")){
		
		//get goods id
		String goodsID = request.getParameter("id");
		//to call googsbeanBO
		GoodsBeanBO gbb = new GoodsBeanBO();
		GoodsBean gb = gbb.getGoodsBean(goodsID);
		request.setAttribute("goodsinfo", gb);
		
		request.getRequestDispatcher("showDetail.jsp").forward(request, response);
		
		} else if(type.equals("showpage")){
			
			//get page now
			String pageNow = request.getParameter("pageNow");
			
			
			request.getRequestDispatcher("index.jsp?s_pageNow="+pageNow).forward(request, response);
			
			
		}
		
		
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		this.doGet(request, response);
	}

}
