<%@ page import="java.sql.*"%>

<%!
	// User id, password, and server information
	String url = "jdbc:mysql://cosc304.ok.ubc.ca/db_group6";
	private String uid = "group6";
	private String pw = "group6";

	// Connection
	private Connection con = null;
%>

<%!
	//method to get connection
	public void getConnection() throws SQLException 
	{
		con = DriverManager.getConnection(url, uid, pw);
	}
   
	public void closeConnection() throws SQLException 
	{
		if (con != null)
			con.close();
		con = null;
	}
%>
