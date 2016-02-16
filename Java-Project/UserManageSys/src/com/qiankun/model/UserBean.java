package com.qiankun.model;

public class UserBean {
	
	private int unum;
	private String name;
	private String passwd;
	//set some method
	public void setUserNum(int unum){
		this.unum = unum;
	}
	public int getUserNum(){
		return this.unum;
	}
	public void setUserName(String name){
		this.name = name;
	}
	public String getUserName(){
		return this.name;
	}
	public void setPasswd(String password){
		this.passwd = password;
	}
	public String getPasswd(){
		return this.passwd;
	}
	
}
