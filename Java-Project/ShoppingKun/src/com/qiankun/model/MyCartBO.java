package com.qiankun.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

public class MyCartBO {
	private ResultSet rs = null;
	private Connection ct = null;
	private PreparedStatement pstat= null;
	private double totalPrice= 0.0;

	private HashMap<String,String> hm = new HashMap<String,String>();

	
	public double getTotalExpanse(){
		
		return totalPrice;
		
	}
	
	
	
	//get goods num by id
	public String getGoodsNumByID(String id){
		
		return hm.get(id);
		
	}
	
	
	//add to cart
	public void addGoods(String id, String num){

		hm.put(id, num);
	}

	//del from cart
	public void delGoods(String id){

		hm.remove(id);
	}

	//empty all

	public void delAll(){

		hm.clear();
	}

	// change number
	public void updatGoods(String id, String num){
		
		hm.put(id, num);
	}
	//show cart

	public ArrayList<GoodsBean> showMyCart(){

		ArrayList<GoodsBean> al = new ArrayList<GoodsBean>();
		//reset total price
		this.totalPrice = 0.0;


		try{


			StringBuffer sb = new StringBuffer();
			sb.append('(');

			Iterator<String> it = hm.keySet().iterator();
			while(it.hasNext()){

				String id = it.next();
				sb.append(id);
				sb.append(',');
			}
			sb.deleteCharAt(sb.length()-1);
			sb.append(')');
			String sql= "select * from goods where id in"+sb.toString();

			ct = new ConnDB().getCon();
			pstat = ct.prepareStatement(sql);
			rs = pstat.executeQuery();
			
			while (rs.next()){
				GoodsBean gb = new GoodsBean();
				int id = rs.getInt(1);
				gb.setGoodsID(id);
				gb.setGoodsName(rs.getString(2));
				gb.setGoodsIntro(rs.getString(3));
				double price = rs.getDouble(4);
				gb.setGoodsPrice(price);
				gb.setGoodsNum(rs.getInt(5));
				gb.setPublisher(rs.getString(6));
				gb.setType(rs.getString(7));

				this.totalPrice = this.totalPrice + price * Integer.parseInt(hm.get(id+""));
				
				al.add(gb);


			}



		} catch (Exception e){

		} finally{
			close();
		}
		return al;

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
