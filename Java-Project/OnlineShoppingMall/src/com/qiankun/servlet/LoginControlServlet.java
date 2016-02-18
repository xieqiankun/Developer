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
import com.qiankun.model.UserBeanBO;

/**
 * Servlet implementation class LoginControlServlet
 */
@WebServlet("/LoginControlServlet")
public class LoginControlServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginControlServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String u = request.getParameter("username");
		String p = request.getParameter("password");
		
		
		UserBeanBO ubo = new UserBeanBO();
		boolean b = ubo.checkUser(u, p);
		
		if(b){
			UserBean ub = ubo.getUserBean(u);
			request.getSession().setAttribute("username", ub);
		//	System.out.print("password correct");
			
			MyCartBO cart = (MyCartBO)request.getSession().getAttribute("cart");
			
			ArrayList<GoodsBean> al = cart.showMyCart();
			
			request.setAttribute("showcart", al);
			
			//password right
			request.getRequestDispatcher("shoppingCheckOut.jsp").forward(request, response);
			
			
			
		}else{
			request.getRequestDispatcher("shoppingLogin.jsp").forward(request, response);
			
		}
		
	
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.doGet(request, response);
	}

}
