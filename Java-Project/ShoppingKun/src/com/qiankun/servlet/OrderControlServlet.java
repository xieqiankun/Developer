package com.qiankun.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.qiankun.model.MyCartBO;
import com.qiankun.model.OrderBeanBO;
import com.qiankun.model.OrderInfoBean;
import com.qiankun.model.UserBean;

/**
 * Servlet implementation class OrderControlServlet
 */
@WebServlet("/OrderControlServlet")
public class OrderControlServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public OrderControlServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		OrderBeanBO obb = new OrderBeanBO();
		
		MyCartBO cart =(MyCartBO)request.getSession().getAttribute("cart");
		
		UserBean user = (UserBean)request.getSession().getAttribute("username");
		
		OrderInfoBean oib = obb.addOrder(cart, user);
		if(oib != null){
			//success
			//send data to next page
			
			request.setAttribute("orderinfo", oib);
			
			request.getRequestDispatcher("shoppingOrderDetail.jsp").forward(request, response);
		}else{
			//request.getRequestDispatcher("shoppingCheckOut.jsp").forward(request, response);

			
		}
		
		
	
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	this.doGet(request, response);
	}

}
