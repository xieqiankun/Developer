package com.qiankun.controller;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.qiankun.model.UserBean;
import com.qiankun.model.UserBeanControl;

/**
 * Servlet implementation class loginClServlet
 */
@WebServlet("/loginClServlet")
public class loginClServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//call model to complete the project
		String u = request.getParameter("username");
		String p = request.getParameter("password");
		//	System.out.println(u + "  " + p);
		UserBeanControl ubc = new UserBeanControl();
		if(ubc.checkUser(u, p)){

			//prepare data for wel.jsp
			ArrayList<UserBean> al = ubc.getResultByPage(1, 3);
			int pageCount = ubc.getPageCount();
			//put al into request
			request.setAttribute("result", al);
			request.setAttribute("pageCount", pageCount+"");
			request.setAttribute("pageNow", "1");

			
			request.getSession().setAttribute("myName", u);
			
			
			//this method is ineffient
			//	response.sendRedirect("wel.jsp");
			//转发的方法
			request.getRequestDispatcher("main.jsp").forward(request, response);;

		} else{

			request.getRequestDispatcher("login.jsp").forward(request, response);

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
