package com.qiankun.controller;

import java.io.IOException;
import java.util.ArrayList;

import com.qiankun.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
//处理用户分页显示

/**
 * Servlet implementation class UserClServlet
 */
@WebServlet("/UserClServlet")
public class UserClServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//	System.out.println("I am here");

		//get flags
		String flag = (String)request.getParameter("flag");



		if(flag.equals("seperate")){
			String s_pageNow = request.getParameter("pageNow");
			try{

				int pageNow = Integer.parseInt(s_pageNow);
				UserBeanControl ubc = new UserBeanControl();

				//prepare data for wel.jsp
				ArrayList<UserBean> al = ubc.getResultByPage(pageNow, 3);
				int pageCount = ubc.getPageCount();
				//put al into request
				request.setAttribute("result", al);
				request.setAttribute("pageCount", pageCount+"");
				request.setAttribute("pageNow", pageNow+"");

				//go to wel
				request.getRequestDispatcher("wel.jsp").forward(request,response);


			} catch (Exception e){
				e.printStackTrace();
			}
		} else if(flag.equals("del")){
			String userID = request.getParameter("userID");

			UserBeanControl ubc = new UserBeanControl();
			boolean b = ubc.delUser(userID);
			if(b){
				//successfully del
				request.getRequestDispatcher("success.jsp").forward(request, response);
			} else{
				request.getRequestDispatcher("lose.jsp").forward(request, response);

			}

		} else if(flag.equals("adduser")){

			//	System.out.println("I am hree");

			String name = request.getParameter("username");
			String password = request.getParameter("password");

			UserBeanControl ubc =new UserBeanControl();

			if(ubc.addUser(name, password)){
				request.getRequestDispatcher("success.jsp").forward(request, response);

			} else{
				request.getRequestDispatcher("lose.jsp").forward(request, response);

			}

		} else if(flag.equals("update")){

			String id = request.getParameter("userid");

			String password = request.getParameter("password");

			UserBeanControl ubc =new UserBeanControl();
			if(ubc.updateUser(id, password)){
				request.getRequestDispatcher("success.jsp").forward(request, response);

			}else{
				request.getRequestDispatcher("lose.jsp").forward(request, response);

			}



		}

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.doGet(request, response);
	}

}
