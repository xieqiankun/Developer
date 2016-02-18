package com.qiankun.servlet;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.qiankun.model.*;

/**
 * Servlet implementation class ShoppingControlServlet
 */
@WebServlet("/ShoppingControlServlet")
public class ShoppingControlServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ShoppingControlServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


		String type= request.getParameter("type");

		MyCartBO cart = (MyCartBO)request.getSession().getAttribute("cart");
		if(cart == null){	
			cart = new MyCartBO();		
			request.getSession().setAttribute("cart", cart);
		}


		if(type.equals("add")){
			String id = request.getParameter("id");



			cart.addGoods(id, "1");


		} else if(type.equals("del")){

			String id = request.getParameter("id");

			cart.delGoods(id);

		} else if (type.equals("show")){

		} else if (type.equals("delall")){

			cart.delAll();

		} else if (type.equals("update")){

			String[] goodsID = request.getParameterValues("goodsid");
			String[] newNum = request.getParameterValues("newnum");
			if(goodsID != null)
				for(int i = 0; i < goodsID.length; i++){
					//System.out.println(goodsID[i]+ " : "+newNum[i] );

					cart.updatGoods(goodsID[i], newNum[i]);

				}


		}

		//	request.getSession().setAttribute("cart", cart);
		//	System.out.println("server: "+(cart.getGoodsNumByID(1+"")));

		ArrayList<GoodsBean> al = cart.showMyCart();

		request.setAttribute("cartresult", al);

		request.getRequestDispatcher("showMycart.jsp").forward(request, response);

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.doGet(request, response);
	}

}
