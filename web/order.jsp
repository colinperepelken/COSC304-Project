<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
	<title>Checkout</title>
	<link href = "2kyle16.css" rel ="stylesheet" type ="text/css">
</head>
<body>

<%
	Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
	if(isLoggedIn == null || isLoggedIn == false){
		response.sendRedirect("login.php");
	}
	else{
		HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
        Connection con == null;    
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
			
				PreparedStatement p = null;
				NumberFormat currFormat = NumberFormat.getCurrencyInstance();
				p = con.prepareStatement("SELECT pname, cost, description, image FROM Product WHERE pid = ?");
				p.setString(1, pid);
				ResultSet rst = p.executeQuery();

				
				// Enter order information into database
				sql = "INSERT INTO CustomerOrder (cartTotal) VALUES(0);";

				// Retrieve auto-generated key for orderId
				pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
				pstmt.setInt(1, num);
				pstmt.executeUpdate();
				ResultSet keys = pstmt.getGeneratedKeys();
				keys.next();
				orderId = keys.getInt(1);

				out.println("<h1>Your Order Summary</h1>");
					out.println("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>");

				double total =0;
				Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
				NumberFormat currFormat = NumberFormat.getCurrencyInstance();
							
				while (iterator.hasNext())
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

					sql = "INSERT INTO HasProduct VALUES(?, ?, ?)";
					pstmt = con.prepareStatement(sql);
					pstmt.setInt(1, orderId);
					pstmt.setInt(2, Integer.parseInt(productId));
					pstmt.setInt(3, qty);
					pstmt.executeUpdate();				
				}
				out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
								+"<td aling=\"right\">"+currFormat.format(total)+"</td></tr>");
				out.println("</table>");

				// Update order total
				sql = "UPDATE Orders SET totalAmount=? WHERE orderId=?";
				pstmt = con.prepareStatement(sql);
				pstmt.setDouble(1, total);
				pstmt.setInt(2, orderId);			
				pstmt.executeUpdate();						

				out.println("<h1>Order completed.  Will be shipped soon...</h1>");
				out.println("<h1>Your order reference number is: "+orderId+"</h1>");
				out.println("<h1>Shipping to customer: "+custId+" Name: "+custName+"</h1>");

				// Clear session variables (cart)
				session.setAttribute("productList", null);    
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
