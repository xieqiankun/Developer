package com.qiankun.servlet;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.qiankun.model.GoodsBean;
import com.qiankun.model.MyCartBO;
import com.qiankun.model.UserBean;

/**
 * Servlet implementation class UserControlServlet
 */
@WebServlet("/UserLoginControlServlet")
public class UserLoginControlServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UserLoginControlServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		//mainly to verify if the user has already login
		
		UserBean ub = (UserBean)request.getSession().getAttribute("username");
		if(ub == null){
			
			
			request.getRequestDispatcher("shoppingLogin.jsp").forward(request,response);
		} else {
			//go to buy .jsp
			
			MyCartBO cart = (MyCartBO)request.getSession().getAttribute("cart");
			
			ArrayList<GoodsBean> al = cart.showMyCart();
			
			request.setAttribute("showcart", al);
			
			
			request.getRequestDispatcher("shoppingCheckOut.jsp").forward(request, response);
		}
	
	
	
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.doGet(request, response);
	}

}
