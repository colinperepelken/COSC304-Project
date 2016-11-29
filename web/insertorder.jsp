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

<%
try {
	getConnection();
	//get parameters
	String shipAddress = request.getParameter("address");
	String shipType = request.getParameter("shipType");
	String payType = request.getParameter("payType");
	String shipCost = request.getParameter("shipCost")
	String cartTotal = request.getParameter("cartTotal")

	HashMap<String, ArrayList<Object>> itemList = (HashMap<String, ArrayList<Object>>) session.getAttribute("itemList");	
	PreparedStatement pstmt = null;
	
	out.println("<h1>Place Order</h1><p>Are these details correct?</p>");
	out.println("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>");

	String sql = "INSERT INTO CustomerOrder(cartTotal) VALUES (0)";
	pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
   	pstmt.executeUpdate();
   	ResultSet keys = pstmt.getGeneratedKeys();
   	keys.next();
   	int orderId = keys.getInt(1);
	double total = 0;
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = itemList.entrySet().iterator();
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();
	//TODO: insert into hasproduct
	
	while (iterator.hasNext())
	{ 	
		pstmt = con.prepareStatement("INSERT INTO HasProduct VALUES (?, ?)");
		Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		int pid = (Integer) product.get(0).intValue();
		pstmt.setString(orderId, pid);
		pstmt.executeUpdate();
	}
	
	out.println("</table><form>");//TODO: add form data location
	out.println("<input id='submit' type='submit' value='Place Order'>");
	out.println("</form>");

	

}catch(SQLException e){
	out.println(e);
}finally{
	closeConnection();
}
	
%>                       				


</body>
</html>