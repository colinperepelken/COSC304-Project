<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ include file="connection.jsp" %>


<html>
<head>
	<title>Order History</title>
	<link href = "2kyle16.css" rel ="stylesheet" type ="text/css">
	<link rel="icon" href="images/favicon.png">
	<script>
	</script>
</head>
<body>
<div class = "mainDiv"><div id ="header"><img src="images/header.png"><br><font size="5.5"><a href="home.html">HOME </a>  <a href="listproducts.php">MERCH</a> <a href="listtickets.php">TICKETS</a>  <a href="showcart.jsp">CART</a> <a href="login.php">LOGIN</a> </font></div>
<div class = "content">
<center>
<%
try {
	getConnection();
	//get parameters
	Object cid = session.getAttribute("cid");
	
	PreparedStatement pstmt = null;
	pstmt = con.prepareStatement("SELECT * FROM CustomerOrder WHERE cid = ?");
	if(cid!= null){
		pstmt.setInt(1, new Integer((String)cid));
		ResultSet orders = pstmt.executeQuery();
		NumberFormat currFormat = NumberFormat.getCurrencyInstance();
		int count = 0;
		out.println("<table width='600px'>");
		out.println("<h1>Order History</h1>");
		while (orders.next())//print order info
		{	
			//count to see if there are orders
			count++;
			int oid = orders.getInt(1);
			double payCost = orders.getDouble(13);
			boolean hasShipped = orders.getBoolean("hasShipped");
			String status = (hasShipped ? "Shipped":"Processing");
			out.println("<tr><td style='text-align:left;vertical-align:top' width='200px'><b>Order Id: </b>" + oid + "<br>Order Total: " + currFormat.format(payCost) + "<br>Shipping Status: " + status + "</td>");
			
			pstmt = con.prepareStatement("SELECT p.pname as name, h.quantity as qty FROM HasProduct h, Product p WHERE h.oid=? AND p.pid = h.pid");
			pstmt.setInt(1, oid);
			ResultSet products = pstmt.executeQuery();
			//print out the products in the order
			//print out the products in the order
			out.println("<td width='200px'><table><tr><th align='left' >Product</th><th align='left'>Quantity</th></tr>");
			while(products.next()){
				String name = products.getString("name");
				int qty = products.getInt("qty");
				out.println("<tr><td align='left' width='200px'>" + name + "</td><td align='left'>" + qty+ "</td></tr>");

				
				
			}
			out.println("</table><br><br></td></tr>");
			
		}
		out.println("</table>");
		if(count ==0)
			out.println("<h1>You don't have any orders.</h1>");
			
	}else{
		out.println("<script>alert('You must be logged in to view this page.');window.location.href = 'login.php';</script>");
	}

}catch(SQLException e){
	out.println(e);
}finally{
	try
	{
		closeConnection();
	}
	catch (SQLException ex)
	{
		out.println(ex); 
	}
}
	
%>    
                   				
</center>
</div></div>

<div id = "footer"><br><br> &copy; 2016 2Kyle16 inc. <br>Site by Brittany Miller, Maria Guenter, Colin Bernard, Zachery Grafton and Mackenzie Salloum</div>
</body>
</html>