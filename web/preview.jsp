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
	<h2>Product</h2>
	<a href = "listproducts.php">Back</a>
	<a href = "home.html">Home</a>
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
			out.println("<tr><td><input type='number' value='1' id='qty' size='3'></td>");
			out.println("<td><input type='button' value='Add to Cart' onclick=\'addcart(\""+pid+"\", \"" +pname+"\", \""+ cost+"\")\'></td></tr>");
			out.println("</table></td>");
			out.println("</table>");
			out.println("<p>"+ desc + "</p>");
			out.println("<a href=\"viewcart.jsp\">View Cart</a><br><a href=\"login.php\">Log in</a>");
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