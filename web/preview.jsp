<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
	<title>2Kyle16 Store</title>
	<link href = "stylesheet.css" rel ="stylesheet" type ="text/css">
</head>
<body>
	<h1>Search for the products you want to buy:</h1>
	<h2>All Products</h2>
	<% // Get product name to search for
	String id = request.getParameter("pid");
			
	Connection con = null;
	try{
		String url = "jdbc:mysql://cosc304.ok.ubc.ca/db_group6";
		String uid = "group6";
		String pw = "group6";
		con = DriverManager.getConnection(url, uid, pw);
		System.out.println("Connecting to db.");

		PreparedStatement p = null;
		NumberFormat currFormat = NumberFormat.getCurrencyInstance();
		p = con.prepareStatement("SELECT pname, cost, description, image FROM Product WHERE pid = ?");
		p.setString(1, id);
		ResultSet rst = p.executeQuery();
		String pid = rst.getString(1);
		String pname = rst.getString(2);
		Double cost = rst.getDouble(3);
		String image = rst.getString(4);
		out.println("<table>");
		out.println("<tr><td><img href=" + image + "</td>");
		out.println("<td><tr><a href=\"addcart.jsp?id="+ pid +"&name="+pname+"&cost="+ cost + "\">Add to Cart</a></tr>");
		out.println("<tr>" + pname + "</tr><tr>" + currFormat.format(cost) + "</tr></tr><td>");
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