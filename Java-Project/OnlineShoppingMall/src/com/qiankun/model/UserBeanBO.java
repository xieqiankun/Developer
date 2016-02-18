package com.qiankun.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserBeanBO {

	private ResultSet rs = null;
	private Connection ct = null;
	private PreparedStatement pstat= null;
	
	
	//use username return userbean
	
	public UserBean getUserBean(String u){
		
		UserBean ub = new UserBean();
		
		try{
			ct = new ConnDB().getCon();
			String sql = "select * from user where username=? limit 1";
			pstat = ct.prepareStatement(sql);
			pstat.setString(1, u);
			rs = pstat.executeQuery();
			if(rs.next()){
				ub.setId(rs.getInt(1));
				ub.setUserName(rs.getString(2));
				ub.setPassword(rs.getString(3));
				ub.setPhone(rs.getString(4));
				ub.setAddr(rs.getString(5));
				ub.setEmail(rs.getString(6));	
			}			
		} catch(Exception e){
			e.printStackTrace();
			
		} finally{
			
			close();
		}
		return ub;
	}
	
	
	//check user
	
	public boolean checkUser(String u, String p){
		boolean b = false;
		
		if(u=="" ||p== "") return false;
		
		String p_db = null;
		
		try{
			
			ct = new ConnDB().getCon();
			
			String sql = "select password from user where username=? limit 1";
			
			pstat  = ct.prepareStatement(sql);
			
			pstat.setString(1, u);
			
			rs = pstat.executeQuery();
			
			if(rs.next()){
				
				p_db = rs.getString(1);
				
			}
			if(p_db.equals(p)){
				b = true;			
			}		
		} catch(Exception e){	
			e.printStackTrace();	
		} finally{		
			close();
		}
		return b;
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
