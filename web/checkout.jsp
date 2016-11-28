<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>

<html>
<head>
	<title>Checkout</title>
	<link href = "2kyle16.css" rel ="stylesheet" type ="text/css">
	<script>
	</script>
</head>
<body>

<%
	Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");//check session variable to see if user is logged in
	if(isLoggedIn == null || isLoggedIn == false){
		response.sendRedirect("login.php");//must be logged in to checkout
	}
	else{
		Integer cid = (Integer) session.getAttribute("cid");
		HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
        Connection con = null;    
		try{	
			if (productList == null)
				out.println("<h1>Your shopping cart is empty!</h1>");
			else{		
				// Get database connection
				String url = "jdbc:mysql://cosc304.ok.ubc.ca/db_group6";
				String uid = "group6";
				String pw = "group6";
				con = DriverManager.getConnection(url, uid, pw);
				System.out.println("Connecting to db.");
			
				PreparedStatement pstmt = null;
				String sql = null;
				out.println("<h1>Your Order Summary</h1>");
					out.println("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>");

				double total = 0;
				Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
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
				out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
								+"<td align=\"right\">"+currFormat.format(total)+"</td></tr>");
				out.println("</table>");
				//TODO: shipping info, payment info(radio buttons)
				
				pstmt = con.prepareStatement("SELECT * FROM ShippingType");
				ResultSet ships = pstmt.executeQuery();
				pstmt = con.prepareStatement("SELECT * FROM PaymentType");
				ResultSet pays = pstmt.executeQuery();
				out.println("<form action='finalize.jsp'>");
				while(ships.next()){
					String type = ships.getString(1);
					String cost = currFormat.format(ships.getDouble(2));
					out.println("<br><input name='shipType' type='radio' value=\""+ type +"\">" + type + " - " + cost);
				}
				while(pays.next()){
					String type = pays.getString(1);
					out.println("<br><input name='payType' type='radio' value=\""+ type +"\">" + type);
				}
				out.println("<input type='submit' value='Confirm'>");
				out.println("</form>");
				//button to go to next page, where info is then entered into database
			}
		}
		catch (SQLException ex){
			out.println(ex);
		}
		finally{
			try{
				if (con != null)
					con.close();
			}
			catch (SQLException ex){
				out.println(ex);
			}
		}
	}
%>                       				


</body>
</html>
