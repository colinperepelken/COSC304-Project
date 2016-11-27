<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
	<title>2Kyle16 Store</title>
	<link href = "2kyle16.css" rel ="stylesheet" type ="text/css">
	<script>
		function addcart(pid, pname, cost) {
			window.location.href ="addcart.jsp?pid=" + pid + "&name=" + pname +"&qty=" + document.getElementById('qty').value + "&cost=" + cost;

		}
	</script>
</head>
<body>
<div class = "mainDiv"><div id ="header"><img src="images/header.png"><br><font size="5.5"><a href="home.html">HOME </a>  <a href="listproducts.php">MERCH</a> <a href="listtickets.php">TICKETS</a>  <a href="showcart.jsp">CART</a> <a href="login.php">LOGIN</a> </font></div>
<div class = "content">
<center>
<br><br><br><br>
	
	<!--
	<h1>Product</h1>
	<a href = "listproducts.php">Back</a>
	<a href = "home.html">Home</a> -->
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
			out.println("<tr><td>" + currFormat.format(cost) + "</td></tr>"); // next line is addcart as submit button, gets info from text box
			out.println("<tr><td><input type='number' id='number' value='1' id='qty' size='1'>");
			out.print("<input type='button' id='submit' value='Add to Cart' onclick=\'addcart(\""+pid+"\", \"" +pname+"\", \""+ cost+"\")\'></td></tr>");
			out.println("</table></td>");
			out.println("</table>");
			out.println("<p><br>"+ desc + "</p>");
			//out.println("<a href=\"viewcart.jsp\">View Cart</a><br><a href=\"login.php\">Log in</a>");
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
<br><br><br>
</center>
</div></div>

<div id = "footer"><br><br> &copy; 2016 2Kyle16 inc. <br>Site by Brittany Miller, Maria Guenter, Colin Bernard, Zachery Grafton and Mackenzie Salloum</div>
</body>
</html>