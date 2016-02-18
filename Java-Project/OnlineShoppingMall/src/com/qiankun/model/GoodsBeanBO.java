package com.qiankun.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class GoodsBeanBO {
	
	private ResultSet rs = null;
	private Connection ct = null;
	private PreparedStatement pstat= null;
	
	
	public int getPageCount(int pageSize){
		
		int pageCount = 0;
		int rowCount = 0;
		
		try {
			ct = new ConnDB().getCon();
			
			String sql = "select count(*) from goods";
			
			pstat = ct.prepareStatement(sql);
			
			rs = pstat.executeQuery();
			
			if(rs.next()){
				rowCount = rs.getInt(1);
				System.out.print(rowCount);
			}
			if(rowCount % pageSize == 0){
				pageCount = rowCount/pageSize;
			} else{
				pageCount = rowCount/pageSize +1;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally{
			close();
		}
		
		return pageCount;
		
	}
	
	//use id to return detail of goods
	public GoodsBean getGoodsBean(String id){
		
		GoodsBean gb = new GoodsBean();
		try{
			ct = new ConnDB().getCon();
			
			String sql = "select * from goods where id = ?";
			
			pstat = ct.prepareStatement(sql);
			
			pstat.setString(1, id);
			
			rs = pstat.executeQuery();
			
			if(rs.next()){
				gb.setGoodsID(rs.getInt(1));
				gb.setGoodsName(rs.getString(2));
				gb.setGoodsIntro(rs.getString(3));
				gb.setGoodsPrice(rs.getDouble(4));
				gb.setGoodsNum(rs.getInt(5));
				gb.setPublisher(rs.getString(6));
				gb.setType(rs.getString(7));
		
			}
			
		} catch(Exception e){
			e.printStackTrace();
		} finally{
			
			close();
	
		}
		
		return gb;
		
	}
	
	
	//seperate the page
	
	public ArrayList<GoodsBean> getGoodsByPage(int pageSize, int pageNow){
		
		ArrayList<GoodsBean> al = new ArrayList<GoodsBean>();
		
		try{
			
			ct = new ConnDB().getCon();
			
			String sql= "SELECT * FROM goods LIMIT "+(pageNow-1)*pageSize+","+pageSize;
			
			pstat = ct.prepareStatement(sql);
			
			rs = pstat.executeQuery();
			
			while(rs.next()){
				GoodsBean gb = new GoodsBean();
				
				gb.setGoodsID(rs.getInt(1));
				gb.setGoodsName(rs.getString(2));
				gb.setGoodsIntro(rs.getString(3));
				gb.setGoodsPrice(rs.getDouble(4));
				gb.setGoodsNum(rs.getInt(5));
				gb.setPublisher(rs.getString(6));
				gb.setType(rs.getString(7));
				
				al.add(gb);
			} 
		}catch (Exception e){
			e.printStackTrace();
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
