package com.qiankun.model;

import java.sql.Connection;
import java.sql.DriverManager;

public class ConnDB {

	private Connection ct = null;
	
	public Connection getCon(){
		
		String url = "jdbc:mysql://127.0.0.1:3306/shopping";
		String user = "root";
		String password = "123789";
		
		try{		
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			ct = DriverManager.getConnection(url,user,password);
		} catch (Exception e){
			e.printStackTrace();
		}
		
		return ct;		
	}
	
}
