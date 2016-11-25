<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
	<title>Mack's Grocery</title>
	<link href = "stylesheet.css" rel ="stylesheet" type ="text/css">
</head>
<body>
	<h1>Search for the products you want to buy:</h1>
	<h2>All Products</h2>
	<% // Get product name to search for
	String id = request.getParameter("productId");
			
	Connection con = null;
	try{
		String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_group6;";
		String uid = "group6";
		String pw = "group6";
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		con = DriverManager.getConnection(url, uid, pw);
		System.out.println("Connecting to db.");

		PreparedStatement p = null;
		NumberFormat currFormat = NumberFormat.getCurrencyInstance();
		p = con.prepareStatement("SELECT pname, cost, description, image FROM Product WHERE pid = ?");
		p.setString(1, id);
		ResultSet rst = p.executeQuery();
		String pid = rst.getString(1);
		String pname = rst.getString(2);
		Double cost = rst.getDouble(3);  = rst.getString(1);
		out.println("<table>");
		out.println("<tr><td><a href=\"addcart.jsp?id="+ pid +"&name="+pname+"&cost="+ price + "\">Add to Cart</a></td>");
		out.println("<td>" + pname + "</td><td>" + currFormat.format(cost) + "</td></tr>");
		out.println("</table>");
		con.close();
	}catch(SQLException e){
		out.println("Error: " + e);
	}finally{
		if(con!=null){
			con.close();
		}
	}
	%>

</body>
</html>