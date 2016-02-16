package com.qiankun.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class UserBeanControl {

	private Connection ct = null;
	private PreparedStatement ps = null;
	private ResultSet rs = null;
	private int rowCount = 0; //data total 
	private int pageCount = 0;
	
	public int getPageCount(){
		return pageCount;
	}
	
	//add user
	public boolean addUser(String name, String password){
		
		boolean b = false;
		ConDB db = new ConDB();
		ct = db.getCon();
		try{
			String sql = "INSERT INTO users(name,passwd) VALUES('"+name+"','"+password+"')";
			
			ps = ct.prepareStatement(sql);
			
			int i = ps.executeUpdate();
			
			if(i == 1){
				b = true;
			}
			
			
		} catch(Exception e){
			e.printStackTrace();
		} finally{
			this.close();
		}
		
		return b;
		
		
	}

	
	//change user
	public boolean updateUser(String id,  String password){
		boolean b = false;
		ConDB db = new ConDB();
		ct = db.getCon();
		try{
			String sql = "UPDATE users SET passwd="+password+" WHERE unum="+ id;
			
			ps = ct.prepareStatement(sql);
			int i = ps.executeUpdate();
			if(i == 1){
				b = true;
			}
			
			
		} catch(Exception e){
			e.printStackTrace();
		} finally{
			this.close();
		}
		
		return b;
		
	}
	
	
	
	//del User
	public boolean delUser(String id){
		boolean b = false;
		ConDB db = new ConDB();
		ct = db.getCon();
		try{
			String sql = "DELETE FROM users WHERE unum ="+ id;
			
			ps = ct.prepareStatement(sql);
			int i = ps.executeUpdate();
			if(i == 1){
				b = true;
			}
			
			
		} catch(Exception e){
			e.printStackTrace();
		} finally{
			this.close();
		}
		
		return b;
		
	}
	
	
	
	
	//分页显示结果
	public ArrayList<UserBean> getResultByPage(int pageNow, int pageSize){
		
		ArrayList<UserBean> al = new ArrayList<UserBean>();
		
		
		
		ConDB db = new ConDB();
		ct = db.getCon();
		try{
		ps = ct.prepareStatement("SELECT count(*) FROM users");

		rs = ps.executeQuery();
		

		if(rs.next()){
			rowCount = rs.getInt(1);
		}

		if(rowCount % pageSize == 0){
			pageCount = rowCount/pageSize;
		}
		else {
			pageCount = rowCount/pageSize + 1;
		}
		
		//System.out.println(pageCount+" here "+rowCount);

		ps = ct.prepareStatement("SELECT * FROM users LIMIT "+(pageNow-1)*pageSize+","+pageSize);
				//+ "WHERE umun NOT IN (SELECT  unum FROM student LIMIT "+pageSize * (pageNow - 1)+")");

		rs = ps.executeQuery();
		//封装rs到userbean
		while(rs.next()){
			UserBean ub = new UserBean();
			ub.setUserNum(rs.getInt(1));
			ub.setUserName(rs.getString(2));
			ub.setPasswd(rs.getString(3));
			
			al.add(ub);
			
		}
		
		
		} catch (Exception e){
			e.printStackTrace();
		} finally{
			this.close();
		}

		return al;
	}
	
	
	//验证用户
	public boolean checkUser(String u, String p){

		boolean b = false;	

		try{

			ConDB db = new ConDB();
			ct = db.getCon();

			ps = ct.prepareStatement("SELECT passwd FROM users WHERE name = ? LIMIT 1");
			ps.setString(1, u);

			rs = ps.executeQuery();

			if(rs.next()){

				String dbPassword = rs.getString(1);

				if(dbPassword.equals(p))
					b = true;

			} else {

			}		
		} catch(Exception e){
			e.printStackTrace();
		} finally {
			this.close();
		}

		return b;

	}


	public void close(){
		try{
			if(rs != null){
				rs.close();
				rs = null;
			}
			if(ps != null){
				ps.close();
				ps = null;
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
