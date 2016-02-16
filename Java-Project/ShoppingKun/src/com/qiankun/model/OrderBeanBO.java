package com.qiankun.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

public class OrderBeanBO {
	//do something to orderbean and orderdetailbean
	
	private ResultSet rs = null;
	private Connection ct = null;
	private PreparedStatement pstat= null;
	
	
	

	
	public OrderInfoBean addOrder(MyCartBO cart, UserBean user){
		int userId = user.getId();
		OrderInfoBean oib = null;
		
		try{
			
			ct = new ConnDB().getCon();
			int orderId = 0;

			
			String sql = "insert into orders values(null,?,?)";
			pstat = ct.prepareStatement(sql);
			pstat.setInt(1, userId);
			pstat.setDouble(2, cart.getTotalExpanse());
			
			int a = pstat.executeUpdate();
			if(a == 1){
				oib = new OrderInfoBean();
				
				pstat = ct.prepareStatement("select max(id) from orders");
				rs = pstat.executeQuery();
				if(rs.next()){
					
					orderId = rs.getInt(1);
				}
				
				//success add into orders
				//next to write into orderdetail
				ArrayList<GoodsBean> al = cart.showMyCart();
				
				Statement sm = ct.createStatement();
				
				for(int i = 0; i<al.size(); i++){
					
					GoodsBean gb = (GoodsBean)al.get(i);
					sm.addBatch("insert into orderdetail values("+orderId+","+gb.getGoodsID()
							+","+cart.getGoodsNumByID(gb.getGoodsID()+"")+")");
					
				}
				
				sm.executeBatch();
				
				oib.setAddr(user.getAddr());
				oib.setEmail(user.getEmail());
				oib.setOrderId(orderId);
				oib.setPhone(user.getPhone());
				oib.setTotalPrice(cart.getTotalExpanse());
				oib.setUserId(userId);
				oib.setUserName(user.getUserName());
				

				
			}else{
				
				
			}
			
		}catch (Exception e){
			e.printStackTrace();
		} finally{
			close();
			
		}
		
		return oib;
		
		
	}
	
	
	
	public void close(){
		try{
			if(rs != null){
				rs.close();
				rs = null;
			}
			if(pstat != null){
				pstat.close();
				pstat = null;
			}
			if(ct != null){
				ct.close();
				ct = null;
			}

		} catch(Exception e){
			e.printStackTrace();
		}
	}

}
