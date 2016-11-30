<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ include file="connection.jsp" %>


<html>
<head>
	<title>Checkout</title>
	<link href = "2kyle16.css" rel ="stylesheet" type ="text/css">
	<script>
	</script>
</head>
<body>

<div style="float: left;">
<%
if(session.getAttribute("username") != null) {
	String username = (String)session.getAttribute("username");
	out.println("Logged in as "+username+" <span><a href=\"logout.php\">Logout</a></span>");
} else {
	out.println("Logged in as Guest");
}
%>
</div>
<%
try {
	getConnection();
	if(session.getAttribute("username")!=null){
		HashMap<String, ArrayList<Object>> itemList = (HashMap<String, ArrayList<Object>>) session.getAttribute("itemList");	
		PreparedStatement pstmt = null;
		out.println("<h1>Your Order Summary</h1>");
		out.println("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>");

		double total = 0;
		Iterator<Map.Entry<String, ArrayList<Object>>> iterator = itemList.entrySet().iterator();
		NumberFormat currFormat = NumberFormat.getCurrencyInstance();
					
		while (iterator.hasNext())//print out cart info
		{ 
			Map.Entry<String, ArrayList<Object>> entry = iterator.next();
			ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
			String productId = (String) product.get(0);
			out.print("<tr><td>"+productId+"</td>");
			out.print("<td>"+product.get(1)+"</td>");
			out.print("<td align=\"center\">"+product.get(3)+"</td>");
			String price = (String) product.get(2);
			double pr = Double.parseDouble(price);
			int qty = ( (Integer)product.get(3)).intValue();
			out.print("<td align=\"right\">"+currFormat.format(pr)+"</td>");
			out.print("<td align=\"right\">"+currFormat.format(pr*qty)+"</td></tr>");
			out.println("</tr>");
			total = total +pr*qty;
		}
		out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td><td align=\"right\">"+currFormat.format(total)+"</td></tr>");
		
		pstmt = con.prepareStatement("SELECT * FROM ShippingOption");
		ResultSet ships = pstmt.executeQuery();
		pstmt = con.prepareStatement("SELECT * FROM PaymentMethod");
		ResultSet pays = pstmt.executeQuery();
		
		out.println("<form action='finalize.jsp'>");
		out.println("<tr><td>Enter your shipping address:<br>");
		out.println("Street:<br><input type='text' name='address'><br>");
		out.println("City:<br><input type='text' name='city'></td></tr>");
		
		out.println("<tr><td>Province:</td></tr><tr><td><select name='province'>");
		String[] provinces = {"AB","BC","MB","NB","NL","NS","NT","NU","ON","PE","QC","SK","YT"};
		for(String p:provinces){
			out.println("<option value=\""+p+"\">"+p+"</option>");
		}
		out.println("</select></td></tr>");	
		
		out.println("<tr><td>Country:</td></tr><tr><td><select name='country'>");
		out.println("<option value=\"United Kingdom\">United Kindom</option>");
		out.println("<option value=\"Canada\">Canada</option>");
		out.println("<option value=\"United States\">United States</option>");
		out.println("</select></td></tr>");

		// prints radio buttons for shipping and payment
		out.println("<tr><td>");
		while(ships.next()){
			String type = ships.getString(1);
			String cost = currFormat.format(ships.getDouble(2));
			out.println("<input name='shipType' type='radio' value=\""+ type +"\">" + type + " - " + cost + "<br>");
		}
		out.println("</td><td>");
		while(pays.next()){
			String type = pays.getString(1);
			out.println("<input name='payType' type='radio' value=\""+ type +"\">" + type+"<br>");
		}
		
		out.println("</td></table>");
		out.println("<input id='submit' type='submit' value='Confirm'>");
		out.println("</form>");

		//button to go to next page, where info is then entered into database
		
	}else{
		response.sendRedirect("login.php");//must be logged in to checkout
	}
}catch(SQLException e){
	out.println(e);
}finally{
	closeConnection();
}
	
%>                       				


</body>
</html>
