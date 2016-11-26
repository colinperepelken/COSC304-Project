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
	<h2>Product</h2>
	<% // Get product name to search for
	String pid = request.getParameter("pid");
			
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
		p.setString(1, pid);
		ResultSet rst = p.executeQuery();
		while(rst.next()){
			String pname = rst.getString(1);
			Double cost = rst.getDouble(2);
			String desc = rst.getString(3);
			String image = rst.getString(4);
			out.println("<table>");
			out.println("<td><img src=\"images/products/" + image + "\"></td>");
			out.println("<td><table>");
			out.println("<tr><td>" + pname + "</td></tr>");
			out.println("<tr><td>" + currFormat.format(cost) + "</td></tr>");
			out.println("<tr><td><a href=\"addcart.jsp?id=" + pid + "&name=" + pname + "&cost=" + cost + "\">Add to Cart</a></td></tr>");
			out.println("</table></td>");
			out.println("</table>");
			out.println("<p>"+ desc + "</p>");
		}
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